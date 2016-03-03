/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_STRING_H
#define _RESTQ_STRING_H 1

//System Includes
#include <string>

//Project Includes

//External Includes
#include <corvusoft/restbed/string.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class String : public restbed::String
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            
            //Functionality
            static bool is_integer( const std::string& value );
            
            static bool is_boolean( const std::string& value );
            
            static bool is_fraction( const std::string& value );
            
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
            
            //Properties
            
        private:
            //Friends
            
            //Definitions
            
            //Constructors
            String( void ) = delete;
            
            String( const String& original ) = delete;
            
            virtual ~String( void ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            String& operator =( const String& value ) = delete;
            
            //Properties
    };
}

#endif  /* _RESTQ_STRING_H */
