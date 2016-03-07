/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <stdexcept>

//Project Includes
#include <corvusoft/restq/exchange.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::runtime_error;

//Project Namespaces
using restq::Exchange;

//External Namespaces

TEST_CASE( "confirm default constructor throws no exceptions", "[exchange]" )
{
    REQUIRE_NOTHROW( new Exchange );
}

TEST_CASE( "confirm default destructor throws no exceptions", "[exchange]" )
{
    auto exchange = new Exchange;
    
    REQUIRE_NOTHROW( delete exchange );
}

TEST_CASE( "confirm calling stop before start throws no exceptions", "[exchange]" )
{
    Exchange exchange;
    
    REQUIRE_NOTHROW( exchange.stop( ) );
}

TEST_CASE( "confirm starting the exchange without a repository raises an exception.", "[exchange]" )
{
    Exchange exchange;
    
    REQUIRE_THROWS_AS( exchange.start( ), runtime_error );
}
