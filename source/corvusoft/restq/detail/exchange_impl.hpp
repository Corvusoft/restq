/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_EXCHANGE_IMPL_H
#define _RESTQ_DETAIL_EXCHANGE_IMPL_H 1

//System Includes
#include <map>
#include <ctime>
#include <string>
#include <memory>
#include <utility>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/logger.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/resource.hpp>
#include <corvusoft/restq/settings.hpp>

//External Includes
#include <corvusoft/loadis/system.hpp>
#include <corvusoft/restbed/rule.hpp>
#include <corvusoft/restbed/service.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    class Query;
    class Exchange;
    class Formatter;
    class Repository;
    
    namespace detail
    {
        //Forward Declarations
        
        class ExchangeImpl
        {
            public:
                //Friends
                
                //Definitions
                
                //Constructors
                ExchangeImpl( void );
                
                virtual ~ExchangeImpl( void );
                
                //Functionality
                void start( void );
                
                void log( const Logger::Level level, const std::string& message ) const;
                
                //Getters
                
                //Setters
                
                //Operators
                
                //Properties
                std::time_t m_boot_time;
                
                std::shared_ptr< Logger > m_logger;
                
                std::shared_ptr< loadis::System > m_system;
                
                std::shared_ptr< Repository > m_repository;
                
                std::shared_ptr< const Settings > m_settings;
                
                std::shared_ptr< restbed::Service > m_service;
                
                std::function< void ( void ) > m_ready_handler;
                
                std::shared_ptr< restbed::Rule > m_key_rule;
                
                std::shared_ptr< restbed::Rule > m_keys_rule;
                
                std::shared_ptr< restbed::Rule > m_content_type_rule;
                
                std::shared_ptr< restbed::Rule > m_content_encoding_rule;
                
                std::map< std::string, std::shared_ptr< Formatter > > m_formats;
                
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
                ExchangeImpl( const ExchangeImpl& original ) = delete;
                
                //Functionality
                bool is_valid( const std::pair< const std::string, const std::string >& header ) const;
                
                bool is_invalid( Resource& values, const Bytes& type ) const; //is_invalid_create
                
                bool is_update_invalid( Resource& values, const Bytes& type ) const;
                
                void initialise_default_values( Resource& value, const Bytes& type ) const;
                
                void remove_reserved_words( Resource& value ) const;
                
                void remove_reserved_words( Resources& values ) const;
                
                Resource make_message( const std::shared_ptr< Session >& session ) const;
                
                void setup_ruleset( void );
                
                void setup_queue_resource( void );
                
                void setup_queues_resource( void );
                
                void setup_message_resource( void );
                
                void setup_messages_resource( void );
                
                void setup_asterisk_resource( void );
                
                void setup_subscription_resource( void );
                
                void setup_subscriptions_resource( void );
                
                void dispatch( void );
                
                void create_message_handler( const std::shared_ptr< Session > session );
                
                void create_resource_handler( const std::shared_ptr< Session > session, const Bytes& type );
                
                void read_resource_handler( const std::shared_ptr< Session > session, const Bytes& type );
                
                void update_resource_handler( const std::shared_ptr< Session > session, const Bytes& type );
                
                void delete_resource_handler( const std::shared_ptr< Session > session, const Bytes& type );
                
                void asterisk_resource_handler( const std::shared_ptr< Session > session );
                
                void options_resource_handler( const std::shared_ptr< Session > session, const Bytes& type, const std::string& options );
                
                void create_resource_callback( const int status, const Resources resources, const std::shared_ptr< Query > query );
                
                void read_resource_callback( const int status, const Resources resources, const std::shared_ptr< Query > query );
                
                void update_resource_callback( const int status, const Resources resources, const std::shared_ptr< Query > query );
                
                void create_message_callback( const int status, const Resources messages, const std::shared_ptr< Query > query, const Resources states );
                
                void create_message_and_read_queues_callback( const int status, const Resources queues, const std::shared_ptr< Query > query );
                
                void create_message_and_read_subscriptions_callback( const int status, const Resources subscriptions, const std::shared_ptr< Query > query, const Resources queues );
                
                //Getters
                
                //Setters
                
                //Operators
                ExchangeImpl& operator =( const ExchangeImpl& value ) = delete;
                
                //Properties
        };
    }
}

#endif  /* _RESTQ_DETAIL_EXCHANGE_IMPL_H */
