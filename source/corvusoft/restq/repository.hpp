/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_REPOSITORY_H
#define _RESTQ_REPOSITORY_H 1

//System Includes
#include <map>
#include <list>
#include <string>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/query.hpp>
#include <corvusoft/restq/logger.hpp>
#include <corvusoft/restq/settings.hpp>
#include <corvusoft/restq/resource.hpp>

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    class Repository
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            
            //Functionality
            virtual void stop( void ) = 0;
            
            virtual void start( const std::shared_ptr< const Settings >& settings ) = 0;
            
            virtual void create( const Resources values,
                                 const std::shared_ptr< Query > query,
                                 const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
                                 
            virtual void read( const std::shared_ptr< Query > query,
                               const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
                               
            virtual void update( const Resource changeset,
                                 const std::shared_ptr< Query > query,
                                 const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
                                 
            virtual void destroy( const std::shared_ptr< Query > query,
                                  const std::function< void ( const std::shared_ptr< Query > ) >& callback = nullptr ) = 0;
                                  
            //Getters
            
            //Setters
            virtual void set_logger( const std::shared_ptr< Logger >& value ) = 0;
            
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
