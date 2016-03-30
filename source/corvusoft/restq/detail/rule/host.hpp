/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_HOST_H
#define _RESTQ_DETAIL_RULE_HOST_H 1

//System Includes
#include <regex>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::regex;
using std::string;
using std::function;
using std::shared_ptr;
using std::regex_match;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class Host final : public Rule
        {
            public:
                Host( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Host( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto host = request->get_header( "Host", String::lowercase );
                    
                    session->set( "host", host );
                    
                    static const auto pattern = regex{ "^(([a-zA-Z0-9\\-._~%!$&'()*+,;=]+)(:([a-zA-Z0-9\\-._~%!$&'()*+,;=]+))?@)?([a-zA-Z0-9\\-._~%]+|\\[[a-zA-Z0-9\\-._~%!$&'()*+,;=:]+\\])(:[0-9]+)?$" };
                    
                    return not regex_match( host, pattern );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& ) final override
                {
                    static const string message = "The exchange is refusing to process the request because it was missing or contained a malformed Host request-header.";
                    ErrorHandlerImpl::bad_request( message, session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_HOST_H */
