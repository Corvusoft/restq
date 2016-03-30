/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_EXPECT_H
#define _RESTQ_DETAIL_RULE_EXPECT_H 1

//System Includes
#include <string>
#include <memory>
#include <functional>

//Project Includes
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
        class Expect final : public Rule
        {
            public:
                Expect( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Expect( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_header( "Expect" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& ) final override
                {
                    static const string message = "The exchange is refusing to process the request because a request expectation failed; not supported.";
                    return ErrorHandlerImpl::expectation_failed( message, session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_EXPECT_H */
