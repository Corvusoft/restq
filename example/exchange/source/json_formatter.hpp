/*
 * Copyright 2013-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _JSON_FORMATTER_H
#define _JSON_FORMATTER_H 1

//System Includes
#include <string>
#include <memory>

//Project Includes

//External Includes
#include <json.hpp>
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/resource.hpp>
#include <corvusoft/restq/formatter.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

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
        restq::Resources parse( const restq::Bytes& value );
        
        bool try_parse( const restq::Bytes& value, restq::Resources& values ) noexcept;
        
        restq::Bytes compose( const restq::Resources& values, const bool styled = false );
        
        //Getters
        const std::string get_mime_type( void ) const;
        
        //Setters
        void set_logger( const std::shared_ptr< restq::Logger >& value );
        
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
        
        nlohmann::json compose_object( const restq::Resource& value ) const;
        
        restq::Resource parse_object( const nlohmann::json& value ) const;
        
        //Getters
        
        //Setters
        
        //Operators
        JSONFormatter& operator =( const JSONFormatter& value ) = delete;
        
        //Properties
};

#endif  /* _JSON_FORMATTER_H */
