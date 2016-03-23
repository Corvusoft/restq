/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <ciso646>

//Project Includes
#include "corvusoft/restq/query.hpp"
#include "corvusoft/restq/session.hpp"
#include "corvusoft/restq/detail/query_impl.hpp"

//External Includes

//System Namespaces
using std::size_t;
using std::string;
using std::vector;
using std::multimap;
using std::shared_ptr;

//Project Namespaces
using restq::detail::QueryImpl;

//External Namespaces

namespace restq
{
    Query::Query( void ) : m_pimpl( new QueryImpl )
    {
        return;
    }
    
    Query::~Query( void )
    {
        delete m_pimpl;
    }
    
    Bytes Query::get_include( void ) const
    {
        return m_pimpl->m_include;
    }
    
    size_t Query::get_index( void ) const
    {
        return m_pimpl->m_index;
    }
    
    size_t Query::get_limit( void ) const
    {
        return m_pimpl->m_limit;
    }
    
    vector< string > Query::get_keys( void ) const
    {
        return m_pimpl->m_keys;
    }
    
    shared_ptr< Session > Query::get_session( void ) const
    {
        return m_pimpl->m_session;
    }
    
    multimap< string, Bytes > Query::get_inclusive_filters( void ) const
    {
        return m_pimpl->m_inclusive_filters;
    }
    
    multimap< string, Bytes > Query::get_exclusive_filters( void ) const
    {
        return m_pimpl->m_exclusive_filters;
    }
    
    void Query::set_index( const size_t start )
    {
        m_pimpl->m_index = start;
    }
    
    void Query::set_limit( const size_t stop )
    {
        m_pimpl->m_limit = stop;
    }
    
    void Query::set_include( const Bytes& relationship )
    {
        m_pimpl->m_include = relationship;
    }
    
    void Query::set_keys( const vector< string >& values )
    {
        m_pimpl->m_keys = values;
    }
    
    void Query::set_session( const shared_ptr< Session >& value )
    {
        m_pimpl->m_session = value;
    }
    
    void Query::set_inclusive_filters( const multimap< string, Bytes >& values )
    {
        m_pimpl->m_inclusive_filters = values;
    }
    
    void Query::set_exclusive_filters( const multimap< string, Bytes >& values )
    {
        m_pimpl->m_exclusive_filters = values;
    }
}
