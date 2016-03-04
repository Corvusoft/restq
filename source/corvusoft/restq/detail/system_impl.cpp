/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

//System Includes

//Project Includes
#include "corvusoft/restq/detail/system_impl.hpp"

//External Includes

#ifdef __APPLE__
    #include <cstdio>
    #include <cstdlib>
    #include <ctype.h>
    #include <mach/mach_init.h>
    #include <mach/mach_error.h>
    #include <mach/mach_host.h>
    #include <mach/vm_map.h>
#endif

//System Namespaces

//Project Namespaces

//External Namespaces

namespace restq
{
    namespace detail
    {
        static const float cpu_load_setup = SystemImpl::get_cpu_load( );
        
        float SystemImpl::get_cpu_load( void )
        {
#ifdef __APPLE__
            static unsigned long long previous_idle_ticks = 0;
            static unsigned long long previous_total_ticks = 0;
            
            host_cpu_load_info_data_t cpu_info;
            mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
            
            const auto status = host_statistics( mach_host_self( ), HOST_CPU_LOAD_INFO, reinterpret_cast< host_info_t >( &cpu_info ), &count );
            
            if ( status == KERN_SUCCESS )
            {
                unsigned long long total_ticks = 0;
                
                for ( int index = 0; index < CPU_STATE_MAX; index++ )
                {
                    total_ticks += cpu_info.cpu_ticks[ index ];
                }
                
                unsigned long long idle_ticks = cpu_info.cpu_ticks[ CPU_STATE_IDLE ];
                unsigned long long total_ticks_since_last_time = total_ticks - previous_total_ticks;
                unsigned long long idle_ticks_since_last_time  = idle_ticks - previous_idle_ticks;
                
                float result = 1.0f;
                result -= ( total_ticks_since_last_time > 0 ) ? static_cast< float >( idle_ticks_since_last_time ) / total_ticks_since_last_time : 0;
                
                previous_idle_ticks  = idle_ticks;
                previous_total_ticks = total_ticks;
                
                return result * 100;
            }
            
#endif
            return -1.0f;
        }
        
        float SystemImpl::get_memory_load( void )
        {
#ifdef __APPLE__
            FILE* file = popen( "/usr/bin/vm_stat", "r" );
            
            if ( file )
            {
                double pages_used = 0.0;
                double total_pages = 0.0;
                
                char buffer[ 512 ];
                
                while ( fgets( buffer, sizeof( buffer ), file ) != NULL )
                {
                    if ( strncmp( buffer, "Pages", 5 ) == 0 )
                    {
                        const char* b = buffer;
                        
                        while ( ( *b ) and ( isdigit( *b ) == false ) )
                        {
                            b++;
                        }
                        
                        double value = isdigit( *b ) ? atof( b ) : -1.0;
                        
                        if ( value >= 0.0 )
                        {
                            if ( ( strncmp( buffer, "Pages wired", 11 ) == 0 ) or ( strncmp( buffer, "Pages active", 12 ) == 0 ) )
                            {
                                pages_used += value;
                            }
                            
                            total_pages += value;
                        }
                    }
                    else if ( strncmp( buffer, "Mach Virtual Memory Statistics", 30 ) not_eq 0 )
                    {
                        break;
                    }
                }
                
                pclose( file );
                
                if ( total_pages > 0.0 )
                {
                    return static_cast< float>( pages_used / total_pages ) * 100;
                }
            }
            
#endif
            return -1.0f;
        }
    }
}
