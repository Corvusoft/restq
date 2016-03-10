/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_LANGUAGE_H
#define _RESTQ_DETAIL_RULE_CONTENT_LANGUAGE_H 1

//System Includes
#include <string>
#include <memory>
#include <functional>

//Project Includes

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>

//System Namespaces
using std::string;
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
        class ContentLanguage final : public Rule
        {
            public:
                ContentLanguage( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~ContentLanguage( void )
                {
                    return;
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    callback( session );
                }
                
                static string make( void )
                {
                    return "en";
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_LANGUAGE_H */
