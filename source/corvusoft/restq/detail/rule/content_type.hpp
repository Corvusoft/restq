/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_TYPE_H
#define _RESTQ_DETAIL_RULE_CONTENT_TYPE_H 1

//System Includes
#include <map>
#include <list>
#include <regex>
#include <string>
#include <memory>
#include <ciso646>
#include <utility>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_language.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::map;
using std::list;
using std::regex;
using std::string;
using std::multimap;
using std::function;
using std::to_string;
using std::shared_ptr;
using std::regex_constants::icase;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class ContentType final : public Rule
        {
            public:
                ContentType( const map< string, shared_ptr< Formatter > >& formats ) : Rule( ),
                    m_formats( formats )
                {
                    return;
                }
                
                virtual ~ContentType( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto method = request->get_method( String::lowercase );
                    
                    return method == "put" or method == "post" or request->has_header( "Content-Type" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto header = request->get_header( "Content-Type" );
                    
                    for ( const auto& format : m_formats )
                    {
                        if ( regex_match( header, regex( format.first, icase ) ) )
                        {
                            session->set( "content-format", format.second );
                            return callback( session );
                        }
                    }
                    
                    static const string message = "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request.";
                    unsupported_media_type_handler( message, session );
                }
                
                static void unsupported_media_type_handler( const string message, const shared_ptr< Session > session )
                {
                    const list< multimap< string, Bytes > > values { {
                            { "status", String::to_bytes( "415" ) },
                            { "code", String::to_bytes( "40015" ) },
                            { "type", String::to_bytes( "error" ) },
                            { "message", String::to_bytes( message ) },
                            { "title", String::to_bytes( "Unsupported Media Type" ) }
                        } };
                        
                    const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                    const auto body = formatter->compose( values, session->get( "style" ) );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ::to_string( body.size( ) ) }
                    };
                    
                    const bool echo = session->get( "echo" );
                    ( echo ) ? session->close( UNSUPPORTED_MEDIA_TYPE, body, headers ) : session->close( UNSUPPORTED_MEDIA_TYPE, headers );
                }
                
                static string make( const shared_ptr< Session >& session )
                {
                    const string charset = session->get( "charset", string( "utf-8" ) );
                    const string accept = session->get( "accept", string( "text/plain" ) );
                    
                    return String::format( "%s; charset=%s", accept.data( ), charset.data( ) );
                }
                
            private:
                const map< string, shared_ptr< Formatter > >& m_formats;
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_TYPE_H */
