/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <map>
#include <list>
#include <ciso646>

//Project Includes
#include "corvusoft/restq/byte.hpp"
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/session.hpp"
#include "corvusoft/restq/formatter.hpp"
#include "corvusoft/restq/status_code.hpp"
#include "corvusoft/restq/detail/rule/date.hpp"
#include "corvusoft/restq/detail/rule/content_md5.hpp"
#include "corvusoft/restq/detail/rule/content_type.hpp"
#include "corvusoft/restq/detail/error_handler_impl.hpp"
#include "corvusoft/restq/detail/rule/content_length.hpp"
#include "corvusoft/restq/detail/rule/content_language.hpp"

//External Includes

//System Namespaces
using std::list;
using std::string;
using std::multimap;
using std::to_string;
using std::exception;
using std::shared_ptr;
using std::runtime_error;

//Project Namespaces

//External Namespaces

namespace restq
{
    namespace detail
    {
        void ErrorHandlerImpl::method_not_allowed( const shared_ptr< Session > session )
        {
            static const Resources values { {
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "40005" ) },
                    { "status", String::to_bytes( "405" ) },
                    { "title", String::to_bytes( "Method Not Allowed" ) },
                    { "message", String::to_bytes( "The exchange is refusing to process the request because the requested method is not allowed for this resource." ) }
                } };
                
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( values, session->get( "style" ) );
            
            auto allow = "GET,POST,HEAD,DELETE,OPTIONS";
            const auto path = session->get_request( )->get_path( );
            
            const auto has_key_parameter = session->get_request( )->has_path_parameter( "key" );
            
            if ( path == "/*" )
            {
                allow = "OPTIONS";
            }
            else if ( regex_match( path, regex( ".*messages.*" ) ) )
            {
                allow = ( has_key_parameter ) ? "OPTIONS" : "POST,OPTIONS";
            }
            else if ( has_key_parameter )
            {
                allow = "GET,PUT,HEAD,DELETE,OPTIONS";
            }
            
            const multimap< string, string > headers
            {
                { "Allow", allow },
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( METHOD_NOT_ALLOWED, body, headers ) : session->close( METHOD_NOT_ALLOWED, headers );
        }
        
