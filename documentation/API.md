##API Overview

This document is intented to accurately communicate the Application Programming Interface (API) exposed by the RestQ framework for public consumption. It does not go into detail regarding the [Network API](#NETWORK-API.md).

A description of the frameworks software architecture is provided by the [Design Overview](#DESIGN.md) documentation.

### Interpretation
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

## Table of Contents  
1. [Overview](#example)
2. [Interpretation](#interpretation)
3. [Byte/Bytes](#bytebytes)
4. [Resource/Resources](#resourceresources)
5. [StatusCode](#statuscode)
6. [String](#string)
7. [URI](#uri)
8. [Request](#request)
9. [Response](#response)
10. [Session](#session)
11. [Query](#query)
12. [SSLSettings](#sslsettings)
13. [Settings](#settings)
14. [Formatter](#formatter)
15. [Repository](#repository)
16. [Logger](#logger)
17. [Logger::Level](#loggerlevel)
18. [Exchange](#exchange)

### Byte/Bytes

``` C++
using Byte = restbed::Byte;
    
using Bytes = restbed::Bytes;
```

Byte represents an unsigned 8-bit wide data-type, Bytes provides container functionality with [Standard Template Library](http://en.cppreference.com/w/cpp) (STL) [vector](http://en.cppreference.com/w/cpp/container/vector) collection semantics. 

See also [restbed::Bytes](https://github.com/corvusoft/restbed/documentation/API.md#bytebytes) for details.

### Resource/Resources

``` C++
typedef std::multimap< std::string, Bytes > Resource;
    
typedef std::list< Resource > Resources;
```

Resource represents an [associative array](http://en.cppreference.com/w/cpp/container/multimap) allowing multiple duplicate key-value pairs. This type definition is the primary data-structure used throughout to represent RESTful resources. Container functionality is provided via the Resources container having STL [list](http://en.cppreference.com/w/cpp/container/list) collection semantics.

### StatusCode

``` C++
enum : int
{
    CONTINUE = 100,
    SWITCHING_PROTOCOLS = 101,
    PROCESSING = 102,
    OK = 200,
    CREATED = 201,
    ACCEPTED = 202,
    NON_AUTHORITATIVE_INFORMATION  = 203,
    
    ...
}
```

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) of HTTP response status codes as outlined in [RFC 7231 sub-section 6.1](https://tools.ietf.org/html/rfc7231#section-6.1).

### String

Utility class with static scope offering a common suite of string manipulation routines. Additional methods are inherited from [restbed::String](https://github.com/corvusoft/restbed/documentation/API.md#string) and will not be restated here for convenience.

#### Methods  
* [is_integer](#stringis_integer)
* [is_fraction](#stringis_fraction)
* [is_boolean](#stringis_boolean)
* [trim](#stringtrim)
* [trim_leading](#stringtrim_leading)
* [trim_lagging](#stringtrim_lagging)

#### String::is_integer

``` C++
static bool is_integer( const std::string& value );
```

Parses a string and attemtps to validate if it holds a representation of an integer value.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |

##### Return Value
 
boolean true if the argument is a string representation of an integer, otherwise false.
 
##### Exceptions

n/a

#### String::is_fraction

``` C++
static bool is_fraction( const std::string& value );
```

Parses a string and attemtps to validate if it holds a representation of a numeric value containing a decimal point.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |

##### Return Value
 
boolean true if the argument is a string representation of a fraction, otherwise false.
 
##### Exceptions

n/a

#### String::is_boolean

``` C++
static bool is_boolean( const std::string& value );
```

Parses a string ignoring case and attemtps to validate if it holds the representation of a boolean value 'true' or 'false'.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |

##### Return Value
 
boolean true if the argument is a string or either 'true' or 'false', otherwise false.
 
##### Exceptions

n/a

#### String::trim

``` C++
static std::string trim( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the front and rear of the supplied string value.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline | input |

##### Return Value
 
String matching the input value with the exception of removing leading and lagging characters that match those specified in the range parameter.

##### Exceptions

n/a

#### String::trim_leading

``` C++
static std::string trim_leading( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the front of the supplied string value.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline | input |

##### Return Value
 
String matching the input value with the exception of removing leading characters that match those specified in the range parameter.

##### Exceptions

n/a

#### String::trim_lagging

``` C++
static std::string trim_lagging( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the rear of the supplied string value.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline | input |

##### Return Value
 
String matching the input value with the exception of removing lagging characters that match those specified in the range parameter.

##### Exceptions

n/a

### Uri

``` C++
using Uri = restbed::Uri;
```

Represents a Uniform Resource Identifier as specificed in RFC 3986.

> A generic URI is of the form:
>
> scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

See [restbed::Uri](https://github.com/corvusoft/restbed/documentation/API.md#uri) for details.

### Request

``` C++
using Request = restbed::Request;
```

Represents a HTTP request with additional helper methods for minipulating data, and improving code readability.

See [restbed::Request](https://github.com/corvusoft/restbed/documentation/API.md#request) for details.

### Response

``` C++
using Response = restbed::Response;
```

Represents a HTTP request with additional helper methods for minipulating data, and improving code readability.

See [restbed::Response](https://github.com/corvusoft/restbed/documentation/API.md#response) for details.

### Session

``` C++
using Session = restbed::Session;
```

Represents a conversation between a client and the service. Internally this class holds the network state and exposes public functionality to interact with the exchanges runloop for asynchronous data acquisation and/or sleep states, Only [Authenticators](#authenticator) and [Repository](#repository) developers require access to this functionality.

See [restbed::Session](https://github.com/corvusoft/restbed/documentation/API.md#session) for details.

### Query

Represents a data store enquire for creating, reading, updating, and/or deleting resources.  This class is an implemention of the [Parameter Object](http://c2.com/cgi/wiki?ParameterObject) pattern allowing for greater extensiablilty during [Repository](#repository) interaction.

#### Methods  
* [clear](#queryclear)
* [has_failed](#queryhas_failed)
* [has_fields](#queryhas_fields)
* [has_resultset](#queryhas_resultset)
* [get_include](#queryget_include)
* [get_error_code](#queryget_error_code)
* [get_index](#queryget_index)
* [get_limit](#queryget_limit)
* [get_resultset](#queryget_resultset)
* [get_fields](#queryget_fields)
* [get_keys](#queryget_keys)
* [get_session](#queryget_session)
* [get_inclusive_filters](#queryget_inclusive_filters)
* [get_exclusive_filters](#queryget_exclusive_filters)
* [set_error_code](#queryset_error_code)
* [set_index](#queryset_index)
* [set_limit](#queryset_limit)
* [set_resultset](#queryset_resultset)
* [set_include](#queryset_include)
* [set_key](#queryset_key)
* [set_keys](#queryset_keys)
* [set_fields](#queryset_fields)
* [set_session](#queryset_session)
* [set_inclusive_filters](#queryset_inclusive_filters)
* [set_exclusive_filters](#queryset_exclusive_filters)

#### Query::clear

``` C++
void clear( void );
```

Removes all elements from the container.

Invalidates any references, pointers, or iterators referring to contained elements. Leaves the capacity of the internal collection unchanged.

##### Parameters

n/a

##### Return Value

n/a

##### Exceptions

n/a

#### Query::has_failed

``` C++
bool has_failed( void ) const;
```

Checks if the query has failed, i.e. whether the database returned an error status; see also [get_error_code](#get_error_code).

##### Parameters

n/a

##### Return Value
 
true if the query has failed, false otherwise.

##### Exceptions

n/a

#### Query::has_fields

``` C++
bool has_fields( void ) const;
```

Check if the query has a fields criteria specified; see also [set_fields](#set_fields).

##### Parameters

n/a

##### Return Value
 
true if the query contains a fields criteria, false otherwise.

##### Exceptions

n/a

#### Query::has_resultset

``` C++
bool has_resultset( void ) const;
```

Check if the query has returned any results; see also [set_resultset](#set_resultset).

##### Parameters

n/a

##### Return Value
 
true if the query contains results, false otherwise.

##### Exceptions

n/a

#### Query::get_include

``` C++
restq::Bytes get_include( void ) const;
```

Retrieves the contents of the include criteria; see also [set_include](#set_include).

##### Parameters

n/a

##### Return Value
 
[Bytes](#bytebytes) representing an entity relationship between two or more records, i.e Weather a query for a queue should also return linked subscriptions.

##### Exceptions

n/a
            
#### Query::get_error_code

``` C++
int get_error_code( void ) const;
```

Retrieves the error status of a query, if the query has not been processed 0 is returned; see also [set_error_code](#set_error_code).

The result of this method is used within the service and mapped to a HTTP error response.

##### Parameters

n/a

##### Return Value
 
Signed integer representing an error condition.

##### Exceptions

n/a
            
#### Query::get_index

``` C++
std::size_t get_index( void ) const;
```

Retrieves the contents of the index criteria; see also [set_index](#set_index).

##### Parameters

n/a

##### Return Value
 
Unsigned integer representing the an offset position into the available results, 0 by default.

##### Exceptions

n/a

#### Query::get_limit

``` C++
std::size_t get_limit( void ) const;
```

Retrieves the contents of the limit criteria; see also [set_limit](#set_limit).

##### Parameters

n/a

##### Return Value
 
Unsigned integer representing the number of results to be returned, max( std::size_t ) by default.

##### Exceptions

n/a

#### Query::get_resultset

``` C++
restq::Resources get_resultset( void ) const;
```

Retrieves the query results; see also [set_resultset](#set_resultset).

##### Parameters

n/a

##### Return Value
 
Collection of [restq::Resource](#resourceresources) representing the results of a query, empty by default.

##### Exceptions

n/a
        
#### Query::get_fields

``` C++
std::set< std::string > get_fields( void ) const;
```

Retrieves the contents of the fields criteria; see also [set_fields](#set_fields).

##### Parameters

n/a

##### Return Value
 
[std::set](http://en.cppreference.com/w/cpp/container/set) of strings representing the required fields (columns) to return, empty by default indicating to return all fields.

##### Exceptions

n/a        
           
#### Query::get_keys

``` C++
std::vector< std::string > get_keys( void ) const;
```

Retrieves the contents of the keys criteria; see also [set_keys](#set_keys).

##### Parameters

n/a

##### Return Value
 
[std::vector](http://en.cppreference.com/w/cpp/container/vector) of strings representing the keys criteria for this query, empty by default indicating to return all records.

##### Exceptions

n/a 

#### Query::get_session

``` C++
std::shared_ptr< restq::Session > get_session( void ) const;
```

Retrieves a smart-pointer of the client's [session](#session) attached to this query; see also [set_session](#set_session).

##### Parameters

n/a

##### Return Value
 
[std::shared_ptr](http://en.cppreference.com/w/cpp/memory/shared_ptr) reference to the client's network [session](#session), [nullptr](http://en.cppreference.com/w/cpp/types/nullptr_t) by default.

##### Exceptions

n/a 
            
#### Query::get_inclusive_filters

``` C++
std::multimap< std::string, restq::Bytes > get_inclusive_filters( void ) const;
```

Retrieves the contents of the inclusive filters criteria; see also [set_inclusive_filters](#set_inclusive_filters).

##### Parameters

n/a

##### Return Value
 
[std::multimap](http://en.cppreference.com/w/cpp/container/multimap) representing inclusive filters; empty by default.

##### Exceptions

n/a             
     
#### Query::get_exclusive_filters

``` C++
std::multimap< std::string, restq::Bytes > get_exclusive_filters( void ) const;
```

Retrieves the contents of the exclusive filters criteria; see also [set_exclusive_filters](#set_exclusive_filters).

##### Parameters

n/a

##### Return Value
 
[std::multimap](http://en.cppreference.com/w/cpp/container/multimap) representing exclusive filters; empty by default.

##### Exceptions

n/a
            
#### Query::set_error_code

``` C++
void set_error_code( const int value );
```

Replaces the contents of the query error status; see also [get_error_code](#get_error_code).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   |     [int](http://en.cppreference.com/w/cpp/language/types)     | n/a | input |

##### Return Value
 
n/a

##### Exceptions

n/a

#### Query::set_index

``` C++
void set_index( const std::size_t start );
```

Replaces the contents of the index criteria; see also [get_index](#get_index).

The index criteria specifies an offset into the recordset to begin the query, i.e row number to start query at. In combination with [set_limit](#set_limit) paging is through records is possible.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   start   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a | input |

##### Return Value
 
n/a

##### Exceptions

n/a

#### Query::set_limit

``` C++
void set_limit( const std::size_t stop );
```

Replaces the contents of the limit criteria; see also [set_limit](#set_limit).

The limit criteria specifies the number of records to be returned. In combination with [set_index](#set_index) paging is through records is possible.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   stop    | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a | input |

##### Return Value
 
n/a

##### Exceptions

n/a
 
#### Query::set_resultset

``` C++
void set_resultset( const restq::Resources& values );
```

Replaces the contents of the query's resultset; see also [get_resultset](#get_resultset).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   values   | [restq::Resources](#resourceresources) | n/a | input |

##### Return Value
 
n/a

##### Exceptions

n/a
 
#### Query::set_include

``` C++
void set_include( const restq::Bytes& relationship );
```

Replaces the contents of the include critiera; see also [get_include](#get_include).

The include criteria represents a entity relationship between two or more records, i.e Weather a query for a queue should also return linked subscriptions.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   relationship   | [restq::Bytes](#bytebytes) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a  
            
#### Query::set_keys

``` C++
1. void set_key( const restq::Bytes& value );
2. void set_key( const std::string& value );
3. void set_keys( const std::vector< std::string >& values );
```

Replaces the contents of the query's key criteria; see also [get_keys](#get_keys).

1) Adds a key represented as a sequence of [restq::Byte](#bytebytes), internally converts to [std::string](http://en.cppreference.com/w/cpp/string/basic_string).

2) Adds a key to the query's search criteria.

3) Replaces the query's key search critiera with those specified in values.

The key search criteria indicates that only records with these keys may be returned.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Bytes](#bytebytes) | n/a | input |
|   -   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   values   | [std::vector](http://en.cppreference.com/w/cpp/container/vector) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 

#### Query::set_fields

``` C++
void set_fields( const std::set< std::string >& values );
```

Replaces the contents of the query's fields criteria; see also [get_fields](#get_fields).

The fields search criteria indicates what fields (columns) from each record should be returned.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------:|
|   value   | [std::set](http://en.cppreference.com/w/cpp/container/set) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 
            
#### Query::set_session

``` C++
void set_session( const std::set< std::string >& values );
```

Replaces the contents of the client session attached to this query; see also [set_session](#set_session).

Altering the client session property outside of the exchange will lead to undefined behaviour. It's made available to the repository so as to call Session::sleep_for while waiting for query results. 

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::set](http://en.cppreference.com/w/cpp/container/set) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 

#### Query::set_inclusive_filters

``` C++
1. void set_inclusive_filter( const std::string& name, const restq::Bytes& value );
2. void set_inclusive_filters( const std::multimap< std::string, restq::Bytes >& values );
```

Replaces the contents of the query's inclusive filters criteria; see also [get_inclusive_filters](#get_inclusive_filters).

1) Add an inclusive filter to the query's search critiera.

2) Replace the contents of the query's inclusive filters criteria with that specifed by values.

Inclusive filters represent a 'must have at least one-of' OR condition. i.e The following will return all records that have a type of 'queue' or 'subscription':

``` C++
auto filters = multimap< string, Bytes > {
  { "type", String::to_bytes( "queue" ) },
  { "type", String::to_bytes( "subscription" ) }
};

auto query = make_shared< Query >( );
query->set_inclusive_filters( filters );

m_repository->read( query, ... );
```

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------:|
|   name   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   value   | [restq::Bytes](#bytebytes) | n/a | input |
|   values   | [std::multimap](http://en.cppreference.com/w/cpp/container/multimap) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 

#### Query::set_exclusive_filters

``` C++
1. void set_exclusive_filter( const std::string& name, const restq::Bytes& value );
2. void set_exclusive_filters( const std::multimap< std::string, restq::Bytes >& values );
```

Replaces the contents of the query's inclusive filters criteria; see also [get_exclusive_filters](#get_exclusive_filters).

1) Add an exclusive filter to the query's search critiera.

2) Replace the contents of the query's exclusive filters criteria with that specifed by values.

Exclusive filters represent a 'must have' AND condition. i.e The following will return all records that have a type of 'queue' and a name property of 'events':

``` C++
auto filters = multimap< string, Bytes > {
  { "type", String::to_bytes( "queue" ) },
  { "name", String::to_bytes( "events" ) }
};

auto query = make_shared< Query >( );
query->set_exclusive_filters( filters );

m_repository->read( query, ... );
```

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   name   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   value   | [restq::Bytes](#bytebytes) | n/a | input |
|   values   | [std::multimap](http://en.cppreference.com/w/cpp/container/multimap) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 

### SSLSettings

``` C++
using SSLSettings = restbed::SSLSettings;
```

Represents Secure Socket Layer service configuration.

See [restbed::SSLSettings](https://github.com/corvusoft/restbed/documentation/API.md#sslsettings) for details.

### Settings

Represents the primary point of [Exchange](#exchange), [Repository](#repository), and [Logger](#logger) configuration. The mass majority of its implementation is inherited from [restbed::Settings](https://github.com/corvusoft/restbed/documentation/API.md#settings) with additional RestQ specific methods included and the following methods **removed**:

``` C++
bool get_case_insensitive_uris( void ) const = delete;
std::string get_property( const std::string& name ) const = delete;
std::map< std::string, std::string > get_properties( void ) const = delete;
std::string get_status_message( const int code ) const = delete;
std::map< int, std::string > get_status_messages( void ) const = delete;
std::multimap< std::string, std::string > get_default_headers( void ) const = delete;
void set_case_insensitive_uris( const bool value ) = delete;
void set_property( const std::string& name, const std::string& value ) = delete;
void set_properties( const std::map< std::string, std::string >& values ) = delete;
void set_status_message( const int code, const std::string& message ) = delete;
void set_status_messages( const std::map< int, std::string >& values ) = delete;
void set_default_header( const std::string& name, const std::string& value ) = delete;
void set_default_headers( const std::multimap< std::string, std::string >& values ) = delete;
```

#### Methods 

* [get_default_queue_message_limit](#settingsget_default_queue_message_limit)
* [get_default_queue_message_size_limit](#settingsget_default_queue_message_size_limit)
* [get_default_queue_subscription_limit](#settingsget_default_queue_subscription_limit)
* [set_default_queue_message_limit](#settingsset_default_queue_message_limit)
* [set_default_queue_message_size_limit](#settingsset_default_queue_message_size_limit)
* [set_default_queue_subscription_limit](#settingsset_default_queue_subscription_limit)

#### Settings::get_default_queue_message_limit

``` C++
std::size_t get_default_queue_message_limit( void ) const;
```

Retrieves the default message limit given to a freshly created queue; see also [set_default_queue_message_limit](#set_default_queue_message_limit).

##### Parameters

n/a

##### Return Value

unsigned integer representing maximum number of messages allowed on a queue before client rejection.

##### Exceptions

n/a

#### Settings::get_default_queue_message_size_limit

``` C++
std::size_t get_default_queue_message_size_limit( void ) const;
```

Retrieves the default message size limit given to a freshly created queue; see also [set_default_queue_message_size_limit](#set_default_queue_message_size_limit).

##### Parameters

n/a

##### Return Value

unsigned integer representing maximum message size in number of bytes before client rejection.

##### Exceptions

n/a    
            
#### Settings::get_default_queue_subscription_limit

``` C++
std::size_t get_default_queue_subscription_limit( void ) const;
```

Retrieves the default subscription limit given to a freshly created queue; see also [set_default_queue_subscription_limit](#set_default_queue_subscription_limit).

##### Parameters

n/a

##### Return Value

unsigned integer representing maximum number of subscriptions allowed on a queue before client rejection.

##### Exceptions

n/a

#### Settings::set_default_queue_message_limit

``` C++
void set_default_queue_message_limit( const std::size_t value );
```

Replaces the default message limit (100) given to a freshly created queue; see also [get_default_queue_message_limit](#get_default_queue_message_limit).

Internally this value is compared with the number of pending messages awaiting delivery for a particular queue. If this watermark is breached clients begin to receive the 503 (Service Unavailable) error status until messages have been successful dispatched. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a

#### Settings::set_default_queue_message_size_limit

``` C++
void set_default_queue_message_size_limit( const std::size_t value );
```

Replaces the default message size limit (1024 bytes) given to a freshly created queue; see also [get_default_queue_message_size_limit](#get_default_queue_message_size_limit).

When creating a new message on a queue this vaule is consulted and if breached clients will receive 413 (Request Entity Too Large) error response. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a    
            
#### Settings::set_default_queue_subscription_limit

``` C++
void set_default_queue_subscription_limit( const std::size_t value );
```

Replaces the default subscription limit (25) given to a freshly created queue; see also [get_default_queue_subscription_limit](#get_default_queue_subscription_limit).

Internally this value is compared with the number of consumers currently subscribed to a queue, if breached clients see a  503 (Service Unavailable) error response. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a  

### Formatter

Interface detailing the required contract for Format extensions. The concept of a format within RestQ is that of a document structure i.e JSON, XML, YAML, HTML.

#### Methods  
* [parse](#formatterparse)
* [try_parse](#formattertry_parse)
* [compose](#formattercompose)
* [get_media_type](#formatterget_media_type)
* [set_logger](#formatterset_logger)

#### Formatter::parse

``` C++
virtual restq::Resources parse( const restq::Bytes& document ) = 0;
```

Parses a [restq::Byte](#bytebytes) sequence containing a document structure; see also [parse](#formattertry_parse).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:---------:|
|   document   | [restq::Byte](#bytebytes) | n/a | input |

##### Return Value

Collection of decoded [restq::Resource](#resourceresources) entities. 

##### Exceptions

If an exception is thrown for any reason, the service will close the active client session with an appropriate HTTP error response.

#### Formatter::try_parse

``` C++
virtual bool try_parse( const restq::Bytes& document, restq::Resources& values ) noexcept = 0;
```

Exception safe parsing of a [restq::Byte](#bytebytes) sequence containing a document structure. The result of which is a collection of decoded [restq::Resource](#resourceresources) entities held within the values parameter; see also [parse](#formatterparse).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   document   | [restq::Byte](#bytebytes) | n/a           | input |
|   values   | [restq::Resoures](#resourceresources) | n/a           | output |

##### Return Value

true if parsing was successful, false otherwise.

##### Exceptions

noexcept specification:  [noexcept](http://en.cppreference.com/w/cpp/language/noexcept_spec)

#### Formatter::compose

``` C++
virtual restq::Bytes compose( const restq::Resources& values, const bool styled = false ) = 0;
```

Convert a collection of [restq::Resource](#resourceresources) entities into a document structure. With an optional argument switch to allow styling documents into a more human consumable output, i.e JSON with whitespace included.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   values   | [restq::Resoures](#resourceresources) | n/a | input |
|   styled   | [bool](http://en.cppreference.com/w/cpp/language/types) | false | in |

##### Return Value

[restq::Byte](#bytebytes) sequence containing a document structure.

##### Exceptions

If an exception is thrown for any reason, the service will close the active client session with an appropriate HTTP error response.

#### Formatter::get_media_type

``` C++
virtual const std::string get_media_type( void ) const = 0;
```

Retreive the supported media type, i.e application/json.

This value is compared against the [Accept](https://tools.ietf.org/html/rfc7231#section-5.3.2) and [Content-Type](https://tools.ietf.org/html/rfc7231#section-3.1.1.5) headers to determine if it is capable of parsing the HTTP request/response body.

##### Parameters

n/a

##### Return Value

[std::string](http://en.cppreference.com/w/cpp/string/basic_string) specifying the media type supported by the Formatter.

##### Exceptions

If an exception is thrown for any reason, the service will close the active client session with an appropriate HTTP error response.           

#### Formatter::set_logger

``` C++
virtual void set_logger( const std::shared_ptr< restq::Logger >& value ) = 0;
```

Replace the logger instance.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Logger](#logger) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a  

### Repository

Interface detailing the required contract for repository extensions. A repository represents a data-store for the long term persistence of dynamically created resources via the [Network API](#NETWORK-API.md).

It is encouraged that any implementation of this interface **SHOULD** be of an asynchronous nature, to reduce thread contention within the exchange. This can be achieved with [MariaDB](https://mariadb.com/kb/en/mariadb/using-the-non-blocking-library/), [PostgreSQL](http://www.postgresql.org/docs/7.3/static/libpq-async.html), and other database products.

#### Methods  
* [start](#repositorystart)
* [stop](#repositorystop)
* [create](#repositorycreate)
* [read](#repositoryread)
* [update](#repositoryupdate)
* [destroy](#repositorystartdestroy)
* [set_logger](#repositoryset_logger)

#### Repository::start

``` C++
virtual void start( const std::shared_ptr< const Settings >& settings ) = 0;
```

Initialise a repository instance; see also [stop](#repositorystop).

The [Settings](#settings) passed are the same as those given to [Exchange::start](#exchangestart).

After this method has returned the instance **MUST** be ready to start receiving [create](#repositorycreate), [read](#repositoryread), [update](#repositoryupdate) and [destroy](#repositorydestroy) invocations.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Settings](#settings) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service failing to start.

#### Repository::stop

``` C++
virtual void stop( void ) = 0;
```
Halt/Clean-up repository resources, i.e database connections; see also [start](#repositorystart).

##### Parameters

n/a

##### Return Value

n/a

##### Exceptions

Exceptions raised will result in a dirty service teardown.

#### Repository::create

``` C++
virtual void create( const Resources values,
                     const std::shared_ptr< Query > query,
                     const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
```

Create one or more resources; see also [Resources](#resourceresources) and [Query](#query).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   values   | [restq::Resources](#resourceresources) | n/a | input |
|   query   | [restq::Query](#query) | n/a | input |
|   callback   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service closing the active client session with a 500 (Internal Server Error) error response.

#### Repository::read

``` C++
virtual void read( const std::shared_ptr< Query > query,
                   const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
```

Read one or more resources; see also [Query](#query).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   query   | [restq::Query](#query) | n/a | input |
|   callback   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service closing the active client session with a 500 (Internal Server Error) error response.

#### Repository::update

``` C++
virtual void update( const Resource changeset,
                     const std::shared_ptr< Query > query,
                     const std::function< void ( const std::shared_ptr< Query > ) >& callback ) = 0;
```

Update one or more resources; see also [Resource](#resourceresources) and [Query](#query).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   changeset   | [restq::Resource](#resourceresources) | n/a | input |
|   query   | [restq::Query](#query) | n/a | input |
|   callback   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service closing the active client session with a 500 (Internal Server Error) error response.

#### Repository::destroy

``` C++
virtual void destroy( const std::shared_ptr< Query > query,
                      const std::function< void ( const std::shared_ptr< Query > ) >& callback = nullptr ) = 0;
```            

Delete one or more resources; see also [Query](#query).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   query   | [restq::Query](#query) | n/a | input |
|   callback   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service closing the active client session with a 500 (Internal Server Error) error response.

#### Repository::set_logger

``` C++
virtual void set_logger( const std::shared_ptr< Logger >& value ) = 0;
```

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Logger](#logger) | n/a | input |

##### Return Value

n/a

##### Exceptions

n/a 

### Logger

Interface detailing the required contract for logger extensions.  No default logger is supplied with the codebase and it is the responsibility of third-party developers to implement the desired characterics.

#### Methods  
* [start](#loggerstart)
* [stop](#loggerstop)
* [log](#loggerlog)
* [log_if](#loggerlog_if)
* [level](#loggerlevel)

#### Logger::start

``` C++
virtual void start( const std::shared_ptr< const restq::Settings >& settings ) = 0;
```

Initialise a logger instance; see also [stop](#loggerstop).

The [Settings](#settings) passed are the same as those given to [Exchange::start](#exchangestart).

After this method has returned the instance **MUST** be ready to start receiving [log](#loggerlog) and [log_if](#loggerlog_if) invocations.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Settings](#settings) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service failing to start.

#### Logger::stop

``` C++
virtual void stop( void ) = 0;
```

Halt/Clean-up logger resources; see also [start](#loggerstart).

##### Parameters

n/a

##### Return Value

n/a

##### Exceptions

Exceptions raised will result in a dirty service teardown.

#### Logger::log

``` C++
virtual void log( const Level level, const char* format, ... ) = 0;
```

Commit the message specified under the control of a format string, with the specified level of severity into the log; see also [log_if](#loggerlog_if).

See [printf](http://en.cppreference.com/w/cpp/io/c/fprintf) family of functions for format directives.

>The format string is composed of zero or more directives: ordinary characters (not %), which are copied unchanged to the output stream; and conversion
>specifications, each of which results in fetching zero or more subsequent arguments.  Each conversion specification is >introduced by the % character.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   level   | [restq::Logger::Level](#loggerlevel) | n/a | input |
|   format   | [char*](http://en.cppreference.com/w/cpp/language/types) | n/a | input |
|   ...   | [variadic argument list](http://en.cppreference.com/w/cpp/utility/variadic) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service ignoring the fault and printing directly to [Standard Error (stderr)](http://en.cppreference.com/w/cpp/io/c).

#### Logger::log_if

``` C++
virtual void log_if( bool expression, const Level level, const char* format, ... ) = 0;
```

Commit the message specified under the control of a format string, with the specified level of severity into the log, under the condition that expression is equal to boolean true; see also [log](#loggerlog).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   expresssion   | [bool](http://en.cppreference.com/w/cpp/language/types) | n/a | input |
|   level   | [restq::Logger::Level](#loggerlevel) | n/a | input |
|   format   | [char*](http://en.cppreference.com/w/cpp/language/types) | n/a | input |
|   ...   | [variadic argument list](http://en.cppreference.com/w/cpp/utility/variadic) | n/a | input |

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in the service ignoring the fault and printing directly to [Standard Error (stderr)](http://en.cppreference.com/w/cpp/io/c).

#### Logger::Level

``` C++
class Logger
{
    enum Level : int
    {
        INFO = 0000,
        DEBUG = 1000,
        FATAL = 2000,
        ERROR = 3000,
        WARNING = 4000,
        SECURITY = 5000
    };
}
```

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) used in conjuction with the [Logger interface](#logger) to detail the level of severity towards a particular log entry.

### Exchange

The exchange is reponsible for managing the [Network API](#NETWORK-API.md), HTTP compliance, scheduling of the message dispatch logic and insuring incoming requests are persisted into the [Repository](#repository).

#### Methods  
* [start](#exchangestart)
* [stop](#exchangestop)
* [restart](#exchangerestart)
* [add_format](#exchangeadd_format)
* [add_signal_handler](#exchangeadd_signal_handler)
* [set_logger](#exchangeset_logger)
* [set_repository](#exchangeset_repository)
* [set_ready_handler](#exchangeset_ready_handler)

#### Exchange::start

``` C++
void start( const std::shared_ptr< const Settings >& settings = nullptr );
```

Bring the message service online for public consumption; see also [stop](#exchangestop).

When the exchange starts it publishes queue, subscription, and message resources with their associated collections, see [Network API(#NETWORK-API.md) for details.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Settings](#settings) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown if no repository has been supplied.

#### Exchange::stop

``` C++
void stop( void );
```

Gracefully teardown the exchange; see also [stop](#exchangestart).

##### Parameters

n/a

##### Return Value

n/a

##### Exceptions

Any exceptions raised will result in a dirty service teardown.

#### Exchange::restart

``` C++
void restart( const std::shared_ptr< const Settings >& settings = nullptr );
```

Restart the exchange, this is equivalent to calling [stop](#exchangestop) and then subsequently [start](#exchangestart); see also [start](#exchangestart), [stop](#exchangestop).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [restq::Settings](#settings) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown if no repository has been supplied.

#### Exchange::add_format

``` C++
void add_format( const std::string& media_type, const std::shared_ptr< Formatter >& value );
```

Add a media type document formatter to the exchange; see also [Formatter](#formatter).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   media_type   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a | input |
|   value   | [Formatter](#formatter) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::invalid_argument](http://en.cppreference.com/w/cpp/error/invalid_argument) is thrown when settings value as a [nullptr](http://en.cppreference.com/w/cpp/types/nullptr_t).

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown when attempting to modify a service that is currently active, i.e [start](#exchangestart) has already been called.

#### Exchange::add_signal_handler

``` C++
void add_signal_handler( const int signal, const std::function< void ( const int ) >& value );
```

Inform the exchange to invoke the error handler on recieving the specified system [signal](http://en.cppreference.com/w/cpp/utility/program/signal).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   signal   | [int](http://en.cppreference.com/w/cpp/language/types) | n/a | input |
|   value   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown when attempting to modify a service that is currently active, i.e [start](#exchangestart) has been called.

#### Exchange::set_logger

``` C++
void set_logger( const std::shared_ptr< Logger >& value );
```

Replace the logger to be used by the exchange; see also [Logger](#logger).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [Logger](#logger) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown when attempting to modify a service that is currently active, i.e [start](#exchangestart) has already been called.

#### Exchange::set_repository

``` C++
void set_repository( const std::shared_ptr< Repository >& value );
```

Replace the repository to be used by the exchange; see also [Repository](#repository).

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [Repository](#repository) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::invalid_argument](http://en.cppreference.com/w/cpp/error/invalid_argument) is thrown when settings value as a [nullptr](http://en.cppreference.com/w/cpp/types/nullptr_t).

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown when attempting to modify a service that is currently active, i.e [start](#exchangestart) has been called.

#### Exchange::set_ready_handler

``` C++
void set_ready_handler( const std::function< void ( Exchange& ) >& value );
```

Replace the service ready callback.

The callback specified in value will be invoked once the service is online and ready to serve incoming client requests.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|-----------|:-------------:|:----------: |
|   value   | [std::function](http://en.cppreference.com/w/cpp/utility/functional/function) | n/a | input |

##### Return Value

n/a

##### Exceptions

[std::runtime_error](http://en.cppreference.com/w/cpp/error/runtime_error) is thrown when attempting to modify a service that is currently active, i.e [start](#exchangestart) has already been called.
