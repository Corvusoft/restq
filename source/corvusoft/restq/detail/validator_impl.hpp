/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_VALIDATOR_IMPL_H
#define _RESTQ_DETAIL_VALIDATOR_IMPL_H 1

//System Includes
#include <string>
#include <utility>

//Project Includes
#include "corvusoft/restq/byte.hpp"
#include "corvusoft/restq/resource.hpp"

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    namespace detail
    {
        class ValidatorImpl
        {
            public:
                //Friends
                
                //Definitions
                
                //Constructors
                
                //Functionality
                static bool has_invalid_key( const Resource& value );
                
                static bool has_reserved_create_fields( const Resource& value );
                
                static bool has_reserved_update_fields( const Resource& value );
                
                static bool has_invalid_create_fields( const Resource& value, const Bytes& type );
                
                static bool has_invalid_update_fields( const Resource& value, const Bytes& type );
                
                static bool is_valid_forwarding_header( const std::pair< const std::string, const std::string >& header );
                
                //Getters
                
                //Setters
                
                //Operators
                
                //Properties
                static const std::string key_pattern;
                
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
                ValidatorImpl( void ) = delete;
                
                ValidatorImpl( const ValidatorImpl& original ) = delete;
                
                virtual ~ValidatorImpl( void ) = delete;
                
                //Functionality
                
                //Getters
                
                //Setters
                
                //Operators
                ValidatorImpl& operator =( const ValidatorImpl& value ) = delete;
                
                //Properties
        };
    }
}

#endif  /* _RESTQ_DETAIL_VALIDATOR_IMPL_H */
