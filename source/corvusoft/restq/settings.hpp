/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_SETTINGS_H
#define _RESTQ_SETTINGS_H 1

//System Includes
#include <map>
#include <chrono>
#include <string>
#include <cstddef>

//Project Includes

//External Includes
#include <corvusoft/restbed/settings.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class Settings : public restbed::Settings
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            Settings( void );
            
            virtual ~Settings( void );
            
            //Functionality
            
            //Getters
            std::size_t get_default_queue_message_limit( void ) const;
            
            std::size_t get_default_queue_message_size_limit( void ) const;
            
            std::size_t get_default_queue_subscription_limit( void ) const;
            
            std::size_t get_default_queue_max_delivery_attempts( void ) const;
            
            std::chrono::seconds get_default_queue_redelivery_interval( void ) const;
            
            //Setters
            void set_default_queue_message_limit( const std::size_t value );
            
            void set_default_queue_message_size_limit( const std::size_t value );
            
            void set_default_queue_subscription_limit( const std::size_t value );
            
            void set_default_queue_max_delivery_attempts( const std::size_t value );
            
            void set_default_queue_redelivery_interval( const std::chrono::seconds value );
            
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
            Settings( const Settings& original ) = delete;
            
            //Functionality
            
            //Getters
            bool get_case_insensitive_uris( void ) const = delete;
            
            std::string get_property( const std::string& name ) const = delete;
            
            std::map< std::string, std::string > get_properties( void ) const = delete;
            
            std::string get_status_message( const int code ) const = delete;
            
            std::map< int, std::string > get_status_messages( void ) const = delete;
            
            std::multimap< std::string, std::string > get_default_headers( void ) const = delete;
            
            //Setters
            void set_case_insensitive_uris( const bool value ) = delete;
            
            void set_property( const std::string& name, const std::string& value ) = delete;
            
            void set_properties( const std::map< std::string, std::string >& values ) = delete;
            
            void set_status_message( const int code, const std::string& message ) = delete;
            
            void set_status_messages( const std::map< int, std::string >& values ) = delete;
            
            void set_default_header( const std::string& name, const std::string& value ) = delete;
            
            void set_default_headers( const std::multimap< std::string, std::string >& values ) = delete;
            
            //Operators
            Settings& operator =( const Settings& value ) = delete;
            
            //Properties
    };
}

#endif  /* _RESTQ_SETTINGS_H */
