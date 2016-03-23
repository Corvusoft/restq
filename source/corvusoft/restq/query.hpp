/*
 * Copyright 2014-2016, Corvusoft Ltd, All Rights Reserved.
 */

#ifndef _RESTQ_QUERY_H
#define _RESTQ_QUERY_H 1

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
        struct QueryImpl;
    }
    
    class Query
    {
        public:
            //Friends
            
            //Definitions
            
            //Constructors
            Query( void );
            
            virtual ~Query( void );
            
            //Functionality
            
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
            Query( const Query& original ) = delete;
            
            //Functionality
            
            //Getters
            
            //Setters
            
            //Operators
            Query& operator =( const Query& value ) = delete;
            
            //Properties
            detail::QueryImpl* m_pimpl;
    };
}

#endif  /* _RESTQ_QUERY_H */
