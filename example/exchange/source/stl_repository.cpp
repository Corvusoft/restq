/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <memory>
#include <algorithm>

//Project Includes
#include "stl_repository.hpp"

//External Includes
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/status_code.hpp>

//System Namespaces
using std::list;
using std::pair;
using std::size_t;
using std::vector;
using std::string;
using std::advance;
using std::find_if;
using std::multimap;
using std::function;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restq::OK;
using restq::CREATED;
using restq::CONFLICT;
using restq::NOT_FOUND;
using restq::NO_CONTENT;
using restq::Bytes;
using restq::String;
using restq::Session;
using restq::Settings;
using restq::Resource;
using restq::Resources;
using restq::Repository;

STLRepository::STLRepository( void ) : Repository( ),
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

void STLRepository::create( const Resources values, const shared_ptr< Session > session, const function< void ( const int, const Resources, const shared_ptr< Session > ) >& callback )
{
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
            return callback( CONFLICT, values, session );
        }
    }
    
    m_resources.insert( m_resources.end( ), values.begin( ), values.end( ) );
    
    callback( CREATED, values, session );
}

void STLRepository::read( const shared_ptr< Session > session, const function< void ( const int, const Resources, const shared_ptr< Session > ) >& callback )
{
    Resources values;
    const vector< string > keys = session->get( "keys" );
    const pair< size_t, size_t > range = session->get( "paging" );
    const Resource filters = session->get( "filters" );
    
    Resources resources;
    
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
                return callback( NOT_FOUND, values, session );
            }
            
            resources.push_back( *resource );
        }
    }
    else
    {
        resources = m_resources;
    }
    
    bool matched = false;
    
    for ( auto resource = resources.begin( ); resource not_eq resources.end( ); resource++ )
    {
        for ( auto filter = filters.begin( ); filter not_eq filters.end( ); )
        {
            matched = false;
            const auto filter_range = filters.equal_range( filter->first );
            const auto property_range = resource->equal_range( filter->first );
            
            for ( auto filter_iterator = filter_range.first; filter_iterator not_eq filter_range.second; filter_iterator++ )
            {
                matched = std::any_of( property_range.first, property_range.second, [ &filter_iterator ]( const pair< string, Bytes >& property )
                {
                    return property.second == filter_iterator->second;
                } );
                
                if ( matched )
                {
                    break;
                }
            }
            
            if ( matched == false )
            {
                break;
            }
            
            if ( filter_range.second not_eq filters.end( ) )
            {
                filter = filter_range.second;
            }
            else
            {
                filter++;
            }
        }
        
        if ( matched == false )
        {
            resources.erase( resource );
        }
    }
    
    const auto& index = range.first;
    const auto& limit = range.second;
    
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
    
    callback( OK, values, session );
}

void STLRepository::update( const Resource changeset, const shared_ptr< Session > session, const function< void (  const int, const Resources, const shared_ptr< Session > ) >& callback  )
{
    read( session, [ changeset, callback, this ]( const int status_code, const Resources values, const shared_ptr< Session > session )
    {
        if ( status_code not_eq OK )
        {
            return callback( status_code, values, session );
        }
        
        int status = NO_CONTENT;
        
        auto resources = values;
        
        for ( auto& value : resources )
        {
            for ( const auto& change : changeset )
            {
                if ( change.first == "modified" or change.first == "revision" )
                {
                    continue;
                }
                
                auto property = value.find( change.first );
                
                if ( property == value.end( ) )
                {
                    value.insert( change );
                    status = OK;
                }
                else if ( property->second not_eq change.second )
                {
                    property->second = change.second;
                    status = OK;
                }
            }
            
            auto resource = find_if( m_resources.begin( ), m_resources.end( ), [ &value ]( const Resource & resource )
            {
                const auto lhs = String::to_string( value.lower_bound( "key" )->second );
                const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
                
                return String::lowercase( lhs ) == String::lowercase( rhs );
            } );
            
            *resource = value;
        }
        
        callback( status, resources, session );
    } );
}

void STLRepository::destroy( const shared_ptr< Session > session, const function< void ( const int, const shared_ptr< Session > ) >& callback )
{
    read( session, [ callback, this ]( const int status, const Resources resources, const shared_ptr< Session > session )
    {
        if ( status not_eq OK )
        {
            return callback( status, session );
        }
        
        for ( const auto resource : resources )
        {
            auto iterator = find_if( m_resources.begin( ), m_resources.end( ), [ &resource ]( const Resource & value )
            {
                const auto lhs = String::to_string( value.lower_bound( "key" )->second );
                const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
                
                return String::lowercase( lhs ) == String::lowercase( rhs );
            } );
            
            m_resources.erase( iterator );
        }
        
        callback( OK, session );
    } );
}
