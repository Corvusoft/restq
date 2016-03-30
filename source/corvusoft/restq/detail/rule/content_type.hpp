/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_CONTENT_TYPE_H
#define _RESTQ_DETAIL_RULE_CONTENT_TYPE_H 1

//System Includes
#include <map>
#include <regex>
#include <string>
#include <memory>
#include <ciso646>
#include <functional>

//Project Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::map;
using std::regex;
using std::string;
using std::function;
using std::shared_ptr;
using std::regex_constants::icase;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class ContentType final : public Rule
        {
            public:
                ContentType( const map< string, shared_ptr< Formatter > >& formats ) : Rule( ),
                    m_formats( formats )
                {
                    return;
                }
                
                virtual ~ContentType( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    const auto request = session->get_request( );
                    const auto method = request->get_method( String::lowercase );
                    
                    return method == "put" or method == "post" or request->has_header( "Content-Type" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto header = request->get_header( "Content-Type" );
                    
                    for ( const auto& format : m_formats )
                    {
                        if ( regex_match( header, regex( format.first, icase ) ) )
                        {
                            session->set( "content-format", format.second );
                            return callback( session );
                        }
                    }
                    
                    static const string message = "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request.";
                    ErrorHandlerImpl::unsupported_media_type( message, session );
                }
                
                static string make( const shared_ptr< Session >& session )
                {
                    const string charset = session->get( "charset", string( "utf-8" ) );
                    const string accept = session->get( "accept", string( "text/plain" ) );
                    
                    return String::format( "%s; charset=%s", accept.data( ), charset.data( ) );
                }
                
            private:
                const map< string, shared_ptr< Formatter > >& m_formats;
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_CONTENT_TYPE_H */
