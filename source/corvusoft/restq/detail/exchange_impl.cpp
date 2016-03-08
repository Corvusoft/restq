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
#include "corvusoft/restq/settings.hpp"
#include "corvusoft/restq/formatter.hpp"
#include "corvusoft/restq/repository.hpp"
#include "corvusoft/restq/status_code.hpp"
#include "corvusoft/restq/detail/ruleset.hpp"
#include "corvusoft/restq/detail/exchange_impl.hpp"

//External Includes
#include <corvusoft/restbed/http.hpp>
#include <corvusoft/restbed/request.hpp>
#include <corvusoft/restbed/response.hpp>
#include <corvusoft/restbed/resource.hpp>
#include <corvusoft/restbed/settings.hpp>

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
using std::exception;
using std::make_pair;
using std::shared_ptr;
using std::make_shared;
using std::regex_match;
using std::placeholders::_1;
using std::placeholders::_2;
using std::placeholders::_3;
using std::chrono::system_clock;

//Project Namespaces

//External Namespaces
using loadis::System;
using restbed::Http;
using restbed::Request;
using restbed::Service;
using restbed::Session;
using restbed::Response;
using restbed::Resource;
using restbed::Settings;

namespace restq
{
    namespace detail
    {
        const auto ExchangeImpl::QUEUE = String::to_bytes( "queue" );
        const auto ExchangeImpl::STATE = String::to_bytes( "state" );
        const auto ExchangeImpl::MESSAGE = String::to_bytes( "message" );
        const auto ExchangeImpl::SUBSCRIPTION = String::to_bytes( "subscription" );
        const auto ExchangeImpl::PENDING = String::to_bytes( "pending" );
        const auto ExchangeImpl::REJECTED = String::to_bytes( "rejected" );
        const auto ExchangeImpl::INFLIGHT = String::to_bytes( "in-flight" );
        const auto ExchangeImpl::DISPATCHED = String::to_bytes( "dispatched" );
        
        ExchangeImpl::ExchangeImpl( void ) : m_boot_time( 0 ),
            m_logger( nullptr ),
            m_system( new System ),
            m_repository( nullptr ),
            m_settings( nullptr ),
            m_service( nullptr ),
            m_ready_handler( nullptr ),
            m_key_rule( make_shared< Key >( ) ),
            m_keys_rule( make_shared< Keys >( ) ),
            m_paging_rule( make_shared< Paging >( ) ),
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
            settings->set_properties( m_settings->get_properties( ) );
            
            m_service = make_shared< restbed::Service >( );
            m_service->set_not_found_handler( Key::not_found_handler );
            m_service->set_error_handler( bind( &ExchangeImpl::internal_server_error_handler, this, _1, _2, _3 ) );
            m_service->set_method_not_allowed_handler( bind( &ExchangeImpl::method_not_allowed_handler, this, _1 ) );
            m_service->set_method_not_implemented_handler( bind( &ExchangeImpl::method_not_implemenented_handler, this, _1 ) );
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
            static const set< const string > invalid_headers
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
        
        bool ExchangeImpl::is_invalid( const multimap< string, Bytes >& value, const Bytes& type ) const
        {
            if ( type not_eq SUBSCRIPTION )
            {
                return false;
            }
            
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
            
            return false;
        }
        
        void ExchangeImpl::remove_reserved_words( multimap< string, Bytes >& resource ) const
        {
            resource.erase( "key" );
            resource.erase( "type" );
            resource.erase( "origin" );
            resource.erase( "created" );
            resource.erase( "revision" );
            resource.erase( "modified" );
        }
        
        void ExchangeImpl::remove_reserved_words( list< multimap< string, Bytes > >& resources ) const
        {
            for ( auto& resource : resources )
            {
                remove_reserved_words( resource );
            }
        }
        
        multimap< string, Bytes > ExchangeImpl::make_message( const shared_ptr< Session >& session ) const
        {
            const auto key = Key::make( );
            const auto request = session->get_request( );
            const auto body = request->get_body( );
            
            const auto message_datestamp = String::to_bytes( Date::make( ) );
            
            multimap< string, Bytes > message;
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
            m_service->add_rule( make_shared< ContentLength >( )    ,  4 );
            m_service->add_rule( make_shared< Range >( )            ,  4 );
            m_service->add_rule( make_shared< Expect >( )           ,  5 );
            m_service->add_rule( make_shared< Filters >( )          , 99 );
            m_service->add_rule( make_shared< Fields >( )           , 99 );
        }
        
