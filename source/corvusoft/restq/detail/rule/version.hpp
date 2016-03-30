/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_VERSION_H
#define _RESTQ_DETAIL_RULE_VERSION_H 1

//System Includes
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class Version final : public Rule
        {
            public:
                Version( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Version( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto version = request->get_version( );
                    
                    if ( version not_eq 1.0 and version not_eq 1.1 )
                    {
                        const auto message = "The exchange is only capable of processing request entities which conform to HTTP 1.0 and 1.1 characteristics.";
                        return ErrorHandlerImpl::http_version_not_supported( message, session );
                    }
                    
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_VERSION_H */
