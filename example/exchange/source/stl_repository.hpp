/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _STL_REPOSITORY_H
#define _STL_REPOSITORY_H 1

//System Includes
#include <map>
#include <mutex>
#include <memory>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/query.hpp>
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
                     const std::shared_ptr< restq::Query > query,
                     const std::function< void ( const std::shared_ptr< restq::Query > ) >& callback );
                     
        void read( const std::shared_ptr< restq::Query > query, const std::function< void ( const std::shared_ptr< restq::Query > ) >& callback );
        
        void update( const restq::Resource changeset,
                     const std::shared_ptr< restq::Query > query,
                     const std::function< void ( const std::shared_ptr< restq::Query > ) >& callback );
                     
        void destroy( const std::shared_ptr< restq::Query > query, const std::function< void ( const std::shared_ptr< restq::Query > ) >& callback = nullptr );
        
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
        void include( const restq::Bytes& relationship, restq::Resources& values );
        
        restq::Resources fields( const restq::Resources& values, const std::shared_ptr< restq::Query >& query );
        
        void filter( restq::Resources& resources, const std::multimap< std::string, restq::Bytes >& inclusive_filters, const std::multimap< std::string, restq::Bytes >& exclusive_filters ) const;
        
        //Getters
        
        //Setters
        
        //Operators
        STLRepository& operator =( const STLRepository& value ) = delete;
        
        //Properties
        std::mutex m_resources_lock;
        
        restq::Resources m_resources;
};

#endif  /* _STL_REPOSITORY_H */
