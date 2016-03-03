/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <regex>
#include <ciso646>

//Project Includes
#include "corvusoft/restq/string.hpp"

//External Includes

//System Namespaces
using std::regex;
using std::string;
using std::regex_match;

//Project Namespaces

//External Namespaces

namespace restq
{
    bool String::is_integer( const string& value )
    {
        static const regex pattern( "^[\\-+]?[0-9]+$" );
        return regex_match( value, pattern );
    }
    
    bool String::is_boolean( const string& value )
    {
        const auto boolean = String::lowercase( value );
        return boolean == "true" or boolean == "false";
    }
    
    bool String::is_fraction( const string& value )
    {
        static const regex pattern( "^[\\-+]?([0-9]+\\.[0-9]+)$" );
        return regex_match( value, pattern );
    }
}
