/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <limits>
#include <string>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/query.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::size_t;
using std::string;
using std::vector;
using std::numeric_limits;

//Project Namespaces
using restq::Query;

//External Namespaces

TEST_CASE( "confirm default constructor throws no exceptions", "[query]" )
{
    REQUIRE_NOTHROW( new Query );
}

TEST_CASE( "validate default instance values", "[query]" )
{
    const Query query;
    
    REQUIRE( query.has_failed( ) == false );
    REQUIRE( query.get_error_code( ) == 0 );
    REQUIRE( query.get_keys( ) == vector< string >( ) );
    REQUIRE( query.get_index( ) == numeric_limits< size_t >::min( ) );
    REQUIRE( query.get_limit( ) == numeric_limits< size_t >::max( ) );
}

TEST_CASE( "confirm default destructor throws no exceptions", "[query]" )
{
    auto query = new Query;
    
    REQUIRE_NOTHROW( delete query );
}

TEST_CASE( "validate setters modify default values", "[query]" )
{
    Query query;
    
    query.set_index( 23 );
    query.set_limit( 345566 );
    query.set_error_code( 2000 );
    query.set_keys( vector< string >( { "ee6cd058-3df1-43ab-85c2-878ccf64e311", "ac0324ab-27ae-4477-ae10-9ab2ba376ee2" } ) );
    query.set_key( "62742612-53F1-40AB-A7AF-A39198F84235" );
    
    REQUIRE( query.get_index( ) == 23 );
    REQUIRE( query.has_failed( ) == true );
    REQUIRE( query.get_limit( ) == 345566 );
    REQUIRE( query.get_error_code( ) == 2000 );
    REQUIRE( query.get_keys( ) == vector< string >( { "ee6cd058-3df1-43ab-85c2-878ccf64e311", "ac0324ab-27ae-4477-ae10-9ab2ba376ee2", "62742612-53F1-40AB-A7AF-A39198F84235" } ) );
}

TEST_CASE( "validate clear returns query to default values", "[query]" )
{
    Query query;
    
    query.set_index( 9876 );
    query.set_limit( 76543 );
    query.set_error_code( 43 );
    query.set_keys( vector< string >( { "ee6cd058-3df1-43ab-85c2-878ccf64e311", "ac0324ab-27ae-4477-ae10-9ab2ba376ee2" } ) );
    query.clear( );
    
    REQUIRE( query.get_error_code( ) == 0 );
    REQUIRE( query.has_failed( ) == false );
    REQUIRE( query.get_keys( ) == vector< string >( ) );
    REQUIRE( query.get_index( ) == numeric_limits< size_t >::min( ) );
    REQUIRE( query.get_limit( ) == numeric_limits< size_t >::max( ) );
}
