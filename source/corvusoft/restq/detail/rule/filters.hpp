/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_FILTERS_H
#define _RESTQ_DETAIL_RULE_FILTERS_H 1

//System Includes
#include <map>
#include <set>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::set;
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
        class Filters final : public Rule
        {
            public:
                Filters( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Filters( void )
                {
                    return;
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    static const set< const string > reserved = { "echo", "keys", "style", "index", "limit", "fields" };
                    
                    const auto request = session->get_request( );
                    const auto parameters = request->get_query_parameters( );
                    
                    multimap< string, Bytes > filters = { };
                    
                    for ( const auto parameter : parameters )
                    {
                        const auto name = String::lowercase( parameter.first );
                        
                        if ( reserved.count( name ) == 0 )
                        {
                            for ( const auto value : String::split( parameter.second, ',' ) )
                            {
                                filters.insert( make_pair( name, String::to_bytes( value ) ) );
                            }
                        }
                    }
                    
                    session->set( "filters", filters );
                    session->set( "filtered_parameters", filters );
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_FILTERS_H */
