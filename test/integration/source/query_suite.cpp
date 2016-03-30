/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <map>
#include <set>
#include <vector>
#include <memory>
#include <string>
#include <cstddef>
#include <utility>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/query.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/resource.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::set;
using std::pair;
using std::vector;
using std::string;
using std::multimap;
using std::shared_ptr;
using std::make_shared;

//Project Namespaces
using restq::Query;
using restq::Bytes;
using restq::String;
using restq::Session;
using restq::Resources;

//External Namespaces

TEST_CASE( "validate default instance values", "[query]" )
{
    const Query query;
    
    REQUIRE( query.get_include( ).empty( ) );
    REQUIRE( query.get_session( ) == nullptr );
    REQUIRE( query.has_resultset( ) == false );
    REQUIRE( query.get_resultset( ).empty( ) );
    REQUIRE( query.get_inclusive_filters( ).empty( ) );
    REQUIRE( query.get_exclusive_filters( ).empty( )  );
}

TEST_CASE( "validate session constructed instance values", "[query]" )
{
    auto session = make_shared< Session >( "test" );
    session->set( "include", String::to_bytes( "homeless" ) );
    
    const auto paging = pair< size_t, size_t > { 222, 989 };
    session->set( "paging", paging );
    
    const auto keys = vector< string > { "1234", "5678" };
    session->set( "keys", keys );
    
    const auto inclusive_filters = multimap< string, Bytes > { { "name", Bytes( { '5', '6', '7', '8' } ) } };
    session->set( "inclusive_filters", inclusive_filters );
    
    const auto exclusive_filters = multimap< string, Bytes > { { "name", Bytes( { '4', '3', '2', '1' } ) } };
    session->set( "exclusive_filters", exclusive_filters );
    
    const auto fields = set< string > { "asdf", "949449" };
    session->set( "fields", fields );
    
    const Query query( session );
    
    REQUIRE( query.get_keys( ) == keys );
    REQUIRE( query.get_fields( ) == fields );
    REQUIRE( query.has_resultset( ) == false );
    REQUIRE( query.get_resultset( ).empty( ) );
    REQUIRE( query.get_session( ) not_eq nullptr );
    REQUIRE( query.get_index( ) == paging.first );
    REQUIRE( query.get_limit( ) == paging.second );
    REQUIRE( query.get_inclusive_filters( ) == inclusive_filters );
    REQUIRE( query.get_exclusive_filters( ) == exclusive_filters  );
    REQUIRE( query.get_include( ) == String::to_bytes( "homeless" ) );
}

TEST_CASE( "validate setters modify default values", "[query]" )
{
    Resources resultset_expectation;
    resultset_expectation.push_back( multimap< string, Bytes > { { "name", Bytes( { 't', 'e', 's', 't' } ) } } );
    
    Query query;
    
    query.set_include( Bytes( { 't', 'y', 'p', 'e' } ) );
    query.set_resultset( resultset_expectation );
    query.set_session( make_shared< Session >( "My Test Session" ) );
    query.set_inclusive_filters( { { "category", { 'c', 'a', 'r', 's' } } } );
    query.set_inclusive_filter( "reg", { 'S', 'B', '5', '3', 'Y', 'U', 'K' } );
    query.set_exclusive_filters( { { "mileage", { '1', '8', '0', 'k', 'm' } } } );
    query.set_exclusive_filter( "reg", { 'S', 'B', '5', '3', 'Y', 'U', 'K' } );
    
    REQUIRE( query.get_session( )->get_id( ) == "My Test Session" );
    REQUIRE( query.get_include( ) == Bytes( { 't', 'y', 'p', 'e' } ) );
    
    auto inclusive_expectation = multimap< string, Bytes > { { "category", Bytes( { 'c', 'a', 'r', 's' } ) }, { "reg", Bytes( { 'S', 'B', '5', '3', 'Y', 'U', 'K' } ) } };
    REQUIRE( query.get_inclusive_filters( ) == inclusive_expectation );
    
    auto exclusive_expectation = multimap< string, Bytes > { { "mileage", Bytes( { '1', '8', '0', 'k', 'm' } ) }, { "reg", Bytes( { 'S', 'B', '5', '3', 'Y', 'U', 'K' } ) } };
    REQUIRE( query.get_exclusive_filters( ) == exclusive_expectation );
    
    REQUIRE( query.get_resultset( ) == resultset_expectation );
}

TEST_CASE( "validate clear returns query to default values", "[query]" )
{
    Resources resultset_expectation;
    resultset_expectation.push_back( multimap< string, Bytes > { { "name", Bytes( { 't', 'e', 's', 't' } ) } } );
    
    Query query;
    
    query.set_include( Bytes( { 't', 'y', 'p', 'e' } ) );
    query.set_resultset( resultset_expectation );
    query.set_session( make_shared< Session >( "My Test Session" ) );
    query.set_inclusive_filters( { { "category", { 'c', 'a', 'r', 's' } } } );
    query.set_exclusive_filters( { { "mileage", { '1', '8', '0', 'k', 'm' } } } );
    query.clear( );
    
    REQUIRE( query.get_include( ).empty( ) );
    REQUIRE( query.get_session( ) == nullptr );
    REQUIRE( query.has_resultset( ) == false );
    REQUIRE( query.get_resultset( ).empty( ) );
    REQUIRE( query.get_inclusive_filters( ).empty( ) );
    REQUIRE( query.get_exclusive_filters( ).empty( )  );
}
