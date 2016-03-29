/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_QUERY_IMPL_H
#define _RESTQ_DETAIL_QUERY_IMPL_H 1

//System Includes
#include <map>
#include <memory>
#include <limits>
#include <string>
#include <vector>
#include <cstddef>

//Project Includes
#include "corvusoft/restq/byte.hpp"
#include "corvusoft/restq/session.hpp"
#include "corvusoft/restq/resource.hpp"

//External Includes

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    //Forward Declarations
    
    namespace detail
    {
        //Forward Declarations
        
        struct QueryImpl
        {
            int m_error_code = 0;
            
            Bytes m_include = { };
            
            Resources m_resultset = { };
            
            std::vector< std::string > m_keys = { };
            
            std::shared_ptr< Session > m_session = nullptr;
            
            std::multimap< std::string, Bytes > m_inclusive_filters = { };
            
            std::multimap< std::string, Bytes > m_exclusive_filters = { };
            
            std::size_t m_index = std::numeric_limits< std::size_t >::min( );
            
            std::size_t m_limit = std::numeric_limits< std::size_t >::max( );
        };
    }
}

#endif  /* _RESTQ_DETAIL_QUERY_IMPL_H */
