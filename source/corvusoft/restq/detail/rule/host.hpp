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
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto host = request->get_header( "Host", String::lowercase );
                    
                    session->set( "host", host );
                    
                    return not Uri::is_valid( host );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& ) final override
                {
                    static const list< multimap< string, Bytes > > values
                    {
                        {
                            { "status", String::to_bytes( "400" ) },
                            { "code", String::to_bytes( "40000" ) },
                            { "type", String::to_bytes( "error" ) },
                            { "title", String::to_bytes( "Bad Request" ) },
                            { "message", String::to_bytes( "The exchange is refusing to process the request because it was missing or contained a malformed Host request-header." ) }
                        } };
                        
                    const bool echo = session->get( "echo" );
                    const bool styled = session->get( "style" );
                    const string accept = session->get( "accept" );
                    const string charset = session->get( "charset" );
                    const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                    
                    const auto body = formatter->compose( values, styled );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                        
                    };
                    
                    ( echo ) ? session->close( BAD_REQUEST, body, headers ) : session->close( BAD_REQUEST, headers );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_HOST_H */
