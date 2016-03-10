/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_ACCEPT_RANGES_H
#define _RESTQ_DETAIL_RULE_ACCEPT_RANGES_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/session.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>


//System Namespaces
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
        class AcceptRanges final : public Rule
        {
            public:
                AcceptRanges( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~AcceptRanges( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( void )
                {
                    return "none";
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_ACCEPT_RANGES_H */
