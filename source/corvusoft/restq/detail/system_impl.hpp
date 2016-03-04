/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_DETAIL_SYSTEM_IMPL_H
#define _RESTQ_DETAIL_SYSTEM_IMPL_H 1

//System Includes

//Project Includes

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
        
        class SystemImpl
        {
            public:
                //Friends
                
                //Definitions
                
                //Constructors
                
                //Functionality
                static float get_cpu_load( void );
                
                static float get_memory_load( void );
                
                //Getters
                
                //Setters
                
                //Operators
                
                //Properties
                
            protected:
                //Friends
                
                //Definitions
                
                //Constructors
                
                //Functionality
                
                //Getters
                
                //Setters
                
                //Operators
                
                //Properties
                
            private:
                //Friends
                
                //Definitions
                
                //Constructors
                SystemImpl( void ) = delete;
                
                SystemImpl( const SystemImpl& original ) = delete;
                
                virtual ~SystemImpl( void ) = delete;
                
                //Functionality
                
                //Getters
                
                //Setters
                
                //Operators
                SystemImpl& operator =( const SystemImpl& value ) = delete;
                
                //Properties
        };
    }
}

#endif  /* _RESTQ_DETAIL_SYSTEM_IMPL_H */
