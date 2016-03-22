/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <set>
#include <regex>
#include <chrono>
#include <vector>
#include <functional>

//Project Includes
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/session.hpp"
#include "corvusoft/restq/formatter.hpp"
#include "corvusoft/restq/repository.hpp"
#include "corvusoft/restq/status_code.hpp"
#include "corvusoft/restq/detail/exchange_impl.hpp"
#include "corvusoft/restq/detail/error_handler_impl.hpp"
#include "corvusoft/restq/detail/rule/key.hpp"
#include "corvusoft/restq/detail/rule/keys.hpp"
#include "corvusoft/restq/detail/rule/etag.hpp"
#include "corvusoft/restq/detail/rule/date.hpp"
#include "corvusoft/restq/detail/rule/echo.hpp"
#include "corvusoft/restq/detail/rule/host.hpp"
#include "corvusoft/restq/detail/rule/style.hpp"
#include "corvusoft/restq/detail/rule/range.hpp"
#include "corvusoft/restq/detail/rule/paging.hpp"
#include "corvusoft/restq/detail/rule/expect.hpp"
#include "corvusoft/restq/detail/rule/accept.hpp"
#include "corvusoft/restq/detail/rule/fields.hpp"
#include "corvusoft/restq/detail/rule/filters.hpp"
#include "corvusoft/restq/detail/rule/location.hpp"
#include "corvusoft/restq/detail/rule/content_md5.hpp"
#include "corvusoft/restq/detail/rule/content_type.hpp"
#include "corvusoft/restq/detail/rule/last_modified.hpp"
#include "corvusoft/restq/detail/rule/accept_ranges.hpp"
#include "corvusoft/restq/detail/rule/content_length.hpp"
#include "corvusoft/restq/detail/rule/accept_charset.hpp"
#include "corvusoft/restq/detail/rule/accept_encoding.hpp"
#include "corvusoft/restq/detail/rule/accept_language.hpp"
#include "corvusoft/restq/detail/rule/content_encoding.hpp"
#include "corvusoft/restq/detail/rule/content_language.hpp"

//External Includes
#include <corvusoft/restbed/uri.hpp>
#include <corvusoft/restbed/http.hpp>
#include <corvusoft/restbed/request.hpp>
#include <corvusoft/restbed/response.hpp>
#include <corvusoft/restbed/resource.hpp>

//System Namespaces
using std::set;
using std::pair;
using std::bind;
using std::list;
using std::regex;
using std::string;
using std::vector;
using std::multimap;
using std::to_string;
using std::make_pair;
using std::shared_ptr;
using std::make_shared;
using std::regex_match;
using std::out_of_range;
using std::invalid_argument;
using std::placeholders::_1;
using std::placeholders::_2;
using std::placeholders::_3;
using std::chrono::system_clock;

//Project Namespaces

//External Namespaces
using loadis::System;
using restbed::Uri;
using restbed::Http;
using restbed::Request;
using restbed::Service;
using restbed::Response;
using restbed::Resource;

namespace restq
{
    namespace detail
    {
        const auto PENDING = String::to_bytes( "pending" );
        const auto REJECTED = String::to_bytes( "rejected" );
        const auto INFLIGHT = String::to_bytes( "in-flight" );
        const auto DISPATCHED = String::to_bytes( "dispatched" );
        
        ExchangeImpl::ExchangeImpl( void ) : m_boot_time( 0 ),
            m_logger( nullptr ),
            m_system( make_shared< System >( ) ),
            m_repository( nullptr ),
            m_settings( nullptr ),
            m_service( make_shared< restbed::Service >( ) ),
            m_ready_handler( nullptr ),
            m_key_rule( make_shared< Key >( ) ),
            m_keys_rule( make_shared< Keys >( ) ),
            m_content_type_rule( make_shared< ContentType >( m_formats ) ),
            m_content_encoding_rule( make_shared< ContentEncoding >( ) ),
            m_formats( )
        {
            return;
        }
        
        ExchangeImpl::~ExchangeImpl( void )
        {
            return;
        }
        
        void ExchangeImpl::start( void )
        {
            const auto settings = make_shared< restbed::Settings >( );
            settings->set_default_header( "Expires", "0" );
            settings->set_default_header( "Connection", "close" );
            settings->set_default_header( "Server", "corvusoft/restq" );
            settings->set_default_header( "Pragma", "no-cache" );
            settings->set_default_header( "Cache-Control", "private,max-age=0,no-cache,no-store" );
            settings->set_default_header( "Vary", "Accept,Accept-Encoding,Accept-Charset,Accept-Language" );
            settings->set_case_insensitive_uris( true );
            settings->set_port( m_settings->get_port( ) );
            settings->set_root( m_settings->get_root( ) );
            settings->set_worker_limit( m_settings->get_worker_limit( ) );
            settings->set_connection_limit( m_settings->get_connection_limit( ) );
            settings->set_bind_address( m_settings->get_bind_address( ) );
            settings->set_connection_timeout( m_settings->get_connection_timeout( ) );
            settings->set_ssl_settings( m_settings->get_ssl_settings( ) );
            
            m_service->set_error_handler( ErrorHandlerImpl::internal_server_error );
            m_service->set_method_not_allowed_handler( ErrorHandlerImpl::method_not_allowed );
            m_service->set_method_not_implemented_handler( ErrorHandlerImpl::method_not_implemented );
            m_service->set_not_found_handler( bind( ErrorHandlerImpl::not_found, "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", _1 ) );
            m_service->set_ready_handler( [ this ]( Service & service )
            {
                log( Logger::INFO, String::format( "Exchange accepting HTTP connections at '%s'.",  service.get_http_uri( )->to_string( ).data( ) ) );
                
                if ( m_ready_handler not_eq nullptr )
                {
                    m_ready_handler( );
                }
            } );
            
            setup_ruleset( );
            setup_queue_resource( );
            setup_queues_resource( );
            setup_message_resource( );
            setup_messages_resource( );
            setup_asterisk_resource( );
            setup_subscription_resource( );
            setup_subscriptions_resource( );
            
            m_boot_time = system_clock::to_time_t( system_clock::now( ) );
            m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
            m_service->start( settings );
        }
        
