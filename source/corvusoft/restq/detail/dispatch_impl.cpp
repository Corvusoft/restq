/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <functional>

//Project Includes
#include "corvusoft/restq/query.hpp"
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/request.hpp"
#include "corvusoft/restq/response.hpp"
#include "corvusoft/restq/repository.hpp"
#include "corvusoft/restq/status_code.hpp"
#include "corvusoft/restq/detail/rule/date.hpp"
#include "corvusoft/restq/detail/dispatch_impl.hpp"
#include "corvusoft/restq/detail/rule/content_length.hpp"

//External Includes
#include <corvusoft/restbed/uri.hpp>
#include <corvusoft/restbed/http.hpp>

//System Namespaces
using std::string;
using std::shared_ptr;
using std::make_shared;

//Project Namespaces

//External Namespaces
using restbed::Uri;
using restbed::Http;
using restbed::Service;

namespace restq
{
    namespace detail
    {
        const Bytes DispatchImpl::PENDING = String::to_bytes( "pending" );
        const Bytes DispatchImpl::REJECTED = String::to_bytes( "rejected" );
        const Bytes DispatchImpl::INFLIGHT = String::to_bytes( "in-flight" );
        const Bytes DispatchImpl::DISPATCHED = String::to_bytes( "dispatched" );
        
        std::shared_ptr< Logger > DispatchImpl::m_logger = nullptr;
        
        std::shared_ptr< Service > DispatchImpl::m_service = nullptr;
        
        std::shared_ptr< Repository > DispatchImpl::m_repository = nullptr;
        
        void DispatchImpl::route( void )
        {
            auto query = make_shared< Query >( );
            query->set_limit( 1 );
            query->set_exclusive_filter( "type", STATE );
            query->set_exclusive_filter( "status", PENDING );
            
            m_repository->read( query, [ ]( const shared_ptr< Query > query )
            {
                if ( query->has_failed( ) )
                {
                    return log( Logger::ERROR, "Failed to read transaction states." );
                }
                
                if ( not query->has_resultset( ) )
                {
                    return;
                }
                
                const auto states = query->get_resultset( );
                
                auto state_key = states.back( ).lower_bound( "key" )->second;
                query->set_key( state_key );
                
                m_repository->update( { { "status", INFLIGHT } }, query, [ state_key ]( const shared_ptr< Query > query )
                {
                    if ( query->has_failed( ) )
                    {
                        return log( Logger::ERROR, "Failed to update transaction status." );
                    }
                    
                    if ( not query->has_resultset( ) )
                    {
                        return;
                    }
                    
                    const auto states = query->get_resultset( );
                    
                    query->clear( );
                    query->set_limit( 1 );
                    query->set_exclusive_filter( "type", MESSAGE );
                    query->set_key( states.back( ).lower_bound( "message-key" )->second );
                    
                    m_repository->read( query, [ state_key, states ]( const shared_ptr< Query > query )
                    {
                        if ( query->has_failed( ) or not query->has_resultset( ) )
                        {
                            query->clear( );
                            query->set_key( state_key );
                            query->set_exclusive_filter( "type", STATE );
                            
                            log( Logger::WARNING, "Failed to read associated state message, purging." );
                            
                            return m_repository->destroy( query );
                        }
                        
                        auto message = query->get_resultset( ).back( );
                        
                        query->clear( );
                        query->set_key( state_key );
                        query->set_exclusive_filter( "type", STATE );
                        
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
                        
                        m_repository->update( change, query, [ ]( const shared_ptr< Query > query )
                        {
                            if ( query->has_failed( ) )
                            {
                                log( Logger::ERROR, "Failed to update transaction status to dispatched." );
                            }
                            
                            m_repository->destroy( query, [ ]( const shared_ptr< Query > )
                            {
                                m_service->schedule( DispatchImpl::route );
                            } );
                        } );
                    } );
                } );
            } );
        }
        
        void DispatchImpl::set_logger( const std::shared_ptr< Logger >& value )
        {
            m_logger = value;
        }
        
        void DispatchImpl::set_repository( const std::shared_ptr< Repository >& value )
        {
            m_repository = value;
        }
        
        void DispatchImpl::set_service( const std::shared_ptr< restbed::Service >& value )
        {
            m_service = value;
        }
        
        void DispatchImpl::log( const Logger::Level level, const string& message )
        {
            if ( m_logger not_eq nullptr )
            {
                m_logger->log( level, "%s", message.data( ) );
            }
        }
    }
}
