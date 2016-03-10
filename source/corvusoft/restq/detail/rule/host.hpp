/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_HOST_H
#define _RESTQ_DETAIL_RULE_HOST_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/uri.hpp>
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::list;
using std::string;
using std::function;
using std::multimap;
using std::to_string;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Host final : public Rule
        {
            public:
                Host( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Host( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< restbed::Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto host = request->get_header( "Host", String::lowercase );
                    
                    session->set( "host", host );
                    
                    return not Uri::is_valid( host );
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& ) final override
                {
                    static const string message = "The exchange is refusing to process the request because it was missing or contained a malformed Host request-header.";
                    bad_request_handler( message, session );
                }
                
                static void bad_request_handler( const string& message, const shared_ptr< restbed::Session >& session )
                {
                    const list< multimap< string, Bytes > > values { {
                            { "status", { '4', '0', '0' } },
                            { "type", { 'e', 'r', 'r', 'o', 'r' } },
                            { "code", { '4', '0', '0', '0', '0' } },
                            { "title", { 'B', 'a', 'd', ' ', 'R', 'e', 'q', 'u', 'e', 's', 't' } },
                            { "message", String::to_bytes( message ) }
                        } };
                        
                    const shared_ptr< Formatter > composer = session->get( "accept-format" );
                    const auto body = composer->compose( values, session->get( "style" ) );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                    };
                    
                    const bool echo = session->get( "echo" );
                    ( echo ) ? session->close( BAD_REQUEST, body, headers ) : session->close( BAD_REQUEST, headers );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_HOST_H */
