/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_ECHO_H
#define _RESTQ_DETAIL_RULE_ECHO_H 1

//System Includes
#include <map>
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
using std::multimap;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Echo final : public Rule
        {
            public:
                Echo( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Echo( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    
                    if ( request->get_method( String::lowercase ) == "head" )
                    {
                        session->set( "echo", false );
                    }
                    else
                    {
                        session->set( "echo", true );
                        
                        for ( const auto parameter : request->get_query_parameters( "echo" ) )
                        {
                            const auto value = String::lowercase( parameter.second );
                            session->set( "echo", ( value == "false" or value == "no" or value == "off" or value == "0" ) ? false : true );
                        }
                    }
                    
                    callback( session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_ECHO_H */
