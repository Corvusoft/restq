/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <set>
#include <chrono>
#include <vector>
#include <functional>

//Project Includes
#include "corvusoft/restq/uri.hpp"
#include "corvusoft/restq/query.hpp"
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/session.hpp"
#include "corvusoft/restq/formatter.hpp"
#include "corvusoft/restq/repository.hpp"
#include "corvusoft/restq/status_code.hpp"
#include "corvusoft/restq/detail/rule.hpp"
#include "corvusoft/restq/detail/dispatch_impl.hpp"
#include "corvusoft/restq/detail/exchange_impl.hpp"
#include "corvusoft/restq/detail/validator_impl.hpp"
#include "corvusoft/restq/detail/error_handler_impl.hpp"

//External Includes
#include <cpu.h>
#include <memory.h>
#include <corvusoft/restbed/resource.hpp>

//System Namespaces
using std::set;
using std::pair;
using std::bind;
using std::list;
using std::string;
using std::vector;
using std::multimap;
using std::to_string;
using std::make_pair;
using std::shared_ptr;
using std::make_shared;
using std::chrono::seconds;
using std::placeholders::_1;

//Project Namespaces

//External Namespaces
using restbed::Service;
using restbed::Resource;

namespace restq
{
    namespace detail
    {
        ExchangeImpl::ExchangeImpl( void ) : m_logger( nullptr ),
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
            
            DispatchImpl::set_logger( m_logger );
            DispatchImpl::set_service( m_service );
            DispatchImpl::set_repository( m_repository );
            
            m_service->schedule( bind( DispatchImpl::route, DispatchImpl::PENDING ) );
            m_service->schedule( bind( DispatchImpl::route, DispatchImpl::SUSPENDED ), seconds( 1 ) );
            m_service->start( settings );
        }
        
        void ExchangeImpl::log( const Logger::Level level, const string& message ) const
        {
            if ( m_logger not_eq nullptr )
            {
                try
                {
                    m_logger->log( level, "%s", message.data( ) );
                }
                catch ( ... )
                {
                    fprintf( stderr, "failed to create log entry: %s", message.data( ) );
                }
            }
        }
        
