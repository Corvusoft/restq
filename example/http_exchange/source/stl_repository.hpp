/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _STL_REPOSITORY_H
#define _STL_REPOSITORY_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <vector>
#include <utility>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/settings.hpp>
#include <corvusoft/restq/repository.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

class STLRepository final : public restq::Repository
{
    public:
        //Friends
        
        //Definitions
        
        //Constructors
        STLRepository( void );
        
        virtual ~STLRepository( void );
        
        //Functionality
        void stop( void );
        
        void start( const std::shared_ptr< const restq::Settings >& settings );
        
        std::size_t count( const std::multimap< std::string, restq::Bytes >& filters );
        
        int create( const std::list< std::multimap< std::string, restq::Bytes > >& values );
        
        int read( const std::vector< std::string >& keys,
                  const std::pair< std::size_t, std::size_t >& range,
                  const std::multimap< std::string, restq::Bytes >& filters,
                  std::list< std::multimap< std::string, restq::Bytes > >& values );
                  
        int update( const std::vector< std::string >& keys,
                    const std::pair< std::size_t, std::size_t >& range,
                    const std::multimap< std::string, restq::Bytes >& filters,
                    const std::multimap< std::string, restq::Bytes >& changeset,
                    std::list< std::multimap< std::string, restq::Bytes > >& values );
                    
        int destroy( const std::vector< std::string >& keys, const std::multimap< std::string, restq::Bytes >& filters );
        
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
        STLRepository( const STLRepository& original ) = delete;
        
        //Functionality
        
        //Getters
        
        //Setters
        
        //Operators
        STLRepository& operator =( const STLRepository& value ) = delete;
        
        //Properties
        std::list< std::multimap< std::string, restq::Bytes > > m_resources;
};

#endif  /* _STL_REPOSITORY_H */
