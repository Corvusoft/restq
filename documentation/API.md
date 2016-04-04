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

Utiltiy class with static scope offering a common suite of string manipulation routines. Additional methods are inherited from restbed::String and will not be restated here for convenience.

#### Methods

``` C++
static bool is_integer( const std::string& value );
```

Parses a string and attemts to validate if it holds a representation of an integer value.

##### Parameters

| parameter |    type     | default value |
|:---------:|:-----------:|:-------------:|
|   value   | std::string | n/a           |

##### Return Value
 
boolean true if the argument is a string representation of an integer, otherwise false.
 
##### Exceptions

n/a