        void ErrorHandlerImpl::method_not_implemented( const shared_ptr< Session > session )
        {
            static const Resources values { {
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "50001" ) },
                    { "status", String::to_bytes( "501" ) },
                    { "title", String::to_bytes( "Not Implemented" ) },
                    { "message", String::to_bytes( "The exchange is refusing to process the request because the requested method is not implemented within this service." ) }
                } };
                
                
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Allow", "GET,PUT,POST,HEAD,DELETE,OPTIONS" },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type",  ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) },
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( NOT_IMPLEMENTED, body, headers ) : session->close( NOT_IMPLEMENTED, headers );
        }
        
        void ErrorHandlerImpl::conflict( const string& message, const shared_ptr< Session >& session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "40009" ) },
                    { "status", String::to_bytes( "409" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes(  "Conflict" ) }
                } };
                
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( CONFLICT, body, headers ) : session->close( CONFLICT, headers );
        }
        
        void ErrorHandlerImpl::not_found( const string& message, const shared_ptr< Session > session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "40004" ) },
                    { "status", String::to_bytes( "404" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes(  "Not Found" ) }
                } };
                
            const bool styled = session->get( "style" );
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            
            const auto body = composer->compose( values, styled );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( NOT_FOUND, body, headers ) : session->close( NOT_FOUND, headers );
        }
        
        void ErrorHandlerImpl::bad_request( const string& message, const shared_ptr< Session >& session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "40000" ) },
                    { "status", String::to_bytes( "400" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes(  "Bad Request" ) }
                } };
                
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( BAD_REQUEST, body, headers ) : session->close( BAD_REQUEST, headers );
        }
        
        void ErrorHandlerImpl::not_acceptable( const string& message, const shared_ptr< Session >& session )
        {
            Bytes body;
            
            if ( not session->has( "accept-format" ) )
            {
                body = String::to_bytes( message );
            }
            else
            {
                const list< multimap< string, Bytes > > values { {
                        { "type", String::to_bytes( "error" ) },
                        { "code", String::to_bytes( "40006" ) },
                        { "status", String::to_bytes( "406" ) },
                        { "message", String::to_bytes( message ) },
                        { "title", String::to_bytes(  "Not Acceptable" ) }
                    } };
                    
                const shared_ptr< Formatter > formatter = session->get( "accept-format" );
                body = formatter->compose( values, session->get( "style" ) );
            }
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( NOT_ACCEPTABLE, body, headers ) : session->close( NOT_ACCEPTABLE, headers );
        }
        
        void ErrorHandlerImpl::length_required( const string& message, const shared_ptr< Session >& session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "status", String::to_bytes( "411" ) },
                    { "type", String::to_bytes( "error" ) },
                    { "code", String::to_bytes( "40011" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes( "Length Required" ) }
                } };
                
            const shared_ptr< Formatter > formatter = session->get( "accept-format" );
            const auto body = formatter->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type",  ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( LENGTH_REQUIRED, body, headers ) : session->close( LENGTH_REQUIRED, headers );
        }
        
        void ErrorHandlerImpl::expectation_failed( const string& message, const shared_ptr< Session >& session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "status", String::to_bytes( "417" ) },
                    { "code", String::to_bytes( "40017" ) },
                    { "type", String::to_bytes( "error" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes( "Expectation Failed" ) }
                } };
                
            const shared_ptr< Formatter > formatter = session->get( "accept-format" );
            const auto body = formatter->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type",  ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( EXPECTATION_FAILED, body, headers ) : session->close( EXPECTATION_FAILED, headers );
        }
        
        void ErrorHandlerImpl::unsupported_media_type( const string& message, const shared_ptr< Session >& session )
        {
            const list< multimap< string, Bytes > > values { {
                    { "status", String::to_bytes( "415" ) },
                    { "code", String::to_bytes( "40015" ) },
                    { "type", String::to_bytes( "error" ) },
                    { "message", String::to_bytes( message ) },
                    { "title", String::to_bytes( "Unsupported Media Type" ) }
                } };
                
            const shared_ptr< Formatter > formatter = session->get( "accept-format" );
            const auto body = formatter->compose( values, session->get( "style" ) );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) },
            };
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( UNSUPPORTED_MEDIA_TYPE, body, headers ) : session->close( UNSUPPORTED_MEDIA_TYPE, headers );
        }
        
        void ErrorHandlerImpl::internal_server_error( const int status, const exception& error, const shared_ptr< Session > session )
        {
            const string message = error.what( );
            
            const multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( message ) },
                { "Content-Language", ContentLanguage::make( ) },
                { "Content-Type",  ContentType::make( session ) },
                { "Content-Length", ContentLength::make( message ) }
            };
            
            session->close( status, message, headers );
        }
        
        void ErrorHandlerImpl::find_and_invoke_for( const int status, const string& message, const shared_ptr< Session > session )
        {
            switch ( status )
            {
                case NOT_FOUND:
                    not_found( message, session );
                    break;
                    
                case METHOD_NOT_ALLOWED:
                    method_not_allowed( session );
                    break;
                    
                case CONFLICT:
                    conflict( message, session );
                    break;
                    
                case BAD_REQUEST:
                    bad_request( message, session );
                    break;
                    
                case NOT_IMPLEMENTED:
                    method_not_implemented( session );
                    break;
                    
                case LENGTH_REQUIRED:
                    length_required( message, session );
                    break;
                    
                case NOT_ACCEPTABLE:
                    not_acceptable( message, session );
                    break;
                    
                case EXPECTATION_FAILED:
                    expectation_failed( message, session );
                    break;
                    
                case UNSUPPORTED_MEDIA_TYPE:
                    unsupported_media_type( message, session );
                    break;
                    
                default:
                    internal_server_error( status, runtime_error( message ), session );
            }
        }
    }
}
