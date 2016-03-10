/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_STYLE_H
#define _RESTQ_DETAIL_RULE_STYLE_H 1

//System Includes
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::string;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Style final : public Rule
        {
            public:
                Style( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Style( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto parameters = request->get_query_parameters( "style" );
                    
                    session->set( "style", false );
                    
                    for ( const auto parameter : parameters )
                    {
                        const auto value = String::lowercase( parameter.second );
                        session->set( "style", ( value == "true" or value == "yes" or value == "on" or value == "1" ) ? true : false );
                    }
                    
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_STYLE_H */
