/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_SSL_SETTINGS_H
#define _RESTQ_SSL_SETTINGS_H 1

//System Includes

//Project Includes

//External Includes
#include <corvusoft/restbed/ssl_settings.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class SSLSettings : public restbed::SSLSettings
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            SSLSettings( void ) = default;
            
            virtual ~SSLSettings( void ) = default;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            
            //Properties
            
        protected:
            //Friends
            
            //Definitions
            
            //Constructors
            SSLSettings( const SSLSettings& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            SSLSettings& operator =( const SSLSettings& value ) = delete;
            
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
}

#endif  /* _RESTQ_SSL_SETTINGS_H */
