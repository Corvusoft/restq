/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_RANGE_H
#define _RESTQ_DETAIL_RULE_RANGE_H 1

//System Includes
#include <string>
#include <memory>
#include <functional>

//Project Includes

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::string;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;
using restbed::Session;

namespace restq
{
    namespace detail
    {
        class Range final : public Rule
        {
            public:
                Range( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Range( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_header( "Range" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    session->set_header( "Accept-Ranges", "none" );
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_RANGE_H */
