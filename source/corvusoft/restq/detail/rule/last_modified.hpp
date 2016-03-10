/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_LAST_MODIFIED_H
#define _RESTQ_DETAIL_RULE_LAST_MODIFIED_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>

//System Namespaces
using std::list;
using std::stoul;
using std::string;
using std::function;
using std::multimap;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;

namespace restq
{
    namespace detail
    {
        class LastModified final : public Rule
        {
            public:
                LastModified( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~LastModified( void )
                {
                    return;
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( void )
                {
                    return Date::make( );
                }
                
                static string make( const list< multimap< string, Bytes > >& resources )
                {
                    const auto datestamp = String::to_string( resources.back( ).lower_bound( "modified" )->second );
                    
                    return Date::make( stoul( datestamp ) );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_LAST_MODIFIED_H */
