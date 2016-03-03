/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_REPOSITORY_H
#define _RESTQ_REPOSITORY_H 1

//System Includes
#include <map>
#include <list>
#include <vector>
#include <string>
#include <memory>
#include <utility>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/byte.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    class Settings;
    
    class Repository
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            
            //Functionality
            virtual void stop( void ) = 0;
            
            virtual void start( const std::shared_ptr< const Settings >& settings ) = 0;
            
            virtual std::size_t count( const std::multimap< std::string, Bytes >& filters ) = 0;
            
            virtual int create( const std::list< std::multimap< std::string, Bytes > >& values ) = 0;
            
            virtual int read( const std::vector< std::string >& keys,
                              const std::pair< std::size_t, std::size_t >& range,
                              const std::multimap< std::string, Bytes >& filters,
                              std::list< std::multimap< std::string, Bytes > >& values ) = 0;
                              
            virtual int update( const std::vector< std::string >& keys,
                                const std::pair< std::size_t, std::size_t >& range,
                                const std::multimap< std::string, Bytes >& filters,
                                const std::multimap< std::string, Bytes >& changeset,
                                std::list< std::multimap< std::string, Bytes > >& values ) = 0;
                                
            virtual int destroy( const std::vector< std::string >& keys, const std::multimap< std::string, Bytes >& filters ) = 0;
            
            //Getters
            
            //Setters
            
            //Operators
            
            //Properties
            
        protected:
            //Friends
            
            //Definitions
            
            //Constructors
            Repository( void ) = default;
            
            virtual ~Repository( void ) = default;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            
            //Properties
            
        private:
            //Friends
            
            //Definitions
            
            //Constructors
            Repository( const Repository& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Repository& operator =( const Repository& value ) = delete;
            
            //Properties
    };
}

#endif  /* _RESTQ_REPOSITORY_H */
