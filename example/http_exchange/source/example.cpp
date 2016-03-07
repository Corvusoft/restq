/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <memory>
#include <cstdlib>

//Project Includes
#include "stdout_logger.hpp"
#include "json_formatter.hpp"
#include "stl_repository.hpp"

//External Includes
#include <corvusoft/restq/settings.hpp>
#include <corvusoft/restq/exchange.hpp>

//System Namespaces
using std::shared_ptr;
using std::make_shared;

//Project Namespaces
using STDOUTLogger;
using JSONFormatter;
using STLRepository;

//External Namespaces
using restq::Settings;
using restq::Exchange;

int main( const int, const char** )
{
    auto logger = make_shared< STDOUTLogger >( );
    auto format = make_shared< JSONFormatter >( );
    auto repository = make_shared< STLRepository >( );
    
    auto exchange = make_shared< Exchange >( );
    exchange->set_logger( logger );
    exchange->set_repository( repository );
    exchange->add_format( "^application/json|application/\\*|\\*/\\*$", format );
    exchange->set_ready_handler( [ &logger ]( Exchange& )
    {
        logger->log( "Corvusoft's RestQ awaiting messages..." );
    } );
    
    auto settings = make_shared< Settings >( );
    settings->set_port( 1984 );
    
    exchange->start( settings );
    
    return EXIT_SUCCESS;
}
