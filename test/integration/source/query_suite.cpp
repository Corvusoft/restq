/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <map>
#include <memory>
#include <string>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/query.hpp>
#include <corvusoft/restq/session.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::string;
using std::multimap;
using std::shared_ptr;
using std::make_shared;

//Project Namespaces
using restq::Query;
using restq::Bytes;
using restq::Session;

//External Namespaces

TEST_CASE( "validate default instance values", "[query]" )
{
    const Query query;
    
    REQUIRE( query.get_include( ).empty( ) );
    REQUIRE( query.get_session( ) == nullptr );
    REQUIRE( query.get_inclusive_filters( ).empty( ) );
    REQUIRE( query.get_exclusive_filters( ).empty( )  );
}

TEST_CASE( "validate setters modify default values", "[query]" )
{
    Query query;
    
    query.set_include( Bytes( { 't', 'y', 'p', 'e' } ) );
    query.set_session( make_shared< Session >( "My Test Session" ) );
    query.set_inclusive_filters( { { "category", { 'c', 'a', 'r', 's' } } } );
    query.set_exclusive_filters( { { "mileage", { '1', '8', '0', 'k', 'm' } } } );
    
    REQUIRE( query.get_session( )->get_id( ) == "My Test Session" );
    REQUIRE( query.get_include( ) == Bytes( { 't', 'y', 'p', 'e' } ) );
    
    auto inclusive_expectation = multimap< string, Bytes > { { "category", Bytes( { 'c', 'a', 'r', 's' } ) } };
    REQUIRE( query.get_inclusive_filters( ) == inclusive_expectation );
    
    auto exclusive_expectation = multimap< string, Bytes > { { "mileage", Bytes( { '1', '8', '0', 'k', 'm' } ) } };
    REQUIRE( query.get_exclusive_filters( ) == exclusive_expectation );
}
