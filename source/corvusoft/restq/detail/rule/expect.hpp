/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_EXPECT_H
#define _RESTQ_DETAIL_RULE_EXPECT_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>

//External Includes
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::list;
using std::string;
using std::function;
using std::multimap;
using std::to_string;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Expect final : public Rule
        {
            public:
                Expect( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Expect( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_header( "Expect" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& ) final override
                {
                    const auto request = session->get_request( );
                    
                    static const list< multimap< string, Bytes > > values { {
                            { "status", String::to_bytes( "417" ) },
                            { "code", String::to_bytes( "40017" ) },
                            { "type", String::to_bytes( "error" ) },
                            { "title", String::to_bytes( "Expectation Failed" ) },
                            { "message", String::to_bytes( "The exchange is refusing to process the request because a request expectation failed; not supported." ) }
                        } };
                        
                    const bool echo = session->get( "echo" );
                    const bool styled = session->get( "style" );
                    const string accept = session->get( "accept" );
                    const string charset = session->get( "charset" );
                    const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                    
                    const auto body = formatter->compose( values, styled );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                    };
                    
                    ( echo ) ? session->close( EXPECTATION_FAILED, body, headers ) : session->close( EXPECTATION_FAILED, headers );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_EXPECT_H */
