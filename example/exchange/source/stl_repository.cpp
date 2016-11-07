/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <set>
#include <string>
#include <memory>
#include <algorithm>

//Project Includes
#include "stl_repository.hpp"

//External Includes
#include <corvusoft/restq/string.hpp>

//System Namespaces
using std::set;
using std::pair;
using std::mutex;
using std::size_t;
using std::vector;
using std::string;
using std::advance;
using std::find_if;
using std::function;
using std::multimap;
using std::shared_ptr;
using std::unique_lock;

//Project Namespaces

//External Namespaces
using restq::Bytes;
using restq::Query;
using restq::String;
using restq::Logger;
using restq::Settings;
using restq::Resource;
using restq::Resources;
using restq::Repository;

STLRepository::STLRepository( void ) : Repository( ),
    m_resources_lock( ),
    m_resources( )
{
    return;
}

STLRepository::~STLRepository( void )
{
    return;
}

void STLRepository::stop( void )
{
    return;
}

void STLRepository::start( const shared_ptr< const Settings >& )
{
    return;
}

void STLRepository::create( const Resources values, const shared_ptr< Query > query, const function< void ( const shared_ptr< Query > ) >& callback )
{
    unique_lock< mutex> lock( m_resources_lock );
    
    for ( const auto value : values )
    {
        bool conflict = any_of( m_resources.begin( ), m_resources.end( ), [ &value ]( const Resource & resource )
        {
            const auto lhs = String::to_string( value.lower_bound( "key" )->second );
            const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
            
            return String::lowercase( lhs ) == String::lowercase( rhs );
        } );
        
        if ( conflict )
        {
            query->set_error_code( 40009 );
            return callback( query );
        }
    }
    
    m_resources.insert( m_resources.end( ), values.begin( ), values.end( ) );
    
    lock.unlock( );
    
    auto results = fields( values, query );
    
    query->set_resultset( results );
    callback( query );
}

void STLRepository::read( const shared_ptr< Query > query, const function< void ( const shared_ptr< Query > ) >& callback )
{
    Resources values;
    Resources resources;
    const auto keys = query->get_keys( );
    
    unique_lock< mutex> lock( m_resources_lock );
    
    if ( not keys.empty( ) )
    {
        for ( const auto& key : keys )
        {
            auto resource = find_if( m_resources.begin( ), m_resources.end( ), [ &key ]( const Resource & resource )
            {
                if ( resource.count( "key" ) == 0 )
                {
                    return false;
                }
                
                return String::lowercase( key ) == String::lowercase( String::to_string( resource.lower_bound( "key" )->second ) );
            } );
            
            if ( resource == m_resources.end( ) )
            {
                query->set_error_code( 40004 );
                return callback( query );
            }
            
            resources.push_back( *resource );
        }
    }
    else
    {
        resources = m_resources;
    }
    
    lock.unlock( );
    
    filter( resources, query->get_inclusive_filters( ), query->get_exclusive_filters( ) ); //just pass query
    
    const auto& index = query->get_index( );
    const auto& limit = query->get_limit( );
    
    if ( index < resources.size( ) and limit not_eq 0 )
    {
        auto start = resources.begin( );
        advance( start, index );
        
        while ( start not_eq resources.end( ) and limit not_eq values.size( ) )
        {
            values.push_back( *start );
            start++;
        }
    }
    
    include( query->get_include( ), values );
    
    auto results = fields( values, query );
    
    query->set_resultset( results );
    callback( query );
}

void STLRepository::update( const Resource changeset, const shared_ptr< Query > query, const function< void ( const shared_ptr< Query > ) >& callback  )
{
    auto previous_fields = query->get_fields( );
    query->set_fields( { } );
    
    read( query, [ changeset, callback, this, previous_fields ]( const shared_ptr< Query > query )
    {
        query->set_fields( previous_fields );
        
        if ( query->has_failed( ) )
        {
            return callback( query );
        }
        
        unique_lock< mutex> lock( m_resources_lock );
        
        bool update_applied = false;
        
        auto results = query->get_resultset( );
        
        for ( auto& result : results )
        {
            for ( const auto& change : changeset )
            {
                if ( change.first == "modified" or change.first == "revision" )
                {
                    continue;
                }
                
                auto property = result.find( change.first );
                
                if ( property == result.end( ) )
                {
                    update_applied = true;
                    result.insert( change );
                }
                else if ( property->second not_eq change.second )
                {
                    update_applied = true;
                    property->second = change.second;
                }
            }
            
            auto resource = find_if( m_resources.begin( ), m_resources.end( ), [ &result ]( const Resource & resource )
            {
                const auto lhs = String::to_string( result.lower_bound( "key" )->second );
                const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
                
                return String::lowercase( lhs ) == String::lowercase( rhs );
            } );
            
            *resource = result;
        }
        
        lock.unlock( );
        
        results = fields( results, query );
        
        if ( update_applied )
        {
            query->set_resultset( results );
        }
        else
        {
            query->set_resultset( { } );
        }
        
        callback( query );
    } );
}

