/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_RULE_KEY_H
#define _RESTQ_DETAIL_RULE_KEY_H 1

//System Includes
#include <vector>
#include <string>
#include <memory>
#include <sstream>
#include <functional>

//Project Includes
#include <corvusoft/restq/byte.hpp>
#include <corvusoft/restq/string.hpp>
#include <corvusoft/restq/session.hpp>
#include <corvusoft/restq/request.hpp>
#include <corvusoft/restq/detail/error_handler_impl.hpp>

//External Includes
#include <kashmir/uuid_gen.h>
#include <kashmir/system/devrand.h>
#include <corvusoft/restbed/rule.hpp>

//System Namespaces
using std::map;
using std::string;
using std::vector;
using std::function;
using std::multimap;
using std::to_string;
using std::shared_ptr;
using std::stringstream;

//Project Namespaces

//External Namespaces
using restbed::Rule;

namespace restq
{
    namespace detail
    {
        class Key final : public Rule
        {
            public:
                Key( void ) : Rule( )
                {
                    return;
                }
                
                virtual ~Key( void )
                {
                    return;
                }
                
                bool condition( const shared_ptr< Session > session ) final override
                {
                    return session->get_request( )->has_path_parameter( "key" );
                }
                
                void action( const shared_ptr< Session > session, const function< void ( const shared_ptr< Session > ) >& callback ) final override
                {
                    vector< string > keys = session->get( "keys", vector< string >( ) );
                    
                    const auto key = session->get_request( )->get_path_parameter( "key", String::lowercase );
                    keys.push_back( key );
                    
                    session->set( "keys", keys );
                    callback( session );
                }
                
                static Bytes make( void )
                {
                    kashmir::uuid_t uuid;
                    kashmir::system::DevRand random;
                    random >> uuid;
                    
                    stringstream stream;
                    stream << uuid;
                    
                    return String::to_bytes( stream.str( ) );
                }
        };
    }
}

#endif  /* _RESTQ_DETAIL_RULE_KEY_H */
