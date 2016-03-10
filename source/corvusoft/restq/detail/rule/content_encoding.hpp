/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H
#define _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H 1

//System Includes
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/detail/rule/content_type.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/string.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::string;
using std::function;
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
        class ContentEncoding final : public Rule
        {
            public:
                ContentEncoding( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~ContentEncoding( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< restbed::Session > session ) final override
                {
                    return session->get_request( )->has_header( "Content-Encoding" );
                }
                
                void action( const shared_ptr< restbed::Session > session, const function< void ( const shared_ptr< restbed::Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto encoding = request->get_header( "Content-Encoding", String::lowercase );
                    
                    if ( encoding.empty( ) or encoding == "identity" or encoding == "*" )
                    {
                        return callback( session );
                    }
                    
                    static const string message = "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-encoding header sent in the request.";
                    ContentType::unsupported_media_type_handler( message, session );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_ENCODING_H */
