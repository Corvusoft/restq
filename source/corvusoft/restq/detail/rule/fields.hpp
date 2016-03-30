/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_FIELDS_H
#define _RESTQ_DETAIL_RULE_FIELDS_H 1

//System Includes
#include <set>
#include <map>
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
        class Fields final : public Rule
        {
            public:
                Fields( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Fields( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto parameters = request->get_query_parameters( "fields" );
                    
                    set< string > fields = { };
                    
                    for ( const auto parameter : parameters )
                    {
                        for ( auto value : String::split( String::lowercase( parameter.second ), ',' ) )
                        {
                            fields.insert( value );
                        }
                    }
                    
                    session->set( "fields", fields );
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_FIELDS_H */
