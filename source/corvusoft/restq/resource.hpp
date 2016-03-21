/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_RESOURCE_H
#define _RESTQ_RESOURCE_H 1

//System Includes
#include <map>
#include <list>
#include <string>

//Project Includes

//External Includes
#include <corvusoft/restbed/byte.hpp>

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    typedef std::multimap< std::string, Bytes > Resource;
    
    typedef std::list< Resource > Resources;
    
    static const Bytes QUEUE { 'q', 'u', 'e', 'u', 'e' };
    
    static const Bytes STATE = { 's', 't', 'a', 't', 'e' };
    
    static const Bytes MESSAGE = { 'm', 'e', 's', 's', 'a', 'g', 'e' };
    
    static const Bytes SUBSCRIPTION { 's', 'u', 'b', 's', 'c', 'r', 'i', 'p', 't', 'i', 'o', 'n' };
}

#endif  /* _RESTQ_RESOURCE_H */
