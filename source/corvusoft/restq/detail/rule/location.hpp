/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_LOCATION_H
#define _RESTQ_DETAIL_RULE_LOCATION_H 1

//System Includes
#include <map>
#include <list>
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
using std::list;
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
        class Location final : public Rule
        {
            public:
                Location( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Location( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > ) final override
                {
                    return false;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( const shared_ptr< Session >& session, const list< multimap< string, Bytes > >& resources )
                {
                    const string host = session->get( "host" );
                    const auto type = resources.back( ).lower_bound( "type" )->second;
                    
                    auto location = String::format( "http://%s/%.*ss", host.data( ), type.size( ), type.data( ) );
                    
                    if ( resources.size( ) == 1 )
                    {
                        location += "/" + String::to_string( resources.back( ).lower_bound( "key" )->second );
                    }
                    else
                    {
                        location += "?keys=";
                        
                        for ( const auto resource : resources )
                        {
                            location += String::to_string( resource.lower_bound( "key" )->second ) + ",";
                        }
                        
                        location = String::trim_lagging( location, "," );
                    }
                    
                    return location;
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_LOCATION_H */
