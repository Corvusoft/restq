/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_MD5_H
#define _RESTQ_DETAIL_RULE_CONTENT_MD5_H 1

//System Includes
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <md5.h>
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::string;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class ContentMD5 final : public Rule
        {
            public:
                ContentMD5( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~ContentMD5( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_header( "Content-MD5" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto body = request->get_body( );
                    const auto checksum = make( body );
                    
                    if ( checksum not_eq request->get_header( "Content-MD5", String::lowercase ) )
                    {
                        return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the entity-body failed Content-MD5 end-to-end message integrity check.", session );
                    }
                    
                    callback( session );
                }
                
                static string make( const Bytes& value )
                {
                    md5_state_t state;
                    md5_byte_t digest[ 16 ];
                    md5_init( &state );
                    md5_append( &state, static_cast< const md5_byte_t* >( &value[ 0 ] ), value.size( ) );
                    md5_finish( &state, digest );
                    
                    static const char* character_set = "0123456789abcdef";
                    
                    string checksum = String::empty;
                    
                    for ( auto byte : digest )
                    {
                        checksum.push_back( character_set[ byte >> 4 ] );
                        checksum.push_back( character_set[ byte & 15 ] );
                    }
                    
                    return checksum;
                }
                
                static string make( const string& value )
                {
                    return make( String::to_bytes( value ) );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_MD5_H */
