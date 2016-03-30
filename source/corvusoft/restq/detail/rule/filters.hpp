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
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::set;
using std::string;
using std::function;
using std::multimap;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

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
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    static const auto reserved = set< string > { "echo", "keys", "style", "index", "limit", "fields", "type", "include" };
                    
                    const auto request = session->get_request( );
                    const auto parameters = request->get_query_parameters( );
                    
                    auto filters = multimap< string, Bytes > { };
                    auto inclusive_filters = multimap< string, Bytes > { };
                    auto exclusive_filters = multimap< string, Bytes > { };
                    
                    for ( const auto parameter : parameters )
                    {
                        const auto name = String::lowercase( parameter.first );
                        
                        if ( reserved.count( name ) == 0 )
                        {
                            const auto value = parameter.second;
                            
                            if ( value.find( ',' ) not_eq string::npos )
                            {
                                for ( const auto item : String::split( value, ',' ) )
                                {
                                    inclusive_filters.insert( make_pair( name, String::to_bytes( item ) ) );
                                }
                            }
                            else
                            {
                                exclusive_filters.insert( make_pair( name, String::to_bytes( value ) ) );
                            }
                            
                            filters.insert( make_pair( name, String::to_bytes( value ) ) );
                        }
                    }
                    
                    session->set( "filters", filters );
                    session->set( "inclusive_filters", inclusive_filters );
                    session->set( "exclusive_filters", exclusive_filters );
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_FILTERS_H */
