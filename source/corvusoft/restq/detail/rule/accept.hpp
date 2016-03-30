/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_ACCEPT_H
#define _RESTQ_DETAIL_RULE_ACCEPT_H 1

//System Includes
#include <map>
#include <list>
#include <regex>
#include <string>
#include <memory>
#include <utility>
#include <functional>

//Project Includes
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::map;
using std::list;
using std::regex;
using std::string;
using std::multimap;
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
        class Accept final : public Rule
        {
            public:
                Accept( const map< string, shared_ptr< Formatter > >& formats ) : Rule( ),
                    m_formats( formats )
                {
                    return;
                }
                
                virtual ~Accept( void )
                {
                    return;
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    const auto request = session->get_request( );
                    const auto header = request->get_header( "Accept" );
                    
                    for ( const auto& format : m_formats )
                    {
                        if ( regex_match( header, regex( format.first, icase ) ) )
                        {
                            session->set( "accept-format", format.second );
                            session->set( "accept", format.second->get_mime_type( ) );
                            return callback( session );
                        }
                    }
                    
                    static const string message = "The exchange is only capable of generating response entities which have content characteristics not acceptable according to the accept header sent in the request.";
                    ErrorHandlerImpl::not_acceptable( message, session );
                }
                
            private:
                const map< string, shared_ptr< Formatter > >& m_formats;
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_ACCEPT_H */
