/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_DATE_H
#define _RESTQ_DETAIL_RULE_DATE_H 1

//System Includes
#include <chrono>
#include <string>
#include <memory>
#include <functional>

//Project Includes

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>

//System Namespaces
using std::string;
using std::time_t;
using std::strftime;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;

namespace restq
{
    namespace detail
    {
        class Date final : public Rule
        {
            public:
                Date( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Date( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< restbed::Session > ) final override
                {
                    return false;
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( const time_t value = 0 )
                {
                    const time_t now = ( value ) ? value : time( 0 );
                    struct tm components = { };
                    gmtime_r( &now, &components );
                    
                    char datastamp[ 50 ] = { };
                    strftime( datastamp, sizeof datastamp, "%a, %d %b %Y %H:%M:%S GMT", &components );
                    return datastamp;
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_DATE_H */
