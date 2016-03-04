/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H
#define _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>
#include <corvusoft/restq/detail/rule/content_length.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/string.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::list;
using std::string;
using std::function;
using std::multimap;
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
        class ContentEncoding final : public Rule
        {
            public:
                ContentEncoding( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~ContentEncoding( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_header( "Content-Encoding" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto encoding = request->get_header( "Content-Encoding", String::lowercase );
                    
                    if ( encoding.empty( ) or encoding == "identity" or encoding == "*" )
                    {
                        return callback( session );
                    }
                    
                    static const list< multimap< string, Bytes > > values { {
                            { "status", String::to_bytes( "415" ) },
                            { "code", String::to_bytes( "40015" ) },
                            { "type", String::to_bytes( "error" ) },
                            { "title", String::to_bytes( "Unsupported Media Type" ) },
                            { "message", String::to_bytes( "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-encoding header sent in the request." ) }
                        } };
                        
                    const bool echo = session->get( "echo" );
                    const bool styled = session->get( "style" );
                    const string accept = session->get( "accept" );
                    const string charset = session->get( "charset" );
                    const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                    
                    const auto body = formatter->compose( values, styled );
                    
                    const multimap< string, string > headers
                    {
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Date", Date::make( ) }
                    };
                    
                    ( echo ) ? session->close( UNSUPPORTED_MEDIA_TYPE, body, headers ) : session->close( UNSUPPORTED_MEDIA_TYPE, headers );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H */
