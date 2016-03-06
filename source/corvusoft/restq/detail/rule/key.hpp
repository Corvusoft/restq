/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_KEY_H
#define _RESTQ_DETAIL_RULE_KEY_H 1

//System Includes
#include <map>
#include <list>
#include <regex>
#include <vector>
#include <string>
#include <memory>
#include <sstream>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/formatter.hpp>
#include <corvusoft/restq/status_code.hpp>
#include <corvusoft/restq/detail/rule/date.hpp>
#include <corvusoft/restq/detail/rule/content_md5.hpp>
#include <corvusoft/restq/detail/rule/content_type.hpp>
#include <corvusoft/restq/detail/rule/content_length.hpp>

//External Includes
#include <kashmir/uuid_gen.h>
#include <kashmir/system/devrand.h>
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/session.hpp>
#include <corvusoft/restbed/request.hpp>

//System Namespaces
using std::map;
using std::list;
using std::regex;
using std::string;
using std::vector;
using std::function;
using std::multimap;
using std::to_string;
using std::shared_ptr;
using std::regex_match;
using std::stringstream;

//Project Namespaces

//External Namespaces
using restbed::Rule;
using restbed::Session;
using restbed::Request;

namespace restq
{
    namespace detail
    {
        class Key final : public Rule
        {
            public:
                Key( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Key( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_path_parameter( "key" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    vector< string > keys = session->get( "keys", vector< string >( ) );
                    
                    const auto key = session->get_request( )->get_path_parameter( "key", &String::lowercase );
                    keys.push_back( key );
                    
                    session->set( "keys", keys );
                    callback( session );
                }
                
                static void not_found_handler( const shared_ptr< Session > session )
                {
                    static const list< multimap< string, Bytes > > values { {
                            { "type", String::to_bytes( "error" ) },
                            { "code", String::to_bytes( "40004" ) },
                            { "status", String::to_bytes( "404" ) },
                            { "title", String::to_bytes(  "Not Found" ) },
                            { "message", String::to_bytes( "The exchange is refusing to process the request because the requested URI could not be found within the exchange." ) } //locale->get_error_message( code )
                        } };
                        
                    const bool echo = session->get( "echo" );
                    const bool styled = session->get( "style" );
                    const string accept = session->get( "accept" );
                    const string charset = session->get( "charset" );
                    const shared_ptr< Formatter > composer = session->get( "accept-format" );
                    
                    const auto body = composer->compose( values, styled );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                    };
                    
                    ( echo ) ? session->close( NOT_FOUND, body, headers ) : session->close( NOT_FOUND, headers );
                }
                
                static void conflict_handler( const shared_ptr< Session >& session )
                {
                    static const list< multimap< string, Bytes > > values { {
                            { "type", String::to_bytes( "error" ) },
                            { "code", String::to_bytes( "40009" ) },
                            { "status", String::to_bytes( "409" ) },
                            { "title", String::to_bytes(  "Conflict" ) },
                            { "message", String::to_bytes( "The exchange is refusing to process the request because of a conflict with an existing resource." ) }
                        } };
                        
                    const shared_ptr< Formatter > composer = session->get( "accept-format" );
                    const auto body = composer->compose( values, session->get( "style" ) );
                    
                    const multimap< string, string > headers
                    {
                        { "Date", Date::make( ) },
                        { "Content-MD5", ContentMD5::make( body ) },
                        { "Content-Language", ContentLanguage::make( ) },
                        { "Content-Type",  ContentType::make( session ) },
                        { "Content-Length", ContentLength::make( body ) }
                    };
                    
                    const bool echo = session->get( "echo" );
                    ( echo ) ? session->close( CONFLICT, body, headers ) : session->close( CONFLICT, headers );
                }
                
                static const string pattern;
                
                static bool is_invalid( const Bytes& key )
                {
                    const auto value = String::to_string( key );
                    
                    static const regex regular_expression( pattern );
                    return not regex_match( value, regular_expression );
                }
                
                static Bytes make( void )
                {
                    kashmir::uuid_t uuid;
                    kashmir::system::DevRand random;
                    random >> uuid;
                    
                    stringstream stream;
                    stream << uuid;
                    
                    return String::to_bytes( stream.str( ) );
                }
        };
        
        const string Key::pattern = "^[0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}$";
    }
}

#endif  /* _RESTQ_DETAIL_RULE_KEY_H */
