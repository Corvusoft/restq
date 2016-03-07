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
using restq::Settings;
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

size_t STLRepository::count( const multimap< string, Bytes >& filters )
{
    size_t count = 0;
    
    for ( const auto resource : m_resources )
    {
        bool rejected = false;
        
        for ( const auto filter : filters )
        {
            if ( resource.count( filter.first ) == 0 or resource.lower_bound( filter.first )->second not_eq filter.second )
            {
                rejected = true;
                break;
            }
        }
        
        if ( not rejected )
        {
            count++;
        }
    }
    
    return count;
}

int STLRepository::create( const list< multimap< string, Bytes > >& values )
{
    for ( const auto value : values )
    {
        bool conflict = any_of( m_resources.begin( ), m_resources.end( ), [ &value ]( const multimap< string, Bytes >& resource )
        {
            const auto lhs = String::to_string( value.lower_bound( "key" )->second );
            const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
            
            return String::lowercase( lhs ) == String::lowercase( rhs );
        } );
        
        if ( conflict )
        {
            return CONFLICT;
        }
    }
    
    m_resources.insert( m_resources.end( ), values.begin( ), values.end( ) );
    
    return CREATED;
}

int STLRepository::read( const vector< string >& keys, const pair< size_t, size_t >& range, const multimap< string, Bytes >& filters, list< multimap< string, Bytes > >& values )
{
    list< multimap< string, Bytes > > resources;
    
    if ( not keys.empty( ) )
    {
        for ( const auto& key : keys )
        {
            auto resource = find_if( m_resources.begin( ), m_resources.end( ), [ &key ]( const multimap< string, Bytes >& resource )
            {
                if ( resource.count( "key" ) == 0 )
                {
                    return false;
                }
                
                return String::lowercase( key ) == String::lowercase( String::to_string( resource.lower_bound( "key" )->second ) );
            } );
            
            if ( resource == m_resources.end( ) )
            {
                return NOT_FOUND;
            }
            
            resources.push_back( *resource );
        }
    }
    else
    {
        resources = m_resources;
    }
    
    for ( auto resource = resources.begin( ); resource not_eq resources.end( ); resource++ )
    {
        bool rejected = false;
        
        for ( const auto filter : filters )
        {
            const auto iterators = resource->equal_range( filter.first );
            
            rejected = true;
            
            for ( auto iterator = iterators.first; iterator not_eq iterators.second; iterator++ )
            {
                if ( iterator->second == filter.second )
                {
                    rejected = false;
                    break;
                }
            }
            
            if ( rejected )
            {
                break;
            }
        }
        
        if ( rejected )
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
    
    return OK;
}

int STLRepository::update( const vector< string >& keys, const pair< size_t, size_t >& range, const multimap< string, Bytes >& filters, const multimap< string, Bytes >& changeset, list< multimap< string, Bytes > >& values )
{
    int status = read( keys, range, filters, values );
    
    if ( status not_eq OK )
    {
        return status;
    }
    
    status = NO_CONTENT;
    
    for ( auto& value : values )
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
        
        auto resource = find_if( m_resources.begin( ), m_resources.end( ), [ &value ]( const multimap< string, Bytes >& resource )
        {
            const auto lhs = String::to_string( value.lower_bound( "key" )->second );
            const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
            
            return String::lowercase( lhs ) == String::lowercase( rhs );
        } );
        
        *resource = value;
    }
    
    return status;
}

int STLRepository::destroy( const vector< string >& keys, const multimap< string, Bytes >& filters )
{
    list< multimap< string, Bytes > > resources;
    static const pair< size_t, size_t > range = { 0, UINT_MAX };
    
    const int status = read( keys, range, filters, resources );
    
    if ( status not_eq OK )
    {
        return status;
    }
    
    for ( const auto resource : resources )
    {
        auto iterator = find_if( m_resources.begin( ), m_resources.end( ), [ &resource ]( const multimap< string, Bytes >& value )
        {
            const auto lhs = String::to_string( value.lower_bound( "key" )->second );
            const auto rhs = String::to_string( resource.lower_bound( "key" )->second );
            
            return String::lowercase( lhs ) == String::lowercase( rhs );
        } );
        
        m_resources.erase( iterator );
    }
    
    return OK;
}
