/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <memory>
#include <string>
#include <stdexcept>

//Project Includes
#include <corvusoft/restq/exchange.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::string;
using std::shared_ptr;
using std::make_shared;
using std::invalid_argument;

//Project Namespaces
using restq::Exchange;

//External Namespaces

TEST_CASE( "validate no exceptions raised when setting a null logger", "[exchange]" )
{
    auto exchange = make_shared< Exchange >( );
    
    REQUIRE_NOTHROW( exchange->set_logger( nullptr ) );
}

TEST_CASE( "validate an exception is raised when setting a null repository", "[exchange]" )
{
    auto exchange = make_shared< Exchange >( );
    
    REQUIRE_THROWS_AS( exchange->set_repository( nullptr ), invalid_argument );
}

TEST_CASE( "validate no exceptions raised when setting a null ready handler", "[exchange]" )
{
    auto exchange = make_shared< Exchange >( );
    
    REQUIRE_NOTHROW( exchange->set_ready_handler( nullptr ) );
}

TEST_CASE( "validate an exception is raised when setting a null encoder", "[exchange]" )
{
    auto exchange = make_shared< Exchange >( );
    
    REQUIRE_THROWS_AS( exchange->add_format( "*", nullptr ), invalid_argument );
}
