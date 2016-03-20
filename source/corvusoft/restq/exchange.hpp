/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_EXCHANGE_H
#define _RESTQ_EXCHANGE_H 1

//System Includes
#include <memory>
#include <string>
#include <functional>

//Project Includes
#include <corvusoft/restq/logger.hpp>
#include <corvusoft/restq/settings.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    class Formatter;
    class Repository;
    
    namespace detail
    {
        class ExchangeImpl;
    }
    
    class Exchange
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            Exchange( void );
            
            virtual ~Exchange( void );
            
            //Functionality
            void stop( void );
            
            void start( const std::shared_ptr< const Settings >& settings = nullptr );
            
            void restart( const std::shared_ptr< const Settings >& settings = nullptr );
            
            void add_format( const std::string& mime_pattern, const std::shared_ptr< Formatter >& value );
            
            //Getters
            
            //Setters
            void set_logger( const std::shared_ptr< Logger >& value );
            
            void set_repository( const std::shared_ptr< Repository >& value );
            
            void set_ready_handler( const std::function< void ( Exchange& ) >& value );
            
            void set_signal_handler( const int signal, const std::function< void ( const int ) >& value );
            
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
            
            //Properties
            
        private:
            //Friends
            
            //Definitions
            
            //Constructors
            Exchange( const Exchange& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Exchange& operator =( const Exchange& value ) = delete;
            
            //Properties
            detail::ExchangeImpl* m_pimpl;
    };
}

#endif  /* _RESTQ_EXCHANGE_H */
