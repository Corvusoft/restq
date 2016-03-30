/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H
#define _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H 1

//System Includes
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::string;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

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
                    
                    static const string message = "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-encoding header sent in the request.";
                    ErrorHandlerImpl::unsupported_media_type( message, session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H */
