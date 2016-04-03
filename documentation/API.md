##API Overview

### Document Scope

## Table of Contents  
1. [Document Scope](#example)
2. [Byte/Bytes](#bytes)
3. [Resource/Resources](#resources)
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

### Resource/Resources

#### Description

Resource represents an [associative array](http://en.cppreference.com/w/cpp/container/multimap) allowing multiple duplicate key-value pairs. This type definition is the primary data-structure used throughout to represent RESTful resources. Container functionality is provided via the Resources container having STL [list](http://en.cppreference.com/w/cpp/container/list) collection semantics.

#### Definition

``` C++
typedef std::multimap< std::string, Bytes > Resource;
    
typedef std::list< Resource > Resources;
```
