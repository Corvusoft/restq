/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_LENGTH_H
#define _RESTQ_DETAIL_RULE_CONTENT_LENGTH_H 1

//System Includes
#include <map>
#include <list>
#include <memory>
#include <cstddef>
#include <ciso646>
#include <algorithm>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>
#include <corvusoft/restq/detail/rule/content_language.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::list;
using std::all_of;
using std::size_t;
using std::function;
using std::multimap;
using std::to_string;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class ContentLength final : public Rule
        {
            public:
                ContentLength( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~ContentLength( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto method = request->get_method( String::lowercase );
                    
                    return method == "put" or method == "post" or request->has_header( "Content-Length" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto value = request->get_header( "Content-Length" );
                    
                    if ( not value.empty( ) and all_of( value.begin( ), value.end( ), ::isdigit ) )
                    {
                        size_t length = 0;
                        request->get_header( "Content-Length", length );
                        session->set( "content-length", length );
                        
                        session->fetch( length, [ callback ]( const shared_ptr< Session >& session, const Bytes& )
                        {
                            callback( session );
                        } );
                    }
                    else
                    {
                        static const list< multimap< string, Bytes > > values { {
                                { "status", String::to_bytes( "411" ) },
                                { "type", String::to_bytes( "error" ) },
                                { "code", String::to_bytes( "40011" ) },
                                { "title", String::to_bytes( "Length Required" ) },
                                { "message", String::to_bytes( "The exchange refuses to accept the request without a well defined content-length entity header." ) }
                            } };
                            
                        const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                        const auto body = formatter->compose( values, session->get( "style" ) );
                        
                        const multimap< string, string > headers
                        {
                            { "Date", Date::make( ) },
                            { "Content-MD5", ContentMD5::make( body ) },
                            { "Content-Language", ContentLanguage::make( ) },
                            { "Content-Type",  ContentType::make( session ) },
                            { "Content-Length", ContentLength::make( body ) }
                        };
                        
                        const bool echo = session->get( "echo" );
                        ( echo ) ? session->close( LENGTH_REQUIRED, body, headers ) : session->close( LENGTH_REQUIRED, headers );
                    }
                }
                
                static string make( const Bytes& body )
                {
                    return ::to_string( body.size( ) );
                }
                
                static string make( const string& body )
                {
                    return ::to_string( body.size( ) );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_LENGTH_H */