void STLRepository::destroy( const shared_ptr< Query > query, const function< void ( const shared_ptr< Query > ) >& callback )
{
    read( query, [ callback, this ]( const shared_ptr< Query > query )
    {
        if ( query->has_failed( ) )
        {
            if ( callback not_eq nullptr )
            {
                query->set_error_code( 40004 );
                return callback( query );
            }
            
            return;
        }
        
        unique_lock< mutex> lock( m_resources_lock );
        
        for ( const auto result : query->get_resultset( ) )
        {
            auto iterator = find_if( m_resources.begin( ), m_resources.end( ), [ &result ]( const Resource & value )
            {
                const auto lhs = String::to_string( value.lower_bound( "key" )->second );
                const auto rhs = String::to_string( result.lower_bound( "key" )->second );
                
                return String::lowercase( lhs ) == String::lowercase( rhs );
            } );
            
            m_resources.erase( iterator );
        }
        
        lock.unlock( );
        
        if ( callback not_eq nullptr )
        {
            callback( query );
        }
    } );
}

void STLRepository::set_logger( const shared_ptr< Logger >& )
{
    return;
}

void STLRepository::include( const Bytes& relationship, Resources& values )
{
    if ( relationship.empty( ) )
    {
        return;
    }
    
    Resources relationships;
    
    unique_lock< mutex> lock( m_resources_lock );
    
    if ( relationship == restq::SUBSCRIPTION )
    {
        for ( const auto& resource : m_resources )
        {
            if ( resource.lower_bound( "type" )->second == restq::SUBSCRIPTION )
            {
                auto iterators = resource.equal_range( "queues" );
                
                for ( const auto& queue : values )
                {
                    auto key = String::lowercase( String::to_string( queue.lower_bound( "key" )->second ) );
                    
                    for ( auto iterator = iterators.first; iterator not_eq iterators.second; iterator++ )
                    {
                        if ( key == String::lowercase( String::to_string( iterator->second ) ) )
                        {
                            relationships.push_back( resource );
                            break;
                        }
                    }
                }
            }
        }
    }
    else
    {
        for ( const auto& value : values )
        {
            const auto key = String::lowercase( String::to_string( value.lower_bound( "key" )->second ) );
            const auto type = value.lower_bound( "type" )->second;
            const auto foreign_key = String::to_string( type ) + "-key";
            
            for ( const auto& resource : m_resources )
            {
                if ( resource.lower_bound( "type" )->second == relationship )
                {
                    if ( resource.count( foreign_key ) and key == String::lowercase( String::to_string( resource.lower_bound( foreign_key )->second ) ) )
                    {
                        relationships.push_back( resource );
                    }
                }
            }
        }
    }
    
    lock.unlock( );
    
    values.insert( values.end( ), relationships.begin( ), relationships.end( ) );
}

Resources STLRepository::fields( const Resources& values, const shared_ptr< Query >& query )
{
    if ( not query->has_fields( ) )
    {
        return values;
    }
    
    Resources results = values;
    set< string > fields = query->get_fields( );
    
    for ( auto result = results.begin( ); result not_eq results.end( ); )
    {
        for ( auto property = result->begin( ); property not_eq result->end( ); )
        {
            if ( fields.count( property->first ) == 0 )
            {
                result->erase( property++ );
            }
            else
            {
                ++property;
            }
        }
        
        if ( result->empty( ) )
        {
            result = results.erase( result );
        }
        else
        {
            result++;
        }
    }
    
    return results;
}

void STLRepository::filter( Resources& resources, const multimap< string, Bytes >& inclusive_filters, const multimap< string, Bytes >& exclusive_filters ) const
{
    for ( auto resource = resources.begin( ); resource not_eq resources.end( ); resource++ )
    {
        bool failed = true;
        
        for ( const auto filter : exclusive_filters )
        {
            failed = true;
            
            const auto properties = resource->equal_range( filter.first );
            
            for ( auto property = properties.first; property not_eq properties.second; property++ )
            {
                if ( property->second == filter.second )
                {
                    failed = false;
                    break;
                }
            }
            
            if ( failed )
            {
                break;
            }
        }
        
        if ( failed and not exclusive_filters.empty( ) )
        {
            resource = resources.erase( resource );
            continue;
        }
        
        
        
        if ( inclusive_filters.empty( ) )
        {
            continue;
        }
        
        failed = true;
        
        for ( auto filter_iterator = inclusive_filters.begin( ); filter_iterator not_eq inclusive_filters.end( ); filter_iterator++ )
        {
            failed = true;
            
            const auto properties = resource->equal_range( filter_iterator->first );
            const auto filters = inclusive_filters.equal_range( filter_iterator->first );
            
            for ( auto filter = filters.first; filter not_eq filters.second; filter++ )
            {
                for ( auto property = properties.first; property not_eq properties.second; property++ )
                {
                    if ( property->second == filter->second )
                    {
                        failed = false;
                        break;
                    }
                }
                
                if ( not failed )
                {
                    break;
                }
            }
            
            if ( failed )
            {
                break;
            }
            
            if ( filters.second not_eq inclusive_filters.end( ) )
            {
                filter_iterator = filters.second;
            }
        }
        
        if ( failed )
        {
            resource = resources.erase( resource );
        }
    }
}