        void ExchangeImpl::setup_queue_resource( void )
        {
            auto resource = make_shared< Resource >( );
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
            auto resource = make_shared< Resource >( );
            resource->set_path( "/queues" );
            resource->add_rule( m_keys_rule );
            resource->add_rule( m_paging_rule );
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
            auto resource = make_shared< Resource >( );
            resource->set_path( "/messages/{key: " + Key::pattern + "}" );
            resource->add_rule( m_key_rule );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, MESSAGE, "OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_messages_resource( void )
        {
            auto resource = make_shared< Resource >( );
            resource->set_paths( { "/messages", "/queues/{key: " + Key::pattern + "}/messages" } );
            resource->add_rule( m_key_rule );
            resource->add_rule( m_keys_rule );
            resource->set_method_handler( "POST", bind( &ExchangeImpl::create_message_handler, this, _1 ) );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, MESSAGE, "POST,OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_asterisk_resource( void )
        {
            auto resource = make_shared< Resource >( );
            resource->set_path( "\\*" );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::asterisk_resource_handler, this, _1 ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_subscription_resource( void )
        {
            auto resource = make_shared< Resource >( );
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
            auto resource = make_shared< Resource >( );
            resource->set_path( "/subscriptions" );
            resource->add_rule( m_keys_rule );
            resource->add_rule( m_paging_rule );
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
            static const vector< string > keys = { };
            static const pair< size_t, size_t > range = { 0, 1 };
            static const multimap< string, Bytes > filters = { { "type", STATE }, { "status", PENDING } };
            
            list< multimap< string, Bytes > > states;
            uint16_t status = m_repository->read( keys, range, filters, states );
            
            if ( status not_eq OK )
            {
                return log( Logger::ERROR, "Failed to read transaction states." );
            }
            else if ( states.empty( ) )
            {
                return;
            }
            
            
            const auto state_key = String::to_string( states.back( ).lower_bound( "key" )->second );
            status = m_repository->update( { state_key }, range, filters, { { "status", INFLIGHT } }, states );
            
            if ( status not_eq OK )
            {
                return log( Logger::ERROR, "Failed to update transaction status." );
            }
            else if ( status == NO_CONTENT )
            {
                return m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
            }
            
            
            list< multimap< string, Bytes > > messages;
            const auto message_key = String::to_string( states.back( ).lower_bound( "message-key" )->second );
            const auto subscription_key = String::to_string( states.back( ).lower_bound( "subscription-key" )->second );
            
            status = m_repository->read( { message_key }, range, { { "type", MESSAGE } }, messages );
            
            if ( status not_eq OK or messages.empty( ) )
            {
                log( Logger::WARNING, "Failed to read associated state message, purging." );
                m_repository->destroy( { state_key }, { { "type", STATE } } );
                return;
            }
            
            
            auto message = messages.back( );
            
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
            status = response->get_status_code( );
            
            if ( status == ACCEPTED )
            {
                status = m_repository->update( { state_key }, range, { { "type", STATE } }, { { "status", DISPATCHED } }, states );
                
                if ( status not_eq OK )
                {
                    log( Logger::ERROR, "Failed to update transaction status to dispatched." );
                }
                
                status = m_repository->destroy( { state_key }, { { "type", STATE } } );
            }
            else if ( status >= 200 and status <= 299 )
            {
                log( Logger::INFO, String::format( "Subscription '%s' rejected message '%s'.", subscription_key.data( ), message_key.data( ) ) );
                
                status = m_repository->update( { state_key }, range, { { "type", STATE } }, { { "status", REJECTED } }, states );
                
                if ( status not_eq OK )
                {
                    log( Logger::ERROR, "Failed to update transaction status to rejected." );
                }
                
                status = m_repository->destroy( { state_key }, { { "type", STATE } } );
            }
            else
            {
                return log( Logger::WARNING, String::format( "Failed to dispatch message '%s' to subscription '%s'.", message_key.data( ), subscription_key.data( ) ) );
            }
            
            Http::close( request );
            
            if ( m_repository->count( filters ) not_eq 0 )
            {
                m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
            }
        }
        
        void ExchangeImpl::create_message_handler( const shared_ptr< Session > session )
        {
            const auto request = session->get_request( );
            
            if ( request->get_header( "Content-Type" ).empty( ) )
            {
                static const string message = "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request.";
                return ContentType::unsupported_media_type_handler( message, session );
            }
            
            vector< string > keys = session->get( "keys" );
            multimap< string, Bytes > filters = session->get( "filters" );
            
            if ( request->has_path_parameter( "key" ) )
            {
                keys.clear( );
                filters.clear( );
                keys.push_back( request->get_path_parameter( "key" ) );
            }
            
            filters.insert( make_pair( "type", QUEUE ) );
            
            list< multimap< string, Bytes > > queues;
            uint16_t status = m_repository->read( keys, Paging::default_value, filters, queues );
            
            if ( status not_eq OK )
            {
                return Key::not_found_handler( session );
            }
            
            keys.clear( );
            filters.clear( );
            filters.insert( make_pair( "type", SUBSCRIPTION ) );
            
            const auto message = make_message( session );
            const auto message_key = message.lower_bound( "key" )->second;
            
            list< multimap< string, Bytes > > states;
            list< multimap< string, Bytes > > subscriptions;
            
            for ( const auto& queue : queues )
            {
                const auto queue_key = queue.lower_bound( "key" )->second;
                
                filters.erase( "queues" );
                filters.insert( make_pair( "queues", queue_key ) );
                
                status = m_repository->read( keys, Paging::default_value, filters, subscriptions );
                
                if ( status not_eq 200 )
                {
                    return Key::not_found_handler( session );
                }
                
                for ( const auto& subscription : subscriptions )
                {
                    multimap< string, Bytes > state;
                    state.insert( make_pair( "type", STATE ) );
                    state.insert( make_pair( "key", Key::make( ) ) );
                    state.insert( make_pair( "status", PENDING ) );
                    state.insert( make_pair( "queue-key", queue_key ) );
                    state.insert( make_pair( "message-key", message_key ) );
                    state.insert( make_pair( "subscription-key", subscription.lower_bound( "key" )->second ) );
                    state.insert( make_pair( "subscription-endpoint", subscription.lower_bound( "endpoint" )->second ) );
                    states.push_back( state );
                }
            }
            
            const auto location = String::format( "/messages/%.*s", message_key.size( ), message_key.data( ) );
            multimap< string, string > headers
            {
                { "Allow", "OPTIONS" },
                { "Location", location },
                { "Date", Date::make( ) },
            };
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            status = m_repository->create( { message } );
            
            if ( status not_eq CREATED )
            {
                return session->close( 500 );
            }
            
            if ( states.empty( ) )
            {
                filters.clear( );
                filters.insert( make_pair( "type", MESSAGE ) );
                status = m_repository->destroy( { String::to_string( message_key ) }, filters );
                
                if ( status not_eq OK )
                {
                    return session->close( 500 );
                }
            }
            else
            {
                status = m_repository->create( states );
                
                if ( status not_eq CREATED )
                {
                    return session->close( 500 );
                }
            }
            
            session->close( ACCEPTED, headers );
            m_service->schedule( bind( &ExchangeImpl::dispatch, this ) );
        }
        
        void ExchangeImpl::create_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            list< multimap< string, Bytes > > resources;
            const shared_ptr< Formatter > parser = session->get( "content-format" );
            const bool parsing_success = parser->try_parse( session->get_request( )->get_body( ), resources );
            
            if ( not parsing_success )
            {
                return Host::bad_request_handler( "The exchange is refusing to process the request because it was malformed.", session );
            }
            
            for ( auto& resource : resources )
            {
                if ( is_invalid( resource, type ) )
                {
                    return Host::bad_request_handler( "The exchange is refusing to process the request because the body contains invalid property values.", session );
                }
                
                Bytes key;
                
                if ( resource.count( "key" ) )
                {
                    key = resource.lower_bound( "key" )->second;
                    
                    if ( Key::is_invalid( key ) )
                    {
                        return Host::bad_request_handler( "The exchange is refusing to process the request because of a malformed identifier.", session );
                    }
                }
                else
                {
                    key = Key::make( );
                }
                
                remove_reserved_words( resource );
                
                const auto datastamp = String::to_bytes( ::to_string( time( 0 ) ) );
                
                resource.insert( make_pair( "key", key ) );
                resource.insert( make_pair( "type", type ) );
                resource.insert( make_pair( "created", datastamp ) );
                resource.insert( make_pair( "modified", datastamp ) );
                resource.insert( make_pair( "revision", ETag::make( ) ) );
                resource.insert( make_pair( "origin", String::to_bytes( session->get_origin( ) ) ) );
            }
            
            const auto status = m_repository->create( resources );
            
            if ( status not_eq CREATED )
            {
                return Key::conflict_handler( session );
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
        
        void ExchangeImpl::read_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            const vector< string > keys = session->get( "keys" );
            const pair< size_t, size_t > range = session->get( "paging", Paging::default_value );
            
            multimap< string, Bytes > filters = session->get( "filters" );
            filters.insert( make_pair( "type", type ) );
            
            list< multimap< string, Bytes > > resources;
            const auto status = m_repository->read( keys, range, filters, resources );
            
            if ( status not_eq OK )
            {
                return Key::not_found_handler( session );
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
        
        void ExchangeImpl::update_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            const shared_ptr< Formatter > parser = session->get( "content-format" );
            
            list< multimap< string, Bytes > > changeset;
            const bool parsing_success = parser->try_parse( session->get_request( )->get_body( ), changeset );
            
            if ( not parsing_success )
            {
                return Host::bad_request_handler( "The exchange is refusing to process the request because it was malformed.", session );
            }
            
            if ( changeset.size( ) > 1 )
            {
                return Host::bad_request_handler( "The exchange is refusing to process the request because multiple resources in an update are not supported.", session );
            }
            
            auto& change = changeset.back( );
            
            if ( is_invalid( change, type ) )
            {
                return Host::bad_request_handler( "The exchange is refusing to process the request because the body contains invalid property values.", session );
            }
            
            remove_reserved_words( change );
            
            change.insert( make_pair( "type", type ) );
            change.insert( make_pair( "revision", ETag::make( ) ) );
            change.insert( make_pair( "modified", String::to_bytes( ::to_string( time( 0 ) ) ) ) );
            
            const vector< string > keys = session->get( "keys" );
            const pair< size_t, size_t > range = session->get( "paging", Paging::default_value );
            
            multimap< string, Bytes > filters = session->get( "filters" );
            filters.insert( make_pair( "type", type ) );
            
            list< multimap< string, Bytes > > resources;
            const auto status = m_repository->update( keys, range, filters, change, resources );
            
            if ( status == NOT_FOUND )
            {
                return Key::not_found_handler( session );
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
            
            headers.insert( make_pair( "ETag", ETag::make( changeset ) ) );
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
        
        void ExchangeImpl::delete_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            multimap< string, Bytes > filters = session->get( "filters" );
            filters.insert( make_pair( "type", type ) );
            
            const auto status = m_repository->destroy( session->get( "keys" ), filters );
            
            if ( status not_eq OK )
            {
                return Key::not_found_handler( session );
            }
            
            session->close( NO_CONTENT, { { "Date", Date::make( ) } } );
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
                { "Memory", String::format( "%.1f%%", m_system->get_memory_load( ) ) },
                { "Queues", ::to_string( m_repository->count( { { "type", QUEUE } } ) ) },
                { "Messages", ::to_string( m_repository->count( { { "type", MESSAGE } } ) ) },
                { "Subscriptions", ::to_string( m_repository->count( { { "type", SUBSCRIPTION } } ) ) }
            };
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::options_resource_handler( const shared_ptr< Session > session, const Bytes& type, const string& options )
        {
            multimap< string, Bytes > filters = session->get( "filters" );
            filters.insert( make_pair( "type", type ) );
            
            list< multimap< string, Bytes > > resources;
            const auto status = m_repository->read( session->get( "keys" ), Paging::default_value, filters, resources );
            
            if ( status not_eq OK )
            {
                return Key::not_found_handler( session );
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
        }
        
        void ExchangeImpl::method_not_allowed_handler( const shared_ptr< Session > session )
        {
            static const list< multimap< string, Bytes > > values { {
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
        
        void ExchangeImpl::method_not_implemenented_handler( const shared_ptr< Session > session )
        {
            static const list< multimap< string, Bytes > > values { {
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
        
        void ExchangeImpl::internal_server_error_handler( const int status, const exception& error, const shared_ptr< restbed::Session > session )
        {
            const string message = error.what( );
            
            log( Logger::FATAL, String::format( "Internal Server Error: %s", message.data( ) ) );
            
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
    }
}
