/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes
#include <set>
#include <regex>
#include <stdexcept>

//Project Includes
#include "corvusoft/restq/uri.hpp"
#include "corvusoft/restq/string.hpp"
#include "corvusoft/restq/detail/validator_impl.hpp"

//External Includes

//System Namespaces
using std::set;
using std::pair;
using std::regex;
using std::string;
using std::regex_match;
using std::out_of_range;
using std::invalid_argument;

//Project Namespaces

//External Namespaces

namespace restq
{
    namespace detail
    {
        const string ValidatorImpl::key_pattern = "^[0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}$";
        
        bool ValidatorImpl::has_invalid_key( const Resource& value )
        {
            if ( value.count( "key" ) )
            {
                const auto key = String::to_string( value.lower_bound( "key" )->second );
                
                static const regex regular_expression( key_pattern );
                return not regex_match( key, regular_expression );
            }
            
            return false;
        }
        
        bool ValidatorImpl::has_reserved_create_fields( const Resource& value )
        {
            static const set< string > reserved_words
            {
                "type",
                "origin",
                "created",
                "revision",
                "modified"
            };
            
            for ( const auto& field : value )
            {
                if ( reserved_words.count( field.first ) )
                {
                    return true;
                }
            }
            
            return false;
        }
        
        bool ValidatorImpl::has_reserved_update_fields( const Resource& value )
        {
            return value.count( "key" ) or has_reserved_create_fields( value );
        }
        
        bool ValidatorImpl::has_invalid_create_fields( const Resource& value, const Bytes& type )
        {
            if ( type == SUBSCRIPTION )
            {
                if ( value.count( "endpoint" ) not_eq 1 )
                {
                    return true;
                }
                
                const auto endpoint = String::to_string( value.lower_bound( "endpoint" )->second );
                
                if ( not Uri::is_valid( endpoint ) )
                {
                    return true;
                }
                
                const Uri uri( endpoint );
                
                if ( uri.get_scheme( ) not_eq "http" )
                {
                    return true;
                }
            }
            else if ( type == QUEUE )
            {
                try
                {
                    if ( value.count( "message-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "message-limit" )->second ) );
                    }
                    
                    if ( value.count( "message-size-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "message-size-limit" )->second ) );
                    }
                    
                    if ( value.count( "subscription-limit" ) )
                    {
                        stoul( String::to_string( value.lower_bound( "subscription-limit" )->second ) );
                    }

                    if ( value.count( "pattern" ) and "pub-sub" not_eq String::to_string( value.lower_bound( "pattern" )->second ) )
                    {
                       return true;
                    }
                }
                catch ( const invalid_argument& ia )
                {
                    return true;
                }
                catch ( const out_of_range& ofr )
                {
                    return true;
                }
            }
            
            return false;
        }
        
        bool ValidatorImpl::has_invalid_update_fields( const Resource& value, const Bytes& type )
        {
            if ( type == SUBSCRIPTION )
            {
                if ( value.count( "endpoint" ) )
                {
                    const auto endpoint = String::to_string( value.lower_bound( "endpoint" )->second );
                    
                    if ( not Uri::is_valid( endpoint ) )
                    {
                        return true;
                    }
                    
                    const Uri uri( endpoint );
                    
                    if ( uri.get_scheme( ) not_eq "http" )
                    {
                        return true;
                    }
                }
            }
            else if ( type == QUEUE )
            {
                return has_invalid_create_fields( value, type );
            }
            
            return false;
        }
        
        bool ValidatorImpl::is_valid_forwarding_header( const pair< const string, const string >& header )
        {
            static const set< string > invalid_headers
            {
                "upgrade", "connection",
                "te", "trailer", "transfer-encoding",
                "expect", "range", "retry-after", "allow",
                "content-length", "content-location", "content-md5",
                "from", "host", "via", "server", "referer", "date", "location",
                "pragma", "cache-control", "age", "etag", "vary", "expires",  "last-modified",
                "authorization", "www-authenticate", "proxy-authorization", "proxy-authenticate",
                "accept", "accept-charset", "accept-encoding", "accept-language", "accept-ranges",
                "if-match", "if-modified-since", "if-none-match", "if-range", "if-unmodified-since"
            };
            
            return invalid_headers.count( String::lowercase( header.first ) ) == 0;
        }
    }
}
