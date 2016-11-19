/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_DATE_H
#define _RESTQ_DETAIL_RULE_DATE_H 1

//System Includes
#include <ctime>
#include <chrono>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/session.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>


//System Namespaces
using std::string;
using std::time_t;
using std::strftime;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;

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
                
                bool condition( const shared_ptr< Session > ) final override
                {
                    return false;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( const time_t value = 0 )
                {
                    const time_t now = ( value ) ? value : time( 0 );
                    struct tm components = tm( );
                    
#ifdef _WIN32
                    gmtime_s( &components, &now );
#else
                    gmtime_r( &now, &components );
#endif
                    char datastamp[ 50 ] = { };
                    strftime( datastamp, sizeof datastamp, "%a, %d %b %Y %H:%M:%S GMT", &components );
                    return datastamp;
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_DATE_H */
