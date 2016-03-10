/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_ACCEPT_LANGUAGE_H
#define _RESTQ_DETAIL_RULE_ACCEPT_LANGUAGE_H 1

//System Includes
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/accept.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::list;
using std::string;
using std::function;
using std::multimap;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class AcceptLanguage final : public Rule
        {
            public:
                AcceptLanguage( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~AcceptLanguage( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< restbed::Session > session ) final override
                {
                    return session->get_request( )->has_header( "Accept-Language" );
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto language = request->get_header( "Accept-Language", String::lowercase );
                    
                    if ( language == "en" or language == "en_gb" or language == "*" )
                    {
                        return callback( session );
                    }
                    
                    static const string body = "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept-language header sent in the request.";
                    Accept::not_acceptable_handler( session, body );
                }
                
                static string make( void )
                {
                    return "en";
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_ACCEPT_LANGUAGE_H */
