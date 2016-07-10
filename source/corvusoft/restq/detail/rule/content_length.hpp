/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_LENGTH_H
#define _RESTQ_DETAIL_RULE_CONTENT_LENGTH_H 1

//System Includes
#include <memory>
#include <cstddef>
#include <ciso646>
#include <algorithm>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::size_t;
using std::all_of;
using std::function;
using std::to_string;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

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
                    
                    if ( value.empty( ) or not all_of( value.begin( ), value.end( ), ::isdigit ) )
                    {
                        static const string message = "The exchange refuses to accept the request without a well defined content-length entity header.";
                        return ErrorHandlerImpl::length_required( message, session );
                    }
                    
                    size_t length = request->get_header( "Content-Length", 0 );
                    session->set( "content-length", length );
                    
                    session->fetch( length, [ callback ]( const shared_ptr< Session >& session, const Bytes& )
                    {
                        callback( session );
                    } );
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
