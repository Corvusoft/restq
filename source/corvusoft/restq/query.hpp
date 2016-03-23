/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_QUERY_H
#define _RESTQ_QUERY_H 1

//System Includes
#include <map>
#include <memory>
#include <string>
#include <vector>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/session.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    namespace detail
    {
        struct QueryImpl;
    }
    
    class Query
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            Query( void );
            
            virtual ~Query( void );
            
            //Functionality
            
            //Getters
            Bytes get_include( void ) const;
            
            std::size_t get_index( void ) const;
            
            std::size_t get_limit( void ) const;
            
            std::vector< std::string > get_keys( void ) const;
            
            std::shared_ptr< Session > get_session( void ) const;
            
            std::multimap< std::string, Bytes > get_inclusive_filters( void ) const;
            
            std::multimap< std::string, Bytes > get_exclusive_filters( void ) const;
            
            //Setters
            void set_index( const std::size_t start );
            
            void set_limit( const std::size_t stop );
            
            void set_include( const Bytes& relationship );
            
            void set_keys( const std::vector< std::string >& values );
            
            void set_session( const std::shared_ptr< Session >& value );
            
            void set_inclusive_filters( const std::multimap< std::string, Bytes >& values );
            
            void set_exclusive_filters( const std::multimap< std::string, Bytes >& values );
            
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
            Query( const Query& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Query& operator =( const Query& value ) = delete;
            
            //Properties
            detail::QueryImpl* m_pimpl;
    };
}

#endif  /* _RESTQ_QUERY_H */
