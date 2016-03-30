/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_KEYS_H
#define _RESTQ_DETAIL_RULE_KEYS_H 1

//System Includes
#include <vector>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::string;
using std::vector;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class Keys final : public Rule
        {
            public:
                Keys( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Keys( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    vector< string > keys = session->get( "keys", vector< string >( ) );
                    
                    const auto parameters = session->get_request( )->get_query_parameters( "keys" );
                    
                    for ( auto parameter : parameters )
                    {
                        const auto values = String::split( String::lowercase( parameter.second ), ',' );
                        keys.insert( keys.end( ), values.begin( ), values.end( ) );
                    }
                    
                    session->set( "keys", keys );
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_KEYS_H */
