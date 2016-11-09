/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <string>
#include <chrono>

//Project Includes
#include <corvusoft/restq/settings.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces
using std::string;
using std::chrono::seconds;
using std::chrono::milliseconds;

//Project Namespaces
using restq::Settings;

//External Namespaces

TEST_CASE( "validate default instance values", "[settings]" )
{
    const Settings settings;
    
    REQUIRE( settings.get_port( ) == 80 );
    REQUIRE( settings.get_root( ) == "/" );
    REQUIRE( settings.get_worker_limit( ) == 0 );
    REQUIRE( settings.get_bind_address( ).empty( ) );
    REQUIRE( settings.get_connection_limit( ) == 128 );
    REQUIRE( settings.get_connection_timeout( ) == milliseconds( 5000 ) );
    REQUIRE( settings.get_default_queue_message_limit( ) == 100 );
    REQUIRE( settings.get_default_queue_message_size_limit( ) == 1024 );
    REQUIRE( settings.get_default_queue_subscription_limit( ) == 25 );
    REQUIRE( settings.get_default_queue_max_delivery_attempts( ) == 3 );
    REQUIRE( settings.get_default_queue_redelivery_interval( ) == seconds( 30 ) );
}

TEST_CASE( "confirm default destructor throws no exceptions", "[settings]" )
{
    auto settings = new Settings;
    
    REQUIRE_NOTHROW( delete settings );
}

TEST_CASE( "validate setters modify default values", "[settings]" )
{
    Settings settings;
    settings.set_port( 1984 );
    settings.set_worker_limit( 4 );
    settings.set_root( "/resources" );
    settings.set_connection_limit( 1 );
    settings.set_bind_address( "::1" );
    settings.set_connection_timeout( milliseconds( 30 ) );
    settings.set_default_queue_message_limit( 1001 );
    settings.set_default_queue_message_size_limit( 19 );
    settings.set_default_queue_subscription_limit( 2 );
    settings.set_default_queue_max_delivery_attempts( 20 );
    settings.set_default_queue_redelivery_interval( seconds( 5 ) );
    
    REQUIRE( settings.get_port( ) == 1984 );
    REQUIRE( settings.get_root( ) == "/resources" );
    REQUIRE( settings.get_worker_limit( ) == 4 );
    REQUIRE( settings.get_bind_address( ) == "::1" );
    REQUIRE( settings.get_connection_limit( ) == 1 );
    REQUIRE( settings.get_connection_timeout( ) == milliseconds( 30 ) );
    REQUIRE( settings.get_default_queue_message_limit( ) == 1001 );
    REQUIRE( settings.get_default_queue_message_size_limit( ) == 19 );
    REQUIRE( settings.get_default_queue_subscription_limit( ) == 2 );
    REQUIRE( settings.get_default_queue_max_delivery_attempts( ) == 20 );
    REQUIRE( settings.get_default_queue_redelivery_interval( ) == seconds( 5 ) );
}
