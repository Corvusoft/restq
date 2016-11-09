/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_DISPATCH_IMPL_H
#define _RESTQ_DETAIL_DISPATCH_IMPL_H 1

//System Includes
#include <memory>
#include <cstddef>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/logger.hpp>

//External Includes
#include <corvusoft/restbed/service.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    class Repository;
    
    namespace detail
    {
        //Forward Declarations
        
        class DispatchImpl
        {
            public:
                //Friends
                
                //Definitions
                static const Bytes PENDING;
                
                static const Bytes REJECTED;
                
                static const Bytes INFLIGHT;
                
                static const Bytes SUSPENDED;
                
                static const Bytes DISPATCHED;
                
                static const Bytes UNREACHABLE;
                
                //Constructors
                
                //Functionality
                static void route( const Bytes state );
                
                //Getters
                
                //Setters
                static void set_logger( const std::shared_ptr< Logger >& value );
                
                static void set_repository( const std::shared_ptr< Repository >& value );
                
                static void set_service( const std::shared_ptr< restbed::Service >& value );
                
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
                DispatchImpl( void ) = delete;
                
                virtual ~DispatchImpl( void ) = delete;
                
                DispatchImpl( const DispatchImpl& original ) = delete;
                
                //Functionality
                static void router( const std::shared_ptr< Query > query );
                
                static void log( const Logger::Level level, const std::string& message );
                
                //Getters
                
                //Setters
                
                //Operators
                DispatchImpl& operator =( const DispatchImpl& value ) = delete;
                
                //Properties
                static std::shared_ptr< Logger > m_logger;
                
                static std::shared_ptr< Repository > m_repository;
                
                static std::shared_ptr< restbed::Service > m_service;
        };
    }
}

#endif  /* _RESTQ_DETAIL_DISPATCH_IMPL_H */
