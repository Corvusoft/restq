/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_ACCEPT_H
#define _RESTQ_DETAIL_RULE_ACCEPT_H 1

//System Includes
#include <map>
#include <list>
#include <regex>
#include <string>
#include <memory>
#include <utility>
#include <functional>

//Project Includes
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>
#include <corvusoft/restq/detail/rule/content_length.hpp>
#include <corvusoft/restq/detail/rule/content_language.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::map;
using std::list;
using std::regex;
using std::string;
using std::multimap;
using std::function;
using std::shared_ptr;
using std::regex_constants::icase;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Accept final : public Rule
        {
            public:
                Accept( const map< string, shared_ptr< Formatter > >& formats ) : Rule( ),
                    m_formats( formats )
                {
                    return;
                }
                
                virtual ~Accept( void )
                {
                    return;
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto header = request->get_header( "Accept" );
                    
                    for ( const auto& format : m_formats )
                    {
                        if ( regex_match( header, regex( format.first, icase ) ) )
                        {
                            session->set( "accept-format", format.second );
                            session->set( "accept", format.second->get_mime_type( ) );
                            return callback( session );
                        }
                    }
                    
                    static const string body = "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept header sent in the request.";
                    not_acceptable_handler( session, body );
                }
                
                static void not_acceptable_handler( const shared_ptr< restbed::Session > session, const string& message )
                {
                    Bytes body;
                    
                    if ( not session->has( "accept-format" ) )
                    {
                        body = String::to_bytes( message );
                    }
                    else
                    {
                        const list< multimap< string, Bytes > > values { {
                                { "status", { '4', '0', '6' } },
                                { "type",   { 'e', 'r', 'r', 'o', 'r' } },
                                { "code",   { '4', '0', '0', '0', '6' } },
                                { "title",  { 'N', 'o', 't', ' ', 'A', 'c', 'c', 'e', 'p', 't', 'a', 'b', 'l', 'e' } },
                                { "message", String::to_bytes( message ) }
                            } };
                            
                        const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                        body = formatter->compose( values, session->get( "style" ) );
                    }
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type", ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                    };
                    
                    const bool echo = session->get( "echo" );
                    ( echo ) ? session->close( NOT_ACCEPTABLE, body, headers ) : session->close( NOT_ACCEPTABLE, headers );
                }
                
            private:
                const map< string, shared_ptr< Formatter > >& m_formats;
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_ACCEPT_H */
