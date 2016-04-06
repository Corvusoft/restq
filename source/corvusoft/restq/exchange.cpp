/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <chrono>
#include <ciso646>
#include <utility>
#include <stdexcept>

//Project Includes
#include "corvusoft/restq/uri.hpp"
#include "corvusoft/restq/logger.hpp"
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/exchange.hpp"
#include "corvusoft/restq/settings.hpp"
#include "corvusoft/restq/formatter.hpp"
#include "corvusoft/restq/repository.hpp"
#include "corvusoft/restq/detail/exchange_impl.hpp"

//External Includes

//System Namespaces
using std::pair;
using std::bind;
using std::string;
using std::function;
using std::make_pair;
using std::shared_ptr;
using std::make_shared;
using std::runtime_error;
using std::invalid_argument;
using std::chrono::system_clock;

//Project Namespaces
using restq::detail::ExchangeImpl;

//External Namespaces

namespace restq
{
    Exchange::Exchange( void ) : m_pimpl( new ExchangeImpl )
    {
        return;
    }
    
    Exchange::~Exchange( void )
    {
        try
        {
            stop( );
        }
        catch ( ... )
        {
            m_pimpl->log( Logger::Level::WARNING, "Exchange failed to gracefully wind down." );
        }
        
        delete m_pimpl;
    }
    
    void Exchange::stop( void )
    {
        m_pimpl->m_boot_time = 0;
        
        if ( m_pimpl->m_service not_eq nullptr )
        {
            m_pimpl->m_service->stop( );
        }
        
        if ( m_pimpl->m_repository not_eq nullptr )
        {
            m_pimpl->m_repository->stop( );
        }
        
        if ( m_pimpl->m_logger not_eq nullptr )
        {
            m_pimpl->log( Logger::Level::INFO, "Exchange halted." );
            m_pimpl->m_logger->stop( );
        }
    }
    
    void Exchange::start( const shared_ptr< const Settings >& settings )
    {
        if ( m_pimpl->m_repository == nullptr )
        {
            throw runtime_error( "The exchange is incapable of performing any operations until a repository is supplied." );
        }
        
        m_pimpl->m_settings = settings;
        
        if ( settings == nullptr )
        {
            m_pimpl->m_settings = make_shared< Settings >( );
        }
        
        if ( m_pimpl->m_logger not_eq nullptr )
        {
            m_pimpl->m_logger->start( m_pimpl->m_settings );
            m_pimpl->m_repository->set_logger( m_pimpl->m_logger );
            
            for ( auto formatter : m_pimpl->m_formats )
            {
                formatter.second->set_logger( m_pimpl->m_logger );
            }
        }
        
        m_pimpl->m_repository->start( m_pimpl->m_settings );
        m_pimpl->start( );
    }
    
    void Exchange::restart( const shared_ptr< const Settings >& settings )
    {
        try
        {
            stop( );
        }
        catch ( ... )
        {
            m_pimpl->log( Logger::Level::WARNING, "Exchange failed graceful reboot." );
        }
        
        start( settings );
    }
    
    void Exchange::add_format( const string& media_type, const shared_ptr< Formatter >& value )
    {
        if ( m_pimpl->m_boot_time )
        {
            throw runtime_error( "Runtime modifications of the exchange are prohibited." );
        }
        
        if ( value == nullptr )
        {
            throw invalid_argument( "Null formats are not supported." );
        }
        
        m_pimpl->m_formats.insert( make_pair( media_type, value ) );
    }
    
    void Exchange::add_signal_handler( const int signal, const function< void ( const int ) >& value )
    {
        if ( m_pimpl->m_boot_time )
        {
            throw runtime_error( "Runtime modifications of the exchange are prohibited." );
        }
        
        if ( value not_eq nullptr )
        {
            m_pimpl->m_service->set_signal_handler( signal, value );
        }
    }
    
    void Exchange::set_logger( const shared_ptr< Logger >& value )
    {
        if ( m_pimpl->m_boot_time )
        {
            throw runtime_error( "Runtime modifications of the exchange are prohibited." );
        }
        
        m_pimpl->m_logger = value;
    }
    
    void Exchange::set_repository( const shared_ptr< Repository >& value )
    {
        if ( m_pimpl->m_boot_time )
        {
            throw runtime_error( "Runtime modifications of the exchange are prohibited." );
        }
        
        if ( value == nullptr )
        {
            throw invalid_argument( "Null repositories are not supported." );
        }
        
        m_pimpl->m_repository = value;
    }
    
    void Exchange::set_ready_handler( const function< void ( Exchange& ) >& value )
    {
        if ( m_pimpl->m_boot_time )
        {
            throw runtime_error( "Runtime modifications of the exchange are prohibited." );
        }
        
        if ( value not_eq nullptr )
        {
            m_pimpl->m_ready_handler = bind( value, std::ref( *this ) );
        }
    }
}
