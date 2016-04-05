##API Overview

### Document Scope

## Table of Contents  
1. [Document Scope](#example)
2. [Byte/Bytes](#bytebytes)
3. [Resource/Resources](#resourceresources)
4. [LogLevel](#loglevel)
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
15. [Logger](#logger)
16. [Exchange](#exchange)

### Byte/Bytes

#### Description

Byte represents an unsigned 8-bit wide data-type, Bytes provides container functionality with Standard Template Library (STL) [vector](http://en.cppreference.com/w/cpp/container/vector) collection semantics. 

See also [restbed::Bytes](https://github.com/corvusoft/restbed/documentation/API.md#bytebytes) for details.

#### Definition

``` C++
using Byte = restbed::Byte;
    
using Bytes = restbed::Bytes;
```

### Resource/Resources

#### Description

Resource represents an [associative array](http://en.cppreference.com/w/cpp/container/multimap) allowing multiple duplicate key-value pairs. This type definition is the primary data-structure used throughout to represent RESTful resources. Container functionality is provided via the Resources container having STL [list](http://en.cppreference.com/w/cpp/container/list) collection semantics.

#### Definition

``` C++
typedef std::multimap< std::string, Bytes > Resource;
    
typedef std::list< Resource > Resources;
```

### LogLevel

#### Description

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) used in conjuction with the [Logger interface](#logger) to detail the level of severity towards a particular log entry.

#### Definition

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

### StatusCode

#### Description

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) of HTTP response status codes as outlined in [RFC 7231 sub-section 6.1](https://tools.ietf.org/html/rfc7231#section-6.1).

#### Definition

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

### String

Utiltiy class with static scope offering a common suite of string manipulation routines. Additional methods are inherited from [restbed::String](https://github.com/corvusoft/restbed/documentation/API.md#string) and will not be restated here for convenience.

#### Methods  
* [is_integer](#is_integer)
* [is_fraction](#is_fraction)
* [is_boolean](#is_boolean)
* [trim](#trim)
* [trim_leading](#trim_leading)
* [trim_lagging](#trim_lagging)

#### is_integer

``` C++
static bool is_integer( const std::string& value );
```

Parses a string and attemtps to validate if it holds a representation of an integer value.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |

##### Return Value
 
boolean true if the argument is a string representation of an integer, otherwise false.
 
##### Exceptions

n/a

#### is_fraction

``` C++
static bool is_fraction( const std::string& value );
```

Parses a string and attemtps to validate if it holds a representation of a numeric value containing a decimal point.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |

##### Return Value
 
boolean true if the argument is a string representation of a fraction, otherwise false.
 
##### Exceptions

n/a

#### is_boolean

``` C++
static bool is_boolean( const std::string& value );
```

Parses a string ignoring case and attemtps to validate if it holds the representation of a boolean value 'true' or 'false'.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |

##### Return Value
 
boolean true if the argument is a string or either 'true' or 'false', otherwise false.
 
##### Exceptions

n/a

#### trim

``` C++
static std::string trim( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the front and rear of the supplied string value.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline           |

##### Return Value
 
String matching the input value with the exception of removing leading and lagging characters that match those specified in the range parameter.

##### Exceptions

n/a

#### trim_leading

``` C++
static std::string trim_leading( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the front of the supplied string value.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline           |

##### Return Value
 
String matching the input value with the exception of removing leading characters that match those specified in the range parameter.

##### Exceptions

n/a

#### trim_lagging

``` C++
static std::string trim_lagging( const std::string& value, const std::string& range = " \t\r\n" );
```

Removes matching characters from the rear of the supplied string value.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   range   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | space, tab, carriage return, newline           |

##### Return Value
 
String matching the input value with the exception of removing lagging characters that match those specified in the range parameter.

##### Exceptions

n/a

### Uri

Represents a Uniform Resource Identifier as specificed in RFC 3986.

> A generic URI is of the form:
>
> scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

#### Definition

``` C++
using Uri = restbed::Uri;
```

See [restbed::Uri](https://github.com/corvusoft/restbed/documentation/API.md#uri) for details.

### Request

Represents a HTTP request with additional helper methods for minipulating data, and improving code readability.

#### Definition

``` C++
using Request = restbed::Request;
```

See [restbed::Request](https://github.com/corvusoft/restbed/documentation/API.md#request) for details.

### Response

Represents a HTTP request with additional helper methods for minipulating data, and improving code readability.

#### Definition

``` C++
using Response = restbed::Response;
```

See [restbed::Response](https://github.com/corvusoft/restbed/documentation/API.md#response) for details.

### Session

Represents a conversation between a client and the service. Internally this class holds the network state and exposes public functionality to interact with the exchanges runloop for asynchronous data acquisation and/or sleep states, Only Authenticators and Repository developers require access to this functionality.

#### Definition

``` C++
using Session = restbed::Session;
```

See [restbed::Session](https://github.com/corvusoft/restbed/documentation/API.md#session) for details.

### Query

Represents a data store enquire for creating, reading, updating, and/or deleting resources.  This class is an implemention of the [Parameter Object](http://c2.com/cgi/wiki?ParameterObject) pattern allowing for greater extensiablilty during Repository interaction.

#### Methods  
* [clear](#clear)
* [has_failed](#has_failed)
* [has_fields](#has_fields)
* [has_resultset](#has_resultset)
* [get_include](#get_include)
* [get_error_code](#get_error_code)
* [get_index](#get_index)
* [get_limit](#get_limit)
* [get_resultset](#get_resultset)
* [get_fields](#get_fields)
* [get_keys](#get_keys)
* [get_session](#get_session)
* [get_inclusive_filters](#get_inclusive_filters)
* [get_exclusive_filters](#get_exclusive_filters)
* [set_error_code](#set_error_code)
* [set_index](#set_index)
* [set_limit](#set_limit)
* [set_resultset](#set_resultset)
* [set_include](#set_include)
* [set_key](#set_key)
* [set_keys](#set_keys)
* [set_fields](#set_fields)
* [set_session](#set_session)
* [set_inclusive_filters](#set_inclusive_filters)
* [set_exclusive_filters](#set_exclusive_filters)

#### clear

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

#### has_failed

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

#### has_fields

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

#### has_resultset

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

#### get_include

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
            
#### get_error_code

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
            
#### get_index

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

#### get_limit

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

#### get_resultset

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
        
#### get_fields

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
           
#### get_keys

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

#### get_session

``` C++
std::shared_ptr< restq::Session > get_session( void ) const;
```

Retrieves a smart-pointer of the client's [session](#session) attached to this query; see also [set_session](#set_session).

##### Parameters

n/a

##### Return Value
 
[std::shared_ptr](http://en.cppreference.com/w/cpp/memory/shared_ptr) reference to the client's network [session](#session), nullptr by default.

##### Exceptions

n/a 
            
#### get_inclusive_filters

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
     
#### get_exclusive_filters

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
            
#### set_error_code

``` C++
void set_error_code( const int value );
```

Replaces the contents of the query error status; see also [get_error_code](#get_error_code).

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   |     int     |      n/a      |

##### Return Value
 
n/a

##### Exceptions

n/a

#### set_index

``` C++
void set_index( const std::size_t start );
```

Replaces the contents of the index criteria; see also [get_index](#get_index).

The index criteria specifies an offset into the recordset to begin the query, i.e row number to start query at. In combination with [set_limit](#set_limit) paging is through records is possible.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   start   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) |      n/a      |

##### Return Value
 
n/a

##### Exceptions

n/a

#### set_limit

``` C++
void set_limit( const std::size_t stop );
```

Replaces the contents of the limit criteria; see also [set_limit](#set_limit).

The limit criteria specifies the number of records to be returned. In combination with [set_index](#set_index) paging is through records is possible.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   stop    | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) |      n/a      |

##### Return Value
 
n/a

##### Exceptions

n/a
 
#### set_resultset

``` C++
void set_resultset( const restq::Resources& values );
```

Replaces the contents of the query's resultset; see also [get_resultset](#get_resultset).

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   values   | [restq::Resources](#resourceresources) |      n/a      |

##### Return Value
 
n/a

##### Exceptions

n/a
 
#### set_include

``` C++
void set_include( const restq::Bytes& relationship );
```

Replaces the contents of the include critiera; see also [get_include](#get_include).

The include criteria represents a entity relationship between two or more records, i.e Weather a query for a queue should also return linked subscriptions.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   relationship   | [restq::Bytes](#bytebytes) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a  
            
#### set_keys

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

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [restq::Bytes](#bytebytes) | n/a           |
|   -   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   values   | [std::vector](http://en.cppreference.com/w/cpp/container/vector) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a 

#### set_fields

``` C++
void set_fields( const std::set< std::string >& values );
```

Replaces the contents of the query's fields criteria; see also [get_fields](#get_fields).

The fields search criteria indicates what fields (columns) from each record should be returned.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::set](http://en.cppreference.com/w/cpp/container/set) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a 
            
#### set_session

``` C++
void set_session( const std::set< std::string >& values );
```

Replaces the contents of the client session attached to this query; see also [set_session](#set_session).

Altering the client session property outside of the exchange will lead to undefined behaviour. It's made available to the repository so as to call Session::sleep_for while waiting for query results. 

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::set](http://en.cppreference.com/w/cpp/container/set) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a 

#### set_inclusive_filters

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

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   name   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   value   | [restq::Bytes](#bytebytes) | n/a           |
|   values   | [std::multimap](http://en.cppreference.com/w/cpp/container/multimap) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a 

#### set_exclusive_filters

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

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   name   | [std::string](http://en.cppreference.com/w/cpp/string/basic_string) | n/a           |
|   value   | [restq::Bytes](#bytebytes) | n/a           |
|   values   | [std::multimap](http://en.cppreference.com/w/cpp/container/multimap) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a 

### SSLSettings

Represents Secure Socket Layer service configuration.

#### Definition

``` C++
using SSLSettings = restbed::SSLSettings;
```

See [restbed::SSLSettings](https://github.com/corvusoft/restbed/documentation/API.md#sslsettings) for details.

### Settings

Represents the primary point of service, repository, and logger configuration. The mass majority of its implementation is inherited from [restbed::Settings](https://github.com/corvusoft/restbed/documentation/API.md#settings) with additional RestQ specific methods included and the following methods **removed**:

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

* [get_default_queue_message_limit](#get_default_queue_message_limit)
* [get_default_queue_message_size_limit](#get_default_queue_message_size_limit)
* [get_default_queue_subscription_limit](#get_default_queue_subscription_limit)
* [set_default_queue_message_limit](#set_default_queue_message_limit)
* [set_default_queue_message_size_limit](#set_default_queue_message_size_limit)
* [set_default_queue_subscription_limit](#set_default_queue_subscription_limit)

#### get_default_queue_message_limit

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

#### get_default_queue_message_size_limit

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
            
#### get_default_queue_subscription_limit

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

#### set_default_queue_message_limit

``` C++
void set_default_queue_message_limit( const std::size_t value );
```

Replaces the default message limit (100) given to a freshly created queue; see also [get_default_queue_message_limit](#get_default_queue_message_limit).

Internally this value is compared with the number of pending messages awaiting delivery for a particular queue. If this watermark is breached clients begin to receive the 503 (Service Unavailable) error status until messages have been successful dispatched. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a

#### set_default_queue_message_size_limit

``` C++
void set_default_queue_message_size_limit( const std::size_t value );
```

Replaces the default message size limit (1024 bytes) given to a freshly created queue; see also [get_default_queue_message_size_limit](#get_default_queue_message_size_limit).

When creating a new message on a queue this vaule is consulted and if breached clients will receive 413 (Request Entity Too Large) error response. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a           |

##### Return Value

n/a

##### Exceptions

n/a    
            
#### set_default_queue_subscription_limit

``` C++
void set_default_queue_subscription_limit( const std::size_t value );
```

Replaces the default subscription limit (25) given to a freshly created queue; see also [get_default_queue_subscription_limit](#get_default_queue_subscription_limit).

Internally this value is compared with the number of consumers currently subscribed to a queue, if breached clients see a  503 (Service Unavailable) error response. The default value can be overriden on an individual queue basis using the [network API](NETWORK-API.md).

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | [std::size_t](http://en.cppreference.com/w/cpp/types/size_t) | n/a           |

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
* [get_mime_type](#formatterget_mime_type)
* [set_logger](#formatterset_logger)

#### Formatter::parse

``` C++
virtual restq::Resources parse( const restq::Bytes& document ) = 0;
```

Parses a [restq::Byte](#bytebytes) sequence containing a document structure.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   document   | [restq::Byte](#bytebytes) | n/a           |

##### Return Value

Collection of decoded [restq::Resource](#resourceresources) entities. 

##### Exceptions

If an exception is thrown for any reason, the service will close the active client session with an appropriate HTTP error response.

#### Formatter::try_parse

``` C++
virtual bool try_parse( const restq::Bytes& document, restq::Resources& values ) noexcept = 0;
```

Exception safe parsing of a [restq::Byte](#bytebytes) sequence containing a document structure. The result of which is a collection of decoded [restq::Resource](#resourceresources) entities contained within the values parameter.

##### Parameters

| parameter |    type     | default value | direction |
|:---------:|:-----------:|:-------------:|:----------:
|   document   | [restq::Byte](#bytebytes) | n/a           | in |
|   values   | [restq::Resoures](#resourceresources) | n/a           | out |

##### Return Value

true if parsing was successful, false otherwise.

##### Exceptions

noexcept specification:  [noexcept](http://en.cppreference.com/w/cpp/language/noexcept_spec)



            virtual restq::Bytes compose( const restq::Resources& values, const bool styled = false ) = 0;
            virtual const std::string get_mime_type( void ) const = 0;
            virtual void set_logger( const std::shared_ptr< restq::Logger >& value ) = 0;


