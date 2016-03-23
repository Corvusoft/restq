/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes

//Project Includes
#include <corvusoft/restq/query.hpp>

//External Includes
#include <catch.hpp>

//System Namespaces

//Project Namespaces
using restq::Query;

//External Namespaces

TEST_CASE( "confirm default constructor throws no exceptions", "[query]" )
{
    REQUIRE_NOTHROW( new Query );
}

TEST_CASE( "confirm default destructor throws no exceptions", "[query]" )
{
    auto query = new Query;
    
    REQUIRE_NOTHROW( delete query );
}