        void ExchangeImpl::log( const Logger::Level level, const string& message ) const
        {
            if ( m_logger not_eq nullptr )
            {
                m_logger->log( level, "%s", message.data( ) );
            }
        }
        
        bool ExchangeImpl::is_valid( const pair< const string, const string >& header ) const
        {
            static const set< string > invalid_headers
            {
                "upgrade", "connection",
                "te", "trailer", "transfer-encoding",
                "expect", "range", "retry-after", "allow",
                "content-length", "content-location", "content-md5",
                "from", "host", "via", "server", "referer", "date", "location",
                "pragma", "cache-control", "age", "etag", "vary", "expires",  "last-modified",
                "authorization", "www-authenticate", "proxy-authorization", "proxy-authenticate",
                "accept", "accept-charset", "accept-encoding", "accept-language", "accept-ranges",
                "if-match", "if-modified-since", "if-none-match", "if-range", "if-unmodified-since"
            };
            
            return invalid_headers.count( String::lowercase( header.first ) ) == 0;
        }
        
        bool ExchangeImpl::is_invalid( Resource& value, const Bytes& type ) const
        {
            if ( type == SUBSCRIPTION )
            {
                if ( value.count( "endpoint" ) not_eq 1 )
                {
                    return true;
                }
                
                const auto endpoint = String::to_string( value.lower_bound( "endpoint" )->second );
                
                if ( not Uri::is_valid( endpoint ) )
                {
                    return true;
                }
                
                const Uri uri( endpoint );
                
                if ( uri.get_scheme( ) not_eq "http" )
                {
                    return true;
                }
            }
            else if ( type == QUEUE )
            {
                try
                {
                    if ( value.count( "message-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "message-limit" )->second ) );
                    }
                    
                    if ( value.count( "message-size-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "message-size-limit" )->second ) );
                    }
                    
                    if ( value.count( "subscription-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "subscription-limit" )->second ) );
                    }
                }
                catch ( const invalid_argument& ia )
                {
                    return false;
                }
                catch ( const out_of_range& ofr )
                {
                    return false;
                }
            }
            
            return false;
        }
        
        bool ExchangeImpl::is_update_invalid( Resource& value, const Bytes& type ) const
        {
            if ( type == SUBSCRIPTION )
            {
                if ( value.count( "endpoint" ) )
                {
                    const auto endpoint = String::to_string( value.lower_bound( "endpoint" )->second );
                    
                    if ( not Uri::is_valid( endpoint ) )
                    {
                        return true;
                    }
                    
                    const Uri uri( endpoint );
                    
                    if ( uri.get_scheme( ) not_eq "http" )
                    {
                        return true;
                    }
                }
            }
            else if ( type == QUEUE )
            {
                return is_invalid( value, type );
            }
            
            return false;
        }
        
        void ExchangeImpl::initialise_default_values( Resource& value, const Bytes& type ) const
        {
            if ( type == QUEUE )
            {
                const auto message_limit = String::to_bytes( ::to_string( m_settings->get_default_queue_message_limit( ) ) );
                
                if ( not value.count( "message-limit" ) )
                {
                    value.insert( make_pair( "message-limit", message_limit ) );
                }
                
                const auto message_size_limit = String::to_bytes( ::to_string( m_settings->get_default_queue_message_size_limit( ) ) );
                
                if ( not value.count( "message-size-limit" ) )
                {
                    value.insert( make_pair( "message-size-limit", message_size_limit ) );
                }
                
                const auto subscription_limit = String::to_bytes( ::to_string( m_settings->get_default_queue_subscription_limit( ) ) );
                
                if ( not value.count( "subscription-limit" ) )
                {
                    value.insert( make_pair( "subscription-limit", subscription_limit ) );
                }
            }
        }
        
        void ExchangeImpl::remove_reserved_words( Resource& resource ) const
        {
            resource.erase( "key" );
            resource.erase( "type" );
            resource.erase( "origin" );
            resource.erase( "created" );
            resource.erase( "revision" );
            resource.erase( "modified" );
        }
        
        void ExchangeImpl::remove_reserved_words( Resources& resources ) const
        {
            for ( auto& resource : resources )
            {
                remove_reserved_words( resource );
            }
        }
        
        Resource ExchangeImpl::make_message( const shared_ptr< Session >& session ) const
        {
            const auto key = Key::make( );
            const auto request = session->get_request( );
            const auto body = request->get_body( );
            
            const auto message_datestamp = String::to_bytes( Date::make( ) );
            
            Resource message;
            message.insert( make_pair( "key", key ) );
            message.insert( make_pair( "data", body ) );
            message.insert( make_pair( "type", MESSAGE ) );
            message.insert( make_pair( "created", message_datestamp ) );
            message.insert( make_pair( "modified", message_datestamp ) );
            message.insert( make_pair( "author", String::to_bytes( "not implemented" ) ) );
            message.insert( make_pair( "origin", String::to_bytes( session->get_origin( ) ) ) );
            message.insert( make_pair( "size", String::to_bytes( ContentLength::make( body ) ) ) );
            message.insert( make_pair( "checksum", String::to_bytes( ContentMD5::make( body ) ) ) );
            message.insert( make_pair( "destination", String::to_bytes( request->get_header( "Host" ) ) ) );
            message.insert( make_pair( "protocol", String::to_bytes( request->get_protocol( ) ) ) );
            message.insert( make_pair( "protocol-version", String::to_bytes( String::format( "%.1f", request->get_version( ) ) ) ) );
            
            for ( const auto& header : request->get_headers( ) )
            {
                if ( is_valid( header ) )
                {
                    message.insert( make_pair( header.first, String::to_bytes( header.second ) ) );
                }
            }
            
            string query = String::empty;
            multimap< string, Bytes > parameters = session->get( "filters" );
            
            for ( const auto parameter : parameters )
            {
                query += String::format( "%s=%s&", parameter.first.data( ), parameter.second.data( ) );
            }
            
            query = String::trim_lagging( query, "&" );
            message.insert( make_pair( "query", String::to_bytes( query ) ) );
            
            return message;
        }
        
        void ExchangeImpl::setup_ruleset( void )
        {
            m_service->add_rule( make_shared< Echo >( )             ,  0 );
            m_service->add_rule( make_shared< Style >( )            ,  0 );
            m_service->add_rule( make_shared< Accept >( m_formats ) ,  1 );
            m_service->add_rule( make_shared< AcceptCharset >( )    ,  2 );
            m_service->add_rule( make_shared< AcceptEncoding >( )   ,  3 );
            m_service->add_rule( make_shared< AcceptLanguage >( )   ,  3 );
            m_service->add_rule( make_shared< Host >( )             ,  4 );
            m_service->add_rule( make_shared< Expect >( )           ,  4 );
            m_service->add_rule( make_shared< ContentLength >( )    ,  5 );
            m_service->add_rule( make_shared< ContentMD5 >( )       ,  6 );
            m_service->add_rule( make_shared< Range >( )            ,  6 );
            m_service->add_rule( make_shared< Filters >( )          , 99 );
            m_service->add_rule( make_shared< Fields >( )           , 99 );
            m_service->add_rule( make_shared< Paging >( )           , 99 );
        }
        
        void ExchangeImpl::setup_queue_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "/queues/{key: " + Key::pattern + "}" );
            resource->add_rule( m_key_rule );
            resource->add_rule( m_content_type_rule );
            resource->add_rule( m_content_encoding_rule );
            resource->set_method_handler( "GET", bind( &ExchangeImpl::read_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "HEAD", bind( &ExchangeImpl::read_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "PUT", bind( &ExchangeImpl::update_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "DELETE", bind( &ExchangeImpl::delete_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, QUEUE, "GET,PUT,HEAD,DELETE,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_queues_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "/queues" );
            resource->add_rule( m_keys_rule );
            resource->add_rule( m_content_type_rule );
            resource->add_rule( m_content_encoding_rule );
            resource->set_method_handler( "GET", bind( &ExchangeImpl::read_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "HEAD", bind( &ExchangeImpl::read_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "POST", bind( &ExchangeImpl::create_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "DELETE", bind( &ExchangeImpl::delete_resource_handler, this, _1, QUEUE ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, QUEUE, "GET,POST,HEAD,DELETE,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_message_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "/messages/{key: " + Key::pattern + "}" );
            resource->add_rule( m_key_rule );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, MESSAGE, "OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_messages_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_paths( { "/messages", "/queues/{key: " + Key::pattern + "}/messages" } );
            resource->add_rule( m_key_rule );
            resource->add_rule( m_keys_rule );
            resource->set_method_handler( "POST", bind( &ExchangeImpl::create_message_handler, this, _1 ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, MESSAGE, "POST,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_asterisk_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "\\*" );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::asterisk_resource_handler, this, _1 ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_subscription_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "/subscriptions/{key: " + Key::pattern + "}" );
            resource->add_rule( m_key_rule );
            resource->add_rule( m_content_type_rule );
            resource->add_rule( m_content_encoding_rule );
            resource->set_method_handler( "GET", bind( &ExchangeImpl::read_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "HEAD", bind( &ExchangeImpl::read_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "PUT", bind( &ExchangeImpl::update_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "DELETE", bind( &ExchangeImpl::delete_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, SUBSCRIPTION, "GET,PUT,HEAD,DELETE,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_subscriptions_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_path( "/subscriptions" );
            resource->add_rule( m_keys_rule );
            resource->add_rule( m_content_type_rule );
            resource->add_rule( m_content_encoding_rule );
            resource->set_method_handler( "GET", bind( &ExchangeImpl::read_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "HEAD", bind( &ExchangeImpl::read_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "POST", bind( &ExchangeImpl::create_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "DELETE", bind( &ExchangeImpl::delete_resource_handler, this, _1, SUBSCRIPTION ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, SUBSCRIPTION, "GET,POST,HEAD,DELETE,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::dispatch( void )
        {
            auto session = make_shared< Session >( "dispatch" );
            
            const vector< string > keys = { };
            session->set( "keys", keys );
            
            const pair< size_t, size_t > range = { 0, 1 };
            session->set( "paging", range );
            
            multimap< string, Bytes > filters;
            session->set( "inclusive_filters", filters );
            
            filters.insert( { "type", STATE } );
            filters.insert( { "status", PENDING } );
            session->set( "exclusive_filters", filters );
            
            m_repository->read( session, [ this ]( const int status, const Resources states, shared_ptr< Session > session )
            {
                if ( status not_eq OK )
                {
                    return log( Logger::ERROR, "Failed to read transaction states." );
                }
                else if ( states.empty( ) )
                {
                    return;
                }
                
                
                const auto state_key = String::to_string( states.back( ).lower_bound( "key" )->second );
                vector< string > keys;
                keys.push_back( state_key );
                session->set( "keys", keys );
                
                const pair< size_t, size_t > range = { 0, 1 };
                session->set( "paging", range );
                
                const multimap< string, Bytes > filters = { { "type", STATE }, { "status", PENDING } };
                session->set( "exclusive_filters", filters );
                
                m_repository->update( { { "status", INFLIGHT } }, session, [ this, state_key ]( const int status, const Resources states, shared_ptr< Session > session )
                {
                    if ( status not_eq OK )
                    {
                        return log( Logger::ERROR, "Failed to update transaction status." );
                    }
                    else if ( status == NO_CONTENT )
                    {
                        return m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
                    }
                    
                    const auto message_key = String::to_string( states.back( ).lower_bound( "message-key" )->second );
                    
                    vector< string > keys;
                    keys.push_back( message_key );
                    session->set( "keys", keys );
                    
                    const pair< size_t, size_t > range = { 0, 1 };
                    session->set( "paging", range );
                    
                    const multimap< string, Bytes > filters = { { "type", MESSAGE } };
                    session->set( "exclusive_filters", filters );
                    
                    m_repository->read( session, [ this, state_key, states ]( const int status, const Resources messages, shared_ptr< Session > session )
                    {
                        if ( status not_eq OK or messages.empty( ) )
                        {
                            log( Logger::WARNING, "Failed to read associated state message, purging." );
                            vector< string > keys = { state_key };
                            session->set( "keys", keys );
                            
                            const multimap< string, Bytes > filters = { { "type", STATE } };
                            session->set( "exclusive_filters", filters );
                            
                            return m_repository->destroy( session, [ ]( const int, shared_ptr< Session > ) //nullptr
                            {
                                return; //repo should cehck for nullptr before invoking
                            } );
                        }
                        
                        auto message = messages.back( );
                        
                        //status = Dispatch::direct( message );
                        
                        auto request = make_shared< Request >( Uri( String::to_string( states.back( ).lower_bound( "subscription-endpoint" )->second ) ) );
                        request->set_method( "POST" );
                        request->set_body( message.lower_bound( "data" )->second );
                        request->set_headers( { {
                                { "Expires", "0" },
                                { "Pragma", "no-cache" },
                                { "Connection", "close" },
                                { "Date", Date::make( ) },
                                { "Cache-Control", "private,max-age=0,no-cache,no-store" },
                                { "From", String::to_string( message.lower_bound( "author" )->second ) },
                                { "Referer", String::to_string( message.lower_bound( "origin" )->second ) },
                                { "Content-MD5", String::to_string( message.lower_bound( "checksum" )->second ) },
                                { "Content-Length", ContentLength::make( message.lower_bound( "data" )->second ) },
                                { "Content-Type", String::to_string( message.lower_bound( "content-type" )->second ) },
                                { "Last-Modified", String::to_string( message.lower_bound( "modified" )->second ) },
                                { "Via", String::format( "%s/%s %s", String::to_string( message.lower_bound( "protocol" )->second ).data( ), String::to_string( message.lower_bound( "protocol-version" )->second ).data( ), String::to_string( message.lower_bound( "destination" )->second ).data( ) ) }
                            }
                        } );
                        
                        for ( const auto parameter : String::split( String::to_string( message.lower_bound( "query" )->second ), '&' ) )
                        {
                            const auto name_value = String::split( parameter, '=' );
                            request->set_query_parameter( name_value[ 0 ], name_value[ 1 ] );
                        }
                        
                        message.erase( "key" );
                        message.erase( "type" );
                        message.erase( "data" );
                        message.erase( "size" );
                        message.erase( "query" );
                        message.erase( "origin" );
                        message.erase( "checksum" );
                        message.erase( "protocol" );
                        message.erase( "destination" );
                        message.erase( "last-modified" );
                        message.erase( "protocol-version" );
                        
                        for ( const auto& property : message )
                        {
                            request->set_header( property.first, String::to_string( property.second ) );
                        }
                        
                        
                        auto response = Http::sync( request );
                        int status_code = response->get_status_code( );
                        Http::close( request );
                        //status = Dispatch::direct( message ); end
                        
                        string log_message = "";
                        Resource change;
                        const auto subscription_key = String::to_string( states.back( ).lower_bound( "subscription-key" )->second );
                        const auto message_key = String::to_string( states.back( ).lower_bound( "message-key" )->second );
                        
                        if ( status_code == ACCEPTED )
                        {
                            change.insert( make_pair( "status", DISPATCHED ) );
                            log_message = "Failed to update transaction status to dispatched.";
                            log( Logger::INFO, String::format( "Subscription '%s' accepted message '%s'.", subscription_key.data( ), message_key.data( ) ) );
                        }
                        else if ( status_code >= 200 and status_code <= 299 )
                        {
                            change.insert( make_pair( "status", REJECTED ) );
                            log_message = "Failed to update transaction status to rejected.";
                            log( Logger::INFO, String::format( "Subscription '%s' rejected message '%s'.", subscription_key.data( ), message_key.data( ) ) );
                        }
                        else
                        {
                            return log( Logger::WARNING, String::format( "Failed to dispatch message '%s' to subscription '%s'.", message_key.data( ), subscription_key.data( ) ) );
                        }
                        
                        vector< string > keys;
                        keys.push_back( state_key );
                        session->set( "keys", keys );
                        
                        multimap< string, Bytes > filters;
                        filters.insert( make_pair( "type", STATE ) );
                        session->set( "exclusive_filters", filters );
                        
                        m_repository->update( change, session, [ this ]( const int status, const Resources, shared_ptr< Session > session )
                        {
                            if ( status not_eq OK )
                            {
                                log( Logger::ERROR, "Failed to update transaction status to dispatched." );
                            }
                            
                            m_repository->destroy( session, [ this ]( const int, const shared_ptr< Session > )
                            {
                                m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
                            } );
                        } );
                    } );
                } );
            } );
        }
        
        void ExchangeImpl::create_message_handler( const shared_ptr< Session > session )
        {
            const auto request = session->get_request( );
            
            if ( request->get_header( "Content-Type" ).empty( ) )
            {
                return ErrorHandlerImpl::unsupported_media_type( "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request.", session );
            }
            
            if ( request->has_path_parameter( "key" ) )
            {
                session->set( "keys", vector< string > { request->get_path_parameter( "key" ) } );
                session->set( "exclusive_filters", multimap< string, Bytes > { } );
            }
            
            multimap< string, Bytes > filters = session->get( "exclusive_filters" );
            filters.insert( make_pair( "type", QUEUE ) );
            
            session->set( "exclusive_filters", filters );
            session->set( "paging", Paging::default_value );
            session->set( "include", STATE ); //in fields query use message:key
            
            m_repository->read( session, bind( &ExchangeImpl::create_message_and_read_queues_callback, this, _1, _2, _3 ) );
        }
        
        void ExchangeImpl::create_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            Resources resources;
            const shared_ptr< Formatter > parser = session->get( "content-format" );
            const bool parsing_success = parser->try_parse( session->get_request( )->get_body( ), resources );
            
            if ( not parsing_success )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because it was malformed.", session );
            }
            
            for ( auto& resource : resources )
            {
                if ( is_invalid( resource, type ) )
                {
                    return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains invalid property values.", session );
                }
                
                auto key = Key::make( );
                
                if ( resource.count( "key" ) )
                {
                    key = resource.lower_bound( "key" )->second;
                    
                    if ( Key::is_invalid( key ) )
                    {
                        return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because of a malformed identifier.", session );
                    }
                }
                
                remove_reserved_words( resource );
                initialise_default_values( resource, type );
                
                const auto datastamp = String::to_bytes( ::to_string( time( 0 ) ) );
                
                resource.insert( make_pair( "key", key ) );
                resource.insert( make_pair( "type", type ) );
                resource.insert( make_pair( "created", datastamp ) );
                resource.insert( make_pair( "modified", datastamp ) );
                resource.insert( make_pair( "revision", ETag::make( ) ) );
                resource.insert( make_pair( "origin", String::to_bytes( session->get_origin( ) ) ) );
            }
            
            if ( type not_eq SUBSCRIPTION )
            {
                return m_repository->create( resources, session, bind( &ExchangeImpl::create_resource_callback, this, _1, _2, _3 ) );
            }
            
            auto queue_keys = set< string > { };
            
            for ( auto& resource : resources )
            {
                auto iterators = resource.equal_range( "queues" );
                
                for ( auto iterator = iterators.first; iterator not_eq iterators.second; iterator++ )
                {
                    queue_keys.insert( String::to_string( iterator->second ) );
                }
            }
            
            session->set( "keys", vector< string >( queue_keys.begin( ), queue_keys.end( ) ) );
            session->set( "paging", Paging::default_value );
            session->set( "inclusive_filters", multimap< string, Bytes > { } );
            session->set( "include", SUBSCRIPTION );
            
            const auto filters = multimap< string, Bytes > { { "type", QUEUE } };
            session->set( "exclusive_filters", filters );
            
            m_repository->read( session, [ this, resources ]( const int status, const Resources items, const shared_ptr< Session > session )
            {
                if ( status == NOT_FOUND )
                {
                    return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because one or more subscription queues property values could not be found.", session );
                }
                else if ( status not_eq OK )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to read the repository resource entries.", session );
                }
                
                Resources queues;
                Resources subscriptions;
                
                for ( const auto& item : items )
                {
                    const auto type = item.lower_bound( "type" )->second;
                    
                    if ( type == QUEUE )
                    {
                        queues.push_back( item );
                    }
                    else if ( type == SUBSCRIPTION )
                    {
                        subscriptions.push_back( item );
                    }
                    else
                    {
                        log( Logger::ERROR, "Read Queue with related Subscriptions. However received additional resource type from repository; skipping selected resource." );
                    }
                }
                
                for ( const auto queue : queues )
                {
                    const auto key = String::lowercase( String::to_string( queue.lower_bound( "key" )->second ) );
                    const auto queue_subscription_limit = stoul( String::to_string( queue.lower_bound( "subscription-limit" )->second ) );
                    
                    const size_t new_count = count_if( resources.begin( ), resources.end( ), [ key ]( const Resource & resource )
                    {
                        return find_if( resource.begin( ), resource.end( ), [ key ]( const pair< string, Bytes >& property )
                        {
                            return property.first == "queues" and key == String::lowercase( String::to_string( property.second ) );
                        } ) not_eq resource.end( );
                    } );
                    
                    const size_t current_count = count_if( subscriptions.begin( ), subscriptions.end( ), [ key ]( const Resource & subscription )
                    {
                        return find_if( subscription.begin( ), subscription.end( ), [ key ]( const pair< string, Bytes >& property )
                        {
                            return property.first == "queues" and key == String::lowercase( String::to_string( property.second ) );
                        } ) not_eq subscription.end( );
                    } );
                    
                    if ( ( new_count + current_count ) > queue_subscription_limit )
                    {
                        return ErrorHandlerImpl::service_unavailable( "The exchange is refusing to process a request because a new subscription would violate a queue(s) subscription capacity.", session );
                    }
                }
                
                m_repository->create( resources, session, bind( &ExchangeImpl::create_resource_callback, this, _1, _2, _3 ) );
            } );
        }
        
        void ExchangeImpl::read_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            multimap< string, Bytes > filters = session->get( "exclusive_filters" );
            filters.insert( make_pair( "type", type ) );
            session->set( "exclusive_filters", filters );
            
            m_repository->read( session, bind( &ExchangeImpl::read_resource_callback, this, _1, _2, _3 ) );
        }
        
        void ExchangeImpl::update_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            Resources changeset;
            const shared_ptr< Formatter > parser = session->get( "content-format" );
            const bool parsing_success = parser->try_parse( session->get_request( )->get_body( ), changeset );
            
            if ( not parsing_success )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because it was malformed.", session );
            }
            
            if ( changeset.size( ) > 1 )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because multiple resources in an update are not supported.", session );
            }
            
            auto& change = changeset.back( );
            
            if ( is_update_invalid( change, type ) )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains invalid property values.", session );
            }
            
            remove_reserved_words( change );
            
            change.insert( make_pair( "type", type ) );
            change.insert( make_pair( "revision", ETag::make( ) ) );
            change.insert( make_pair( "modified", String::to_bytes( ::to_string( time( 0 ) ) ) ) );
            
            multimap< string, Bytes > filters = session->get( "exclusive_filters" );
            filters.insert( make_pair( "type", type ) );
            session->set( "exclusive_filters", filters );
            
            if ( type not_eq SUBSCRIPTION )
            {
                return m_repository->update( change, session, bind( &ExchangeImpl::update_resource_callback, this, _1, _2, _3 ) );
            }
            
            auto queue_keys = set< string > { };
            
            for ( auto& resource : changeset )
            {
                auto iterators = resource.equal_range( "queues" );
                
                for ( auto iterator = iterators.first; iterator not_eq iterators.second; iterator++ )
                {
                    queue_keys.insert( String::to_string( iterator->second ) );
                }
            }
            
            session->set( "keys", vector< string >( queue_keys.begin( ), queue_keys.end( ) ) );
            session->set( "paging", Paging::default_value );
            session->set( "inclusive_filters", multimap< string, Bytes > { } );
            session->set( "include", SUBSCRIPTION );
            
            const auto update_filters = multimap< string, Bytes > { { "type", QUEUE } };
            session->set( "exclusive_filters", update_filters );
            
            m_repository->read( session, [ this, changeset ]( const int status, const Resources items, const shared_ptr< Session > session )
            {
                if ( status == NOT_FOUND )
                {
                    return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because one or more subscription queues property values could not be found.", session );
                }
                else if ( status not_eq OK )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to read the repository resource entries.", session );
                }
                
                Resources queues;
                Resources subscriptions;
                
                for ( const auto& item : items )
                {
                    const auto type = item.lower_bound( "type" )->second;
                    
                    if ( type == QUEUE )
                    {
                        queues.push_back( item );
                    }
                    else if ( type == SUBSCRIPTION )
                    {
                        subscriptions.push_back( item );
                    }
                    else
                    {
                        log( Logger::ERROR, "Read Queue with related Subscriptions. However received additional resource type from repository; skipping selected resource." );
                    }
                }
                
                for ( const auto queue : queues )
                {
                    const auto key = String::lowercase( String::to_string( queue.lower_bound( "key" )->second ) );
                    const auto queue_subscription_limit = stoul( String::to_string( queue.lower_bound( "subscription-limit" )->second ) );
                    
                    const size_t new_count = count_if( changeset.begin( ), changeset.end( ), [ key ]( const Resource & resource )
                    {
                        return find_if( resource.begin( ), resource.end( ), [ key ]( const pair< string, Bytes >& property )
                        {
                            return property.first == "queues" and key == String::lowercase( String::to_string( property.second ) );
                        } ) not_eq resource.end( );
                    } );
                    
                    const size_t current_count = count_if( subscriptions.begin( ), subscriptions.end( ), [ key ]( const Resource & subscription )
                    {
                        return find_if( subscription.begin( ), subscription.end( ), [ key ]( const pair< string, Bytes >& property )
                        {
                            return property.first == "queues" and key == String::lowercase( String::to_string( property.second ) );
                        } ) not_eq subscription.end( );
                    } );
                    
                    if ( ( new_count + current_count ) > queue_subscription_limit )
                    {
                        return ErrorHandlerImpl::service_unavailable( "The exchange is refusing to process a request because a new subscription would violate a queue(s) subscription capacity.", session );
                    }
                }
                
                m_repository->update( changeset.back( ), session, bind( &ExchangeImpl::update_resource_callback, this, _1, _2, _3 ) );
            } );
        }
        
        void ExchangeImpl::delete_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            session->set( "paging", Paging::default_value );
            
            multimap< string, Bytes > filters = session->get( "exclusive_filters" );
            filters.insert( make_pair( "type", type ) );
            session->set( "exclusive_filters", filters );
            
            m_repository->destroy( session, [ ]( const int status, const shared_ptr< Session > session )
            {
                if ( status == NOT_FOUND )
                {
                    return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
                }
                else if ( status not_eq OK )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to update the repository resource entries.", session );
                }
                
                session->close( NO_CONTENT, { { "Date", Date::make( ) } } );
            } );
        }
        
        void ExchangeImpl::asterisk_resource_handler( const shared_ptr< Session > session )
        {
            const auto boot_time = system_clock::to_time_t( system_clock::now( ) ) - m_boot_time;
            
            multimap< string, string > headers
            {
                { "Allow", "OPTIONS" },
                { "Date", Date::make( ) },
                { "Uptime", ::to_string( boot_time ) },
                { "Workers", ::to_string( m_settings->get_worker_limit( ) ) },
                { "CPU", String::format( "%.1f%%", m_system->get_cpu_load( ) ) },
                { "Memory", String::format( "%.1f%%", m_system->get_memory_load( ) ) }
            };
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::options_resource_handler( const shared_ptr< Session > session, const Bytes& type, const string& options )
        {
            session->set( "paging", Paging::default_value );
            
            multimap< string, Bytes > filters = session->get( "exclusive_filters" );
            filters.insert( make_pair( "type", type ) );
            session->set( "exclusive_filters", filters );
            
            m_repository->read( session, [ options ]( const int status, const Resources, const shared_ptr< Session > session )
            {
                if ( status not_eq OK )
                {
                    return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
                }
                
                multimap< string, string > headers
                {
                    { "Allow", options },
                    { "Date", Date::make( ) }
                };
                
                if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
                {
                    headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
                }
                
                session->close( NO_CONTENT, headers );
            } );
        }
        
        void ExchangeImpl::create_resource_callback( const int status, const Resources resources, const shared_ptr< Session > session )
        {
            if ( status == CONFLICT )
            {
                return ErrorHandlerImpl::conflict( "The exchange is refusing to process the request because of a conflict with an existing resource.", session );
            }
            else if ( status not_eq CREATED )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to create the repository resource entry.", session );
            }
            
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( resources, session->get( "style" ) );
            
            multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "ETag", ETag::make( resources ) },
                { "Last-Modified", LastModified::make( ) },
                { "Allow", "GET,PUT,HEAD,DELETE,OPTIONS" },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Length", ContentLength::make( body ) },
                { "Content-Type",  ContentType::make( session ) },
                { "Location", Location::make( session, resources ) }
            };
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( CREATED, body, headers ) : session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::read_resource_callback( const int status, const Resources resources, const shared_ptr< Session > session )
        {
            if ( status == NOT_FOUND )
            {
                return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
            }
            else if ( status not_eq OK )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to read the repository resource entries.", session );
            }
            
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( resources, session->get( "style" ) );
            
            multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Content-MD5", ContentMD5::make( body ) },
                { "Content-Type", ContentType::make( session ) },
                { "Content-Length", ContentLength::make( body ) }
            };
            
            if ( not resources.empty( ) )
            {
                headers.insert( make_pair( "ETag", ETag::make( resources ) ) );
                headers.insert( make_pair( "Last-Modified", LastModified::make( resources ) ) );
            }
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( OK, body, headers ) : session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::update_resource_callback( const int status, const Resources resources, const shared_ptr< Session > session )
        {
            if ( status == NOT_FOUND )
            {
                return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
            }
            else if ( status not_eq OK and status not_eq NO_CONTENT )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to update the repository resource entries.", session );
            }
            
            multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Last-Modified", LastModified::make( resources ) }
            };
            
            if ( status == NO_CONTENT )
            {
                return session->close( NO_CONTENT, headers );
            }
            
            const shared_ptr< Formatter > composer = session->get( "accept-format" );
            const auto body = composer->compose( resources, session->get( "style" ) );
            
            headers.insert( make_pair( "ETag", ETag::make( resources ) ) );
            headers.insert( make_pair( "Allow", "GET,PUT,HEAD,DELETE,OPTIONS" ) );
            headers.insert( make_pair( "Content-MD5", ContentMD5::make( body ) ) );
            headers.insert( make_pair( "Content-Type",  ContentType::make( session ) ) );
            headers.insert( make_pair( "Content-Length", ContentLength::make( body ) ) );
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( OK, body, headers ) : session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::create_message_callback( const int status, const Resources resources, const shared_ptr< Session > session, const Resources states )
        {
            if ( status not_eq CREATED )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to create the repository message entry.", session );
            }
            
            const auto message_key = resources.back( ).lower_bound( "key" )->second;
            //session->set_header( "Location", String::format( "/messages/%.*s", message_key.size( ), message_key.data( ) ) );
            
            m_repository->create( states, session, [ this, message_key ]( const int status, const Resources, const shared_ptr< Session > session )
            {
                if ( status not_eq CREATED )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to create the repository message state entries.", session );
                }
                
                multimap< string, string > headers
                {
                    { "Allow", "OPTIONS" },
                    { "Date", Date::make( ) },
                    { "Location", String::format( "/messages/%.*s", message_key.size( ), message_key.data( ) ) }
                };
                
                if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
                {
                    headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
                }
                
                session->close( ACCEPTED, headers );
                m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
            } );
        }
        
        void ExchangeImpl::create_message_and_read_queues_callback( const int status, const Resources resources, const shared_ptr< Session > session )
        {
            if ( status == NOT_FOUND )
            {
                return ErrorHandlerImpl::not_found( "The exchange is refusing to process the request because the requested Queue(s) URI could not be found within the exchange.", session );
            }
            else if ( status not_eq OK )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to load the desired Queue(s).", session );
            }
            
            Resources queues;
            Resources states;
            
            for ( const auto& resource : resources )
            {
                const auto type = resource.lower_bound( "type" )->second;
                
                if ( type == QUEUE )
                {
                    queues.push_back( resource );
                }
                else if ( type == STATE )
                {
                    const auto key = String::lowercase( String::to_string( resource.lower_bound( "key" )->second ) );
                    
                    auto state = find_if( states.begin( ), states.end( ), [ &key ]( const Resource & state )
                    {
                        return key == String::lowercase( String::to_string( state.lower_bound( "key" )->second ) );
                    } );
                    
                    if ( state == states.end( ) )
                    {
                        states.push_back( resource );
                    }
                }
                else
                {
                    log( Logger::ERROR, "Read Queue with related Messages. However received additional resource type from repository; skipping selected resource." );
                }
            }
            
            const auto request = session->get_request( );
            auto message_size_limit = numeric_limits< unsigned long >::min( );
            request->get_header( "Content-Length", message_size_limit );
            
            multimap< string, Bytes > exclusive_filters;
            exclusive_filters.insert( make_pair( "type", SUBSCRIPTION ) );
            
            multimap< string, Bytes > inclusive_filters;
            
            for ( const auto& queue : queues )
            {
                const auto queue_key = queue.lower_bound( "key" )->second;
                const auto queue_message_size_limit = stoul( String::to_string( queue.lower_bound( "message-size-limit" )->second ) );
                
                if ( message_size_limit > queue_message_size_limit )
                {
                    return ErrorHandlerImpl::request_entity_too_large( "The exchange is refusing to process a request because the message entity is larger than the one or more of the queues is willing or able to process.", session );
                }
                
                inclusive_filters.insert( make_pair( "queues", queue_key ) );
                
                const size_t message_limit = count_if( states.begin( ), states.end( ), [ &queue_key ]( const Resource & state )
                {
                    return queue_key == state.lower_bound( "queue-key" )->second;
                } );
                
                const auto queue_message_limit = stoul( String::to_string( queue.lower_bound( "message-limit" )->second ) );
                
                if ( ( message_limit + 1 ) > queue_message_limit )
                {
                    return ErrorHandlerImpl::service_unavailable( "The exchange is refusing to process a request because the message would violate a queue(s) capacity.", session );
                }
            }
            
            session->set( "keys", vector< string > { } );
            session->set( "exclusive_filters", exclusive_filters );
            session->set( "inclusive_filters", inclusive_filters );
            
            m_repository->read( session, bind( &ExchangeImpl::create_message_and_read_subscriptions_callback, this, _1, _2, _3, queues ) );
        }
        
        void ExchangeImpl::create_message_and_read_subscriptions_callback( const int status, const Resources subscriptions, const shared_ptr< Session > session, const Resources queues )
        {
            if ( status not_eq OK )
            {
                return ErrorHandlerImpl::find_and_invoke_for( status, "The exchange is refusing to process the request because it has failed to load the associated Queue(s) Subscriptions.", session );
            }
            
            const auto message = make_message( session );
            const auto message_key = make_pair( "message-key", message.lower_bound( "key" )->second );
            
            Resources states;
            
            for ( const auto& subscription : subscriptions )
            {
                const auto properties = subscription.equal_range( "queues" );
                const auto subscription_key = make_pair( "subscription-key", subscription.lower_bound( "key" )->second );
                const auto subscription_endpoint = make_pair( "subscription-endpoint", subscription.lower_bound( "endpoint" )->second );
                
                for ( const auto& queue : queues )
                {
                    const auto queue_key = queue.lower_bound( "key" )->second;
                    
                    for ( auto property = properties.first; property not_eq properties.second; property++ )
                    {
                        if ( String::lowercase( String::to_string( property->second ) ) == String::lowercase( String::to_string( queue_key ) ) )
                        {
                            Resource state;
                            state.insert( make_pair( "type", STATE ) );
                            state.insert( make_pair( "key", Key::make( ) ) );
                            state.insert( make_pair( "status", PENDING ) );
                            state.insert( make_pair( "queue-key", queue_key ) );
                            state.insert( message_key );
                            state.insert( subscription_key );
                            state.insert( subscription_endpoint );
                            states.push_back( state );
                        }
                    }
                }
            }
            
            if ( states.empty( ) )
            {
                multimap< string, string > headers
                {
                    { "Date", Date::make( ) },
                };
                
                if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
                {
                    headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
                }
                
                return session->close( CREATED, headers );
            }
            
            m_repository->create( { message }, session, bind( &ExchangeImpl::create_message_callback, this, _1, _2, _3, states ) );
        }
    }
}
