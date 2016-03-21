/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_ERROR_HANDLER_IMPL_H
#define _RESTQ_DETAIL_ERROR_HANDLER_IMPL_H 1

//System Includes
#include <string>
#include <memory>
#include <stdexcept>

//Project Includes

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    namespace detail
    {
        class ErrorHandlerImpl
        {
            public:
                //Friends
                
                //Definitions
                
                //Constructors
                
                //Functionality
                static void method_not_allowed( const std::shared_ptr< Session > session );
                
                static void method_not_implemented( const std::shared_ptr< Session > session );
                
                static void conflict( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void not_found( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void bad_request( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void not_acceptable( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void length_required( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void expectation_failed( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void service_unavailable( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void unsupported_media_type( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void request_entity_too_large( const std::string& message, const std::shared_ptr< Session >& session );
                
                static void internal_server_error( const int status, const std::exception& error, const std::shared_ptr< Session > session );
                
                static void find_and_invoke_for( const int status, const std::string& message, const std::shared_ptr< Session >& session );
                
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
                ErrorHandlerImpl( void ) = delete;
                
                ErrorHandlerImpl( const ErrorHandlerImpl& original ) = delete;
                
                virtual ~ErrorHandlerImpl( void ) = delete;
                
                //Functionality
                
                //Getters
                
                //Setters
                
                //Operators
                ErrorHandlerImpl& operator =( const ErrorHandlerImpl& value ) = delete;
                
                //Properties
        };
    }
}

#endif  /* _RESTQ_DETAIL_ERROR_HANDLER_IMPL_H */
