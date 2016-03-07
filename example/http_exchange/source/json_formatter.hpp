/*
 * Copyright 2013-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQD_JSON_FORMATTER_H
#define _RESTQD_JSON_FORMATTER_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>

//Project Includes

//External Includes
#include <json.hpp>
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/formatter.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restqd
{
    //Forward Declarations
    
    class JSONFormatter final : public restq::Formatter
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            JSONFormatter( void );
            
            virtual ~JSONFormatter( void );
            
            //Functionality
            std::list< std::multimap< std::string, restq::Bytes > > parse( const restq::Bytes& value );
            
            bool try_parse( const restq::Bytes& value, std::list< std::multimap< std::string, restq::Bytes > >& values ) noexcept;
            
            restq::Bytes compose( const std::list< std::multimap< std::string, restq::Bytes > >& values, const bool styled = false );
            
            //Getters
            const std::string get_mime_type( void ) const;
            
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
            JSONFormatter( const JSONFormatter& original ) = delete;
            
            //Functionality
            std::string to_string( const nlohmann::json& value ) const;
            
            restq::Bytes to_bytes( const nlohmann::json& json, bool styled ) const;
            
            nlohmann::json compose_object( const std::multimap< std::string, restq::Bytes >& value ) const;
            
            std::multimap< std::string, restq::Bytes > parse_object( const nlohmann::json& value ) const;
            
            //Getters
            
            //Setters
            
            //Operators
            JSONFormatter& operator =( const JSONFormatter& value ) = delete;
            
            //Properties
    };
}

#endif  /* _RESTQD_JSON_FORMATTER_H */
