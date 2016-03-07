/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <string>

//Project Includes
#include "corvusoft/restq/string.hpp"

//External Includes
#include <catch.hpp>

//System Namespaces
using std::string;

//Project Namespaces
using restq::String;

//External Namespaces

TEST_CASE( "test if a string is in a boolean representation", "[string]" )
{
    REQUIRE( String::is_boolean( "true" ) == true );
    REQUIRE( String::is_boolean( "TRUE" ) == true );
    REQUIRE( String::is_boolean( "TrUe" ) == true );
    REQUIRE( String::is_boolean( "false" ) == true );
    REQUIRE( String::is_boolean( "FALSE" ) == true );
    REQUIRE( String::is_boolean( "FaLsE" ) == true );
    
    REQUIRE( String::is_boolean( "" ) == false );
    REQUIRE( String::is_boolean( "0" ) == false );
    REQUIRE( String::is_boolean( "ON" ) == false );
    REQUIRE( String::is_boolean( "()jhoigaowj)" ) == false );
}

TEST_CASE( "test if a string is in a integer representation", "[string]" )
{
    REQUIRE( String::is_integer( "0" ) == true );
    REQUIRE( String::is_integer( "1" ) == true );
    REQUIRE( String::is_integer( "836272" ) == true );
    
    REQUIRE( String::is_integer( "" ) == false );
    REQUIRE( String::is_integer( "ON" ) == false );
    REQUIRE( String::is_integer( "()jhoigaowj)" ) == false );
}

TEST_CASE( "test if a string is in a real representation", "[string]" )
{
    REQUIRE( String::is_fraction( "1.1" ) == true );
    REQUIRE( String::is_fraction( "0.0" ) == true );
    
    REQUIRE( String::is_fraction( "" ) == false );
    REQUIRE( String::is_fraction( "0" ) == false );
    REQUIRE( String::is_fraction( "ON" ) == false );
    REQUIRE( String::is_fraction( "()jhoigaowj)" ) == false );
}

TEST_CASE( "trim", "[string]" )
{
    REQUIRE( String::trim( "\n\r\t  Corvusoft Solutions\t\n\r " ) == "Corvusoft Solutions" );
}

TEST_CASE( "trim with empty", "[string]" )
{
    REQUIRE( String::trim( "" ) == "" );
}

TEST_CASE( "trim with no whitespace", "[string]" )
{
    REQUIRE( String::trim( "CorvusoftSolutions" ) == "CorvusoftSolutions" );
}

TEST_CASE( "trim leading", "[string]" )
{
    REQUIRE( String::trim_leading( "\n\r\t  Corvusoft Solutions\t\n\r " ) == "Corvusoft Solutions\t\n\r " );
}

TEST_CASE( "trim leading with empty", "[string]" )
{
    REQUIRE( String::trim_leading( "" ) == "" );
}

TEST_CASE( "trim leading with no whitespace", "[string]" )
{
    REQUIRE( String::trim_leading( "CorvusoftSolutions" ) == "CorvusoftSolutions" );
}

TEST_CASE( "trim lagging", "[string]" )
{
    REQUIRE( String::trim_lagging( "\n\r\t  Corvusoft Solutions\t\n\r " ) == "\n\r\t  Corvusoft Solutions" );
}

TEST_CASE( "trim lagging with empty", "[string]" )
{
    REQUIRE( String::trim_lagging( "" ) == "" );
}

TEST_CASE( "trim lagging with no whitespace", "[string]" )
{
    REQUIRE( String::trim_lagging( "CorvusoftSolutions" ) == "CorvusoftSolutions" );
}
