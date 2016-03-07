/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <string>
#include <cstdio>
#include <cstdarg>

//Project Includes
#include "stdout_logger.hpp"

//External Includes

//System Namespaces
using std::string;
using std::shared_ptr;

//Project Namespaces

//External Namespaces
using restq::Settings;

void STDOUTLogger::stop( void )
{
    return;
}

void STDOUTLogger::start( const shared_ptr< const Settings >& )
{
    return;
}

void STDOUTLogger::log( const Level, const char* format, ... )
{
    va_list arguments;
    va_start( arguments, format );
    
    vfprintf( stderr, format, arguments );
    fprintf( stderr, "\n" );
    
    va_end( arguments );
}

void STDOUTLogger::log_if( bool expression, const Level level, const char* format, ... )
{
    if ( expression )
    {
        va_list arguments;
        va_start( arguments, format );
        log( level, format, arguments );
        va_end( arguments );
    }
}