        void ExchangeImpl::initialise_default_resource( Resource& value, const Bytes& type, const shared_ptr< Session >& session ) const
        {
            if ( value.count( "key" ) == 0 )
            {
                value.insert( make_pair( "key", Key::make( ) ) );
            }
            
            const auto datastamp = String::to_bytes( ::to_string( time( 0 ) ) );
            
            value.insert( make_pair( "type", type ) );
            value.insert( make_pair( "created", datastamp ) );
            value.insert( make_pair( "modified", datastamp ) );
            value.insert( make_pair( "revision", ETag::make( ) ) );
            value.insert( make_pair( "origin", String::to_bytes( session->get_origin( ) ) ) );
            
            if ( type == QUEUE )
            {
                value.insert( make_pair( "pattern", String::to_bytes( "pub-sub" ) ) );
                
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
                
                if ( not value.count( "max-delivery-attempts" ) )
                {
                    value.insert( make_pair( "max-delivery-attempts", String::to_bytes( ::to_string( m_settings->get_default_queue_max_delivery_attempts( ) ) ) ) );
                }
                
                if ( not value.count( "redelivery-interval" ) )
                {
                    value.insert( make_pair( "redelivery-interval", String::to_bytes( ::to_string( m_settings->get_default_queue_redelivery_interval( ).count( ) ) ) ) );
                }
            }
            else if ( type == SUBSCRIPTION )
            {
                if ( not value.count( "state" ) )
                {
                    value.insert( make_pair( "state", String::to_bytes( "reachable" ) ) );
                }
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
                if ( ValidatorImpl::is_valid_forwarding_header( header ) )
                {
                    message.insert( make_pair( header.first, String::to_bytes( header.second ) ) );
                }
            }
            
            string query = String::empty;
            multimap< string, Bytes > parameters = session->get( "filters" );
            
            for ( const auto parameter : parameters )
            {
                query += String::format( "%s=%.*s&", parameter.first.data( ), parameter.second.size( ), parameter.second.data( ) );
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
            m_service->add_rule( make_shared< Version >( )           , 4 );
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
            resource->set_path( "/queues/{key: " + ValidatorImpl::key_pattern + "}" );
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
            resource->set_path( "/messages/{key: " + ValidatorImpl::key_pattern + "}" );
            resource->add_rule( m_key_rule );
            resource->set_method_handler( "OPTIONS", bind( &ExchangeImpl::options_resource_handler, this, _1, MESSAGE, "OPTIONS" ) );
            
            m_service->publish( resource );
        }
        
        void ExchangeImpl::setup_messages_resource( void )
        {
            auto resource = make_shared< restbed::Resource >( );
            resource->set_paths( { "/messages", "/queues/{key: " + ValidatorImpl::key_pattern + "}/messages" } );
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
            resource->set_path( "/subscriptions/{key: " + ValidatorImpl::key_pattern + "}" );
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
        
        void ExchangeImpl::create_message_handler( const shared_ptr< Session > session )
        {
            const auto request = session->get_request( );
            
            //not request->has_header( "Content-Type" );
            if ( request->get_header( "Content-Type" ).empty( ) )
            {
                return ErrorHandlerImpl::unsupported_media_type( "The exchange is only capable of processing request entities which have content characteristics not supported according to the content-type header sent in the request.", session );
            }
            
            auto query = make_shared< Query >( session );
            
            if ( request->has_path_parameter( "key" ) )
            {
                query->clear( );
                query->set_session( session );
                query->set_key( request->get_path_parameter( "key" ) );
            }
            
            query->set_include( STATE );
            query->set_exclusive_filter( "type", QUEUE ); //set exclusive but include state? confusing no?
            
            m_repository->read( query, bind( &ExchangeImpl::create_message_and_read_queues_callback, this, _1 ) );
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
                if ( ValidatorImpl::has_reserved_create_fields( resource ) )
                {
                    return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains reserved properties.", session );
                }
                
                if ( ValidatorImpl::has_invalid_create_fields( resource, type ) )
                {
                    return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains invalid property values.", session );
                }
                
                if ( ValidatorImpl::has_invalid_key( resource ) )
                {
                    return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because of a malformed identifier.", session );
                }
                
                initialise_default_resource( resource, type, session );
            }
            
            if ( type not_eq SUBSCRIPTION )
            {
                auto query = make_shared< Query >( session );
                query->set_exclusive_filter( "type", type );
                return m_repository->create( resources, query, bind( &ExchangeImpl::create_resource_callback, this, _1 ) );
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
            
            auto query = make_shared< Query >( );
            query->set_session( session );
            query->set_keys( vector< string >( queue_keys.begin( ), queue_keys.end( ) ) );
            query->set_include( SUBSCRIPTION );
            query->set_exclusive_filter( "type", QUEUE );
            
            m_repository->read( query, [ this, resources ]( const shared_ptr< Query > query )
            {
                auto session = query->get_session( );
                
                if ( query->has_failed( ) )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because one or more subscription queues property values could not be found.", session );
                }
                
                Resources queues;
                Resources subscriptions;
                
                for ( const auto& result : query->get_resultset( ) )
                {
                    const auto type = result.lower_bound( "type" )->second;
                    
                    if ( type == QUEUE )
                    {
                        queues.push_back( result );
                    }
                    else if ( type == SUBSCRIPTION )
                    {
                        subscriptions.push_back( result );
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
                
                pair< size_t, size_t > paging = session->get( "paging" );
                query->set_index( paging.first );
                query->set_limit( paging.second );
                
                query->set_keys( session->get( "keys" ) );
                query->set_fields( session->get( "fields" ) );
                
                query->set_inclusive_filters( session->get( "inclusive_filters" ) );
                query->set_exclusive_filters( session->get( "exclusive_filters" ) );
                query->set_exclusive_filter( "type", SUBSCRIPTION );
                
                m_repository->create( resources, query, bind( &ExchangeImpl::create_resource_callback, this, _1 ) );
            } );
        }
        
        void ExchangeImpl::read_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            auto query = make_shared< Query >( session );
            query->set_exclusive_filter( "type", type );
            
            m_repository->read( query, bind( &ExchangeImpl::read_resource_callback, this, _1 ) );
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
            
            if ( ValidatorImpl::has_reserved_update_fields( change ) )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains reserved properties.", session );
            }
            
            if ( ValidatorImpl::has_invalid_update_fields( change, type ) )
            {
                return ErrorHandlerImpl::bad_request( "The exchange is refusing to process the request because the body contains invalid property values.", session );
            }
            
            change.insert( make_pair( "type", type ) );
            change.insert( make_pair( "revision", ETag::make( ) ) );
            change.insert( make_pair( "modified", String::to_bytes( ::to_string( time( 0 ) ) ) ) );
            
            if ( type not_eq SUBSCRIPTION )
            {
                auto query = make_shared< Query >( session );
                query->set_exclusive_filter( "type", type );
                return m_repository->update( change, query, bind( &ExchangeImpl::update_resource_callback, this, _1 ) );
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
            
            auto query = make_shared< Query >( );
            query->set_session( session );
            query->set_keys( vector< string >( queue_keys.begin( ), queue_keys.end( ) ) );
            query->set_include( SUBSCRIPTION );
            query->set_exclusive_filter( "type", QUEUE );
            
            m_repository->read( query, [ this, changeset ]( const shared_ptr< Query > query )
            {
                auto session = query->get_session( );
                
                if ( query->has_failed( ) )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because one or more subscription queues property values could not be found.", session );
                }
                
                Resources queues;
                Resources subscriptions;
                
                for ( const auto& result : query->get_resultset( ) )
                {
                    const auto type = result.lower_bound( "type" )->second;
                    
                    if ( type == QUEUE )
                    {
                        queues.push_back( result );
                    }
                    else if ( type == SUBSCRIPTION )
                    {
                        subscriptions.push_back( result );
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
                
                pair< size_t, size_t > paging = session->get( "paging" );
                query->set_index( paging.first );
                query->set_limit( paging.second );
                
                query->set_keys( session->get( "keys" ) );
                query->set_fields( session->get( "fields" ) );
                
                query->set_inclusive_filters( session->get( "inclusive_filters" ) );
                query->set_exclusive_filters( session->get( "exclusive_filters" ) );
                query->set_exclusive_filter( "type", SUBSCRIPTION );
                
                m_repository->update( changeset.back( ), query, bind( &ExchangeImpl::update_resource_callback, this, _1 ) );
            } );
        }
        
        void ExchangeImpl::delete_resource_handler( const shared_ptr< Session > session, const Bytes& type )
        {
            auto query = make_shared< Query >( session );
            query->set_exclusive_filter( "type", type );
            
            m_repository->destroy( query, [ ]( const shared_ptr< Query > query )
            {
                auto session = query->get_session( );
                
                if ( query->has_failed( ) )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
                }
                
                session->close( NO_CONTENT, { { "Date", Date::make( ) } } );
            } );
        }
        
        void ExchangeImpl::asterisk_resource_handler( const shared_ptr< Session > session )
        {
#ifdef _WIN32
            multimap< string, string > headers
            {
                { "Allow", "OPTIONS" },
                { "Date", Date::make( ) },
                { "Uptime", ::to_string( m_service->get_uptime( ).count( ) ) },
                { "Workers", ::to_string( m_settings->get_worker_limit( ) ) },
            };
#else
            static const unsigned cpu_usage_delay = 990000;
            const float cpu_usage = cpu_percentage( cpu_usage_delay );
            
            MemoryStatus memory_status;
            mem_status( memory_status );
            const float memory_usage = memory_status.used_mem / memory_status.total_mem * 100;
            
            multimap< string, string > headers
            {
                { "Allow", "OPTIONS" },
                { "Date", Date::make( ) },
                { "Uptime", ::to_string( m_service->get_uptime( ).count( ) ) },
                { "Workers", ::to_string( m_settings->get_worker_limit( ) ) },
                { "CPU", String::format( "%.1f%%", cpu_usage ) },
                { "Memory", String::format( "%.1f%%", memory_usage ) }
            };
#endif
            
            if ( session->get_headers( ).count( "Accept-Ranges" ) == 0 )
            {
                headers.insert( make_pair( "Accept-Ranges", AcceptRanges::make( ) ) );
            }
            
            session->close( NO_CONTENT, headers );
        }
        
        void ExchangeImpl::options_resource_handler( const shared_ptr< Session > session, const Bytes& type, const string& options )
        {
            auto query = make_shared< Query >( session );
            query->set_exclusive_filter( "type", type );
            
            m_repository->read( query, [ options ]( const shared_ptr< Query > query )
            {
                auto session = query->get_session( );
                
                if ( query->has_failed( ) )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "", session );
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
        
        void ExchangeImpl::create_resource_callback( const shared_ptr< Query > query )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because of a conflict with an existing resource.", session );
            }
            
            const auto resources = query->get_resultset( );
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
            ( echo ) ? session->close( CREATED, body, headers ) : session->close( CREATED, headers );
        }
        
        void ExchangeImpl::read_resource_callback( const shared_ptr< Query > query )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "", session );
            }
            
