/*
 * Copyright 2013-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <stdexcept>

//Project Includes
#include "json_formatter.hpp"

//External Includes
#include <corvusoft/restq/string.hpp>

//System Namespaces
using std::list;
using std::stol;
using std::string;
using std::distance;
using std::multimap;
using std::to_string;
using std::exception;
using std::out_of_range;
using std::domain_error;

//Project Namespaces

//External Namespaces
using restq::Bytes;
using restq::String;
using restq::Resource;
using restq::Resources;
using restq::Formatter;
using nlohmann::json;

JSONFormatter::JSONFormatter( void )
{
    return;
}

JSONFormatter::~JSONFormatter( void )
{
    return;
}

Resources JSONFormatter::parse( const Bytes& value )
{
    auto json = json::parse( String::to_string( value ) );
    
    if ( json.count( "data" ) == 0 )
    {
        throw domain_error( "Root property must be named 'data'." );
    }
    
    auto data = json[ "data" ];
    Resources resources;
    
    if ( data.is_array( ) )
    {
        for ( const auto object : data )
        {
            if ( not object.is_object( ) )
            {
                throw domain_error( "Root array child elements must be objects." );
            }
            
            resources.push_back( parse_object( object ) );
        }
    }
    else if ( data.is_object( ) )
    {
        resources.push_back( parse_object( data ) );
    }
    else
    {
        throw domain_error( "Root property must be unordered set or object." );
    }
    
    return resources;
}

bool JSONFormatter::try_parse( const Bytes& value, Resources& values ) noexcept
{
    try
    {
        values = parse( value );
    }
    catch ( const exception& )
    {
        return false;
    }
    
    return true;
}

Bytes JSONFormatter::compose( const Resources& values, const bool styled )
{
    auto json = json::object( );
    
    if ( values.size( ) == 1 )
    {
        json[ "data" ] = compose_object( values.front( ) );
    }
    else
    {
        auto objects = json::array( );
        
        for ( const auto& value : values )
        {
            objects.push_back( compose_object( value ) );
        }
        
        json[ "data" ] = objects;
    }
    
    return to_bytes( json, styled );
}

const string JSONFormatter::get_mime_type( void ) const
{
    return "application/json";
}

string JSONFormatter::to_string( const json& value ) const
{
    if ( value.is_string( ) )
    {
        return value.get< string >( );
    }
    else if ( value.is_boolean( ) )
    {
        return ( value.get< bool >( ) == true ) ? "true" : "false";
    }
    else if ( value.is_number_integer( ) )
    {
        return ::to_string( value.get< long >( ) );
    }
    else if ( value.is_number_float( ) )
    {
        return ::to_string( value.get< double >( ) );
    }
    
    throw domain_error( "Data-type not supported." );
}

Bytes JSONFormatter::to_bytes( const json& json, bool styled ) const
{
    auto data = ( styled ) ? json.dump( 4 ) : json.dump( );
    return Bytes( data.begin( ), data.end( ) );
}

json JSONFormatter::compose_object( const Resource& value ) const
{
    auto object = json::object( );
    
    for ( auto iterator = value.begin( ); iterator not_eq value.end( ); iterator++ )
    {
        auto iterators = value.equal_range( iterator->first );
        const auto length = distance( iterators.first, iterators.second );
        
        if ( length > 1 )
        {
            auto items = json::array( );
            
            for ( auto item = iterators.first; item not_eq iterators.second; item++ )
            {
                auto field = String::to_string( item->second );
                
                if ( String::is_boolean( field ) )
                {
                    items.push_back( String::lowercase( field ) == "true" );
                }
                else if ( String::is_integer( field ) )
                {
                    try
                    {
                        items.push_back( stol( field ) );
                    }
                    catch ( const out_of_range& )
                    {
                        items.push_back( field );
                    }
                }
                else if ( String::is_fraction( field ) )
                {
                    try
                    {
                        items.push_back( stod( field ) );
                    }
                    catch ( const out_of_range& )
                    {
                        items.push_back( field );
                    }
                }
                else
                {
                    items.push_back( field );
                }
            }
            
            object[ iterator->first ] = items;
            
            advance( iterator, length - 1 );
        }
        else
        {
            auto field = String::to_string( iterator->second );
            
            if ( String::is_boolean( field ) )
            {
                object[ iterator->first ] = ( String::lowercase( field ) == "true" );
            }
            else if ( String::is_integer( field ) )
            {
                try
                {
                    object[ iterator->first ] = stol( field );
                }
                catch ( const out_of_range& )
                {
                    object[ iterator->first ] = field;
                }
            }
            else if ( String::is_fraction( field ) )
            {
                try
                {
                    object[ iterator->first ] = stod( field );
                }
                catch ( const out_of_range& )
                {
                    object[ iterator->first ] = field;
                }
            }
            else
            {
                object[ iterator->first ] = field;
            }
        }
    }
    
    return object;
}

Resource JSONFormatter::parse_object( const json& value ) const
{
    Resource object;
    
    for ( auto iterator = value.begin( ); iterator not_eq value.end( ); iterator++ )
    {
        if ( iterator->is_object( ) )
        {
            throw domain_error( "Child objects are not supported." );
        }
        else if ( iterator->is_array( ) )
        {
            for ( const auto& item : *iterator )
            {
                if ( item.is_object( ) )
                {
                    throw domain_error( "Child objects are not supported." );
                }
                else if ( item.is_array( ) )
                {
                    throw domain_error( "Child unordered sets are not supported." );
                }
                
                auto value = to_string( item );
                object.insert( make_pair( iterator.key( ), String::to_bytes( value ) ) );
            }
        }
        else
        {
            auto value = to_string( *iterator );
            object.insert( make_pair( iterator.key( ), String::to_bytes( value ) ) );
        }
    }
    
    return object;
}
