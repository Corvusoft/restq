/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_PAGING_H
#define _RESTQ_DETAIL_RULE_PAGING_H 1

//System Includes
#include <string>
#include <memory>
#include <limits>
#include <utility>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::pair;
using std::size_t;
using std::string;
using std::function;
using std::make_pair;
using std::shared_ptr;
using std::numeric_limits;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class Paging final : public Rule
        {
            public:
                Paging( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Paging( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    
                    size_t index = request->get_query_parameter( "index", numeric_limits< size_t >::min( ) );
                    size_t limit = request->get_query_parameter( "limit", numeric_limits< size_t >::max( ) );
                    
                    session->set( "paging", make_pair( index, limit ) );
                    callback( session );
                }
                
                static const pair< size_t, size_t > default_value;
        };
        
        const pair< size_t, size_t > Paging::default_value = make_pair( numeric_limits< size_t >::min( ), numeric_limits< size_t >::max( ) );
    }
}

#endif  /* _RESTQ_DETAIL_RULE_PAGING_H */
