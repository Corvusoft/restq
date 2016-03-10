/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _STL_REPOSITORY_H
#define _STL_REPOSITORY_H 1

//System Includes
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/resource.hpp>
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
        
        void create( const restq::Resources values,
                     const std::shared_ptr< restq::Session > session,
                     const std::function< void ( const int, const restq::Resources, const std::shared_ptr< restq::Session > ) >& callback );
                     
        void read( const std::shared_ptr< restq::Session > session,
                   const std::function< void ( const int, const restq::Resources, const std::shared_ptr< restq::Session > ) >& callback );
                   
        void update( const restq::Resource changeset,
                     const std::shared_ptr< restq::Session > session,
                     const std::function< void (  const int, const restq::Resources, const std::shared_ptr< restq::Session > ) >& callback );
                     
        void destroy( const std::shared_ptr< restq::Session > session, const std::function< void ( const int, const std::shared_ptr< restq::Session > ) >& callback );
        
        //Getters
        
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
        STLRepository( const STLRepository& original ) = delete;
        
        //Functionality
        
        //Getters
        
        //Setters
        
        //Operators
        STLRepository& operator =( const STLRepository& value ) = delete;
        
        //Properties
        restq::Resources m_resources;
};

#endif  /* _STL_REPOSITORY_H */
