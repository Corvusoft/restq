/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _STDOUT_LOGGER_H
#define _STDOUT_LOGGER_H 1

//System Includes
#include <memory>

//Project Includes

//External Includes
#include <corvusoft/restq/logger.hpp>
#include <corvusoft/restq/settings.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

class STDOUTLogger : public restq::Logger
{
    public:
        //Friends
        
        //Definitions
        
        //Constructors
        STDOUTLogger( void ) = default;
        
        explicit STDOUTLogger( const STDOUTLogger& original ) = default;
        
        virtual ~STDOUTLogger( void ) = default;
        
        //Functionality
        void stop( void );
        
        void start( const std::shared_ptr< const restq::Settings >& settings );
        
        void log( const Level level, const char* format, ... );
        
        void log_if( bool expression, const Level level, const char* format, ... );
        
        //Getters
        
        //Setters
        
        //Operators
        
        //Properties
        
    protected:
        //Friends
        
        //Definitions
        
        //Constructors
        
        //Functionality
        
        //Getters
        
        //Setters
        
        //Operators
        STDOUTLogger& operator =( const STDOUTLogger& value ) = default;
        
        //Properties
        
    private:
        //Friends
        
        //Definitions
        
        //Constructors
        
        //Functionality
        
        //Getters
        
        //Setters
        
        //Operators
        
        //Properties
};

#endif  /* _STDOUT_LOGGER_H */