            const auto resources = query->get_resultset( );
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
            
            if ( session->get_request( )->get_method( String::lowercase ) == "head" )
            {
                return session->close( NO_CONTENT, headers );
            }
            
            const bool echo = session->get( "echo" );
            ( echo ) ? session->close( OK, body, headers ) : session->close( OK, headers );
        }
        
        void ExchangeImpl::update_resource_callback( const shared_ptr< Query > query )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because the requested URI could not be found within the exchange.", session );
            }
            
            const auto resources = query->get_resultset( );
            
            multimap< string, string > headers
            {
                { "Date", Date::make( ) },
                { "Last-Modified", LastModified::make( resources ) }
            };
            
            if ( not query->has_resultset( ) )
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
            ( echo ) ? session->close( OK, body, headers ) : session->close( OK, headers );
        }
        
        void ExchangeImpl::create_message_callback( const shared_ptr< Query > query, const Resources states )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because it has failed to create the repository message entry.", session );
            }
            
            const auto resources = query->get_resultset( );
            const auto message_key = resources.back( ).lower_bound( "key" )->second;
            //session->set_header( "Location", String::format( "/messages/%.*s", message_key.size( ), message_key.data( ) ) );
            
            query->clear( );
            query->set_session( session );
            query->set_exclusive_filter( "type", STATE );
            
            m_repository->create( states, query, [ this, message_key ]( const shared_ptr< Query > query )
            {
                auto session = query->get_session( );
                
                if ( query->has_failed( ) )
                {
                    return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because it has failed to create the repository message state entries.", session );
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
                m_service->schedule( bind( DispatchImpl::route, DispatchImpl::PENDING ) );
            } );
        }
        
        void ExchangeImpl::create_message_and_read_queues_callback( const shared_ptr< Query > query )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because the requested Queue(s) URI could not be found within the exchange.", session );
            }
            
            const auto resources = query->get_resultset( );
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
                    //we get the states back just to COUNT their number!!!! see count_if below.
                    //this must go! m_repository->count( Query );
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
            auto message_size_limit = request->get_header( "Content-Length", numeric_limits< unsigned long >::min( ) );
            
            query->clear( );
            query->set_session( session );
            query->set_exclusive_filter( "type", SUBSCRIPTION );
            query->set_exclusive_filter( "state", String::to_bytes( "reachable" ) );
            
            for ( const auto& queue : queues )
            {
                const auto queue_key = queue.lower_bound( "key" )->second;
                const auto queue_message_size_limit = stoul( String::to_string( queue.lower_bound( "message-size-limit" )->second ) );
                
                if ( message_size_limit > queue_message_size_limit )
                {
                    return ErrorHandlerImpl::request_entity_too_large( "The exchange is refusing to process a request because the message entity is larger than the one or more of the queues is willing or able to process.", session );
                }
                
                query->set_inclusive_filter( "queues", queue_key );
                
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
            
            m_repository->read( query, bind( &ExchangeImpl::create_message_and_read_subscriptions_callback, this, _1, queues ) );
        }
        
        void ExchangeImpl::create_message_and_read_subscriptions_callback( const shared_ptr< Query > query, const Resources queues )
        {
            auto session = query->get_session( );
            
            if ( query->has_failed( ) )
            {
                return ErrorHandlerImpl::find_and_invoke_for( query->get_error_code( ), "The exchange is refusing to process the request because it has failed to load the associated Queue(s) Subscriptions.", session );
            }
            
            const auto subscriptions = query->get_resultset( );
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
                    const auto redelivery_interval = queue.lower_bound( "redelivery-interval" )->second;
                    const auto max_delivery_attempts = queue.lower_bound( "max-delivery-attempts" )->second;
                    
                    for ( auto property = properties.first; property not_eq properties.second; property++ )
                    {
                        if ( String::lowercase( String::to_string( property->second ) ) == String::lowercase( String::to_string( queue_key ) ) )
                        {
                            Resource state;
                            state.insert( make_pair( "type", STATE ) );
                            state.insert( make_pair( "key", Key::make( ) ) );
                            state.insert( make_pair( "status", DispatchImpl::PENDING ) );
                            state.insert( make_pair( "queue-key", queue_key ) );
                            state.insert( make_pair( "redelivery-interval", redelivery_interval ) );
                            state.insert( make_pair( "max-delivery-attempts", max_delivery_attempts ) );
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
            
            query->clear( );
            query->set_session( session );
            
            pair< size_t, size_t > paging = session->get( "paging" );
            query->set_index( paging.first );
            query->set_limit( paging.second );
            
            query->set_keys( session->get( "keys" ) );
            query->set_fields( session->get( "fields" ) );
            
            query->set_inclusive_filters( session->get( "inclusive_filters" ) );
            query->set_exclusive_filters( session->get( "exclusive_filters" ) );
            query->set_exclusive_filter( "type", MESSAGE );
            
            m_repository->create( { message }, query, bind( &ExchangeImpl::create_message_callback, this, _1, states ) );
        }
    }
}
