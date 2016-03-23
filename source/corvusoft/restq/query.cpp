/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <ciso646>

//Project Includes
#include "corvusoft/restq/query.hpp"
#include "corvusoft/restq/detail/query_impl.hpp"

//External Includes

//System Namespaces

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
}
