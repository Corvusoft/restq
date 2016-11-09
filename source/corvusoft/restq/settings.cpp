/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes

//Project Includes
#include "corvusoft/restq/settings.hpp"

//External Includes

//System Namespaces
using std::stoul;
using std::size_t;
using std::string;
using std::to_string;
using std::chrono::seconds;

//Project Namespaces
using restbed::Settings;

//External Namespaces

namespace restq
{
    Settings::Settings( void ) : restbed::Settings( )
    {
        return;
    }
    
    Settings::~Settings( void )
    {
        return;
    }
    
    size_t Settings::get_default_queue_message_limit( void ) const
    {
        const auto value = restbed::Settings::get_property( "queue-message-limit" );
        
        return ( value.empty( ) ) ? 100 : stoul( value );
    }
    
    size_t Settings::get_default_queue_message_size_limit( void ) const
    {
        const auto value = restbed::Settings::get_property( "queue-message-size-limit" );
        
        return ( value.empty( ) ) ? 1024 : stoul( value );
    }
    
    size_t Settings::get_default_queue_subscription_limit( void ) const
    {
        const auto value = restbed::Settings::get_property( "queue-subscription-limit" );
        
        return ( value.empty( ) ) ? 25 : stoul( value );
    }
    
    size_t Settings::get_default_queue_max_delivery_attempts( void ) const
    {
        const auto value = restbed::Settings::get_property( "max-delivery-attempts" );
        
        return ( value.empty( ) ) ? 3 : stoul( value );
    }
    
    seconds Settings::get_default_queue_redelivery_interval( void ) const
    {
        const auto value = restbed::Settings::get_property( "redelivery-interval" );
        
        return ( value.empty( ) ) ? seconds( 30 ) : seconds( stol( value ) );
    }
    
    void Settings::set_default_queue_message_limit( const size_t value )
    {
        restbed::Settings::set_property( "queue-message-limit", ::to_string( value ) );
    }
    
    void Settings::set_default_queue_message_size_limit( const size_t value )
    {
        restbed::Settings::set_property( "queue-message-size-limit", ::to_string( value ) );
    }
    
    void Settings::set_default_queue_subscription_limit( const size_t value )
    {
        restbed::Settings::set_property( "queue-subscription-limit", ::to_string( value ) );
    }
    
    void Settings::set_default_queue_max_delivery_attempts( const size_t value )
    {
        restbed::Settings::set_property( "max-delivery-attempts", ::to_string( value ) );
    }
    
    void Settings::set_default_queue_redelivery_interval( const seconds value )
    {
        restbed::Settings::set_property( "redelivery-interval", ::to_string( value.count( ) ) );
    }
}
