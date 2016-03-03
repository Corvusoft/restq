/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_URI_H
#define _RESTQ_URI_H 1

//System Includes
#include <string>

//Project Includes

//External Includes
#include <corvusoft/restbed/uri.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class Uri : public restbed::Uri
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            explicit Uri( const std::string& value, bool relative = false ) : restbed::Uri( value, relative )
            {
                return;
            };
            
            Uri( const Uri& original ) : restbed::Uri( original )
            {
                return;
            };
            
            virtual ~Uri( void ) = default;
            
            //Functionality
            
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
            Uri( void ) = default;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Uri& operator =( const Uri& value ) = default;
            
            //Properties
    };
}

#endif  /* _RESTQ_URI_H */
