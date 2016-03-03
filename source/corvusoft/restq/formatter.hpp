/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_FORMATTER_H
#define _RESTQ_FORMATTER_H 1

//System Includes
#include <map>
#include <list>
#include <string>

//Project Includes
#include <corvusoft/restq/byte.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class Formatter
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            
            //Functionality
            virtual std::list< std::multimap< std::string, Bytes > > parse( const Bytes& value ) = 0;
            
            virtual bool try_parse( const Bytes& value, std::list< std::multimap< std::string, Bytes > >& values ) noexcept = 0;
            
            virtual Bytes compose( const std::list< std::multimap< std::string, Bytes > >& values, const bool styled = false ) = 0;
            
            //Getters
            virtual const std::string get_mime_type( void ) const = 0;
            
            //Setters
            
            //Operators
            
            //Properties
            
        protected:
            //Friends
            
            //Definitions
            
            //Constructors
            Formatter( void ) = default;
            
            virtual ~Formatter( void ) = default;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            
            //Properties
            
        private:
            //Friends
            
            //Definitions
            
            //Constructors
            Formatter( const Formatter& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Formatter& operator =( const Formatter& value ) = delete;
            
            //Properties
    };
}

#endif  /* _RESTQ_FORMATTER_H */
