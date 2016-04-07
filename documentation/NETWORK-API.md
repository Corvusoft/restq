## Network API Overview

RestQ provides an open Hyper Text Transfer Protocol (HTTP) API for technology agnostic and language neutral message broking services. It is the intention to maintain a standards compliant interface as outlined in [RFC 7230](https://tools.ietf.org/html/rfc7230).

This document will describe the available network endpoints for queue, subscription, and message management.  For detailed examples of interacting with the network interface please see the [acceptance test suite](https://github.com/Corvusoft/restq/tree/master/test/acceptance/features).

## Interpretation
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

## URI Map

Below is a table of available network endpoints. Requesting any other path will result in 404 (Not Found) response status code. If you perform a Method on an endpoint that lacks support, yet is available elsewhere in the exchange, you will recieve a 405 (Method Not Allowed) status, otherwise a 501 (Method Not Implemented) status code is returned.

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /queues                        | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /queues/{uuid}                 | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /queues/{uuid}/messages        | Collection  | POST, OPTIONS                    |
| /queues/{uuid}/messages/{uuid} | Resource    | OPTIONS                          |
| /subscriptions                 | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /subscriptions/{uuid}          | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /messages                      | Collection  | POST, OPTIONS                    |
| /messages/{uuid}               | Resource    | OPTIONS                          |
| /*                             | Resource    | OPTIONS                          |

## RESTful Resources

RestQ exports a REpresentational State Transfer (REST) API which relies on a stateless, client-server, and cacheable communications protocol. This is achieved over the [HTTP 1.1 standard](https://tools.ietf.org/html/rfc7230).

The framework implements [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations to present a clean consistent experience for the configuration of interrelated entities.

All resources, with the exception of Message and Collection entities, may hold any number of generic properties presented to the exchange in a supported document format (see [add_format](API.md#exchangeadd_format)). These properties are persisted in the repository and can then be used with the filter functionality to discover data-sources (Queues) of interest.

Within the exchange a select number of property names are reserved for internal use and/or Queue/Subscription configuration. Altering these properties with invalid content will result in a 400 (Bad Request) error response status code.

### Queues Collection

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /queues                        | Collection  | GET, POST, HEAD, DELETE, OPTIONS |

Endpoints identified by a pluralised resource name, i.e queues, offer collection semantics via the network interface's [paging](#paging), [keys](#keys), and [filters](#filters) query options.

Collection resources have no associated data fields, and merely represent a collection of other non-trival objects (e.g a queue). Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned, unless query parameters have been set to alter the default behaviour.

### Queue Resource

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /queues/{uuid}                 | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |

The queue resource represents the desired configuration for a message chain.

| Property            |   Type           | Description                                                                                    | Restriction   | Default Value   | Access        |
| ------------------- | :--------------: |----------------------------------------------------------------------------------------------- | :-----------: | :-------------: | :-----------: |
| type                | bytes            | Identifies the resource category.                                                              |  Internal     |  queue          |  Read-Only    |
| created             | numeric          | Unix epoch holding creation timestamp.                                                         |  Internal     |    n/a          |  Read-Only    |
| modified            | numeric          | Unix epoch maintaining modification timestamp.                                                 |  Internal     |    n/a          |  Read-Only    |
| revision            | bytes            | Hash uniquely identifing this edition of the resource.                                         |  Internal     |    n/a          |  Read-Only    |
| origin              | string           | Originating address of the client responsible for creation.                                    |  Internal     |    n/a          |  Read-Only    |
| message-limit       | unsigned integer | Maximum number of messages allowed on a Queue before rejection (Bad Request).                  |  Optional     |    100          |  Read/Write   |
| message-size-limit  | unsigned integer | Maximum allowed size in bytes of the message body before rejection (Request Entity Too Large). |  Optional     |    1024         |  Read/Write   |
| subscription-limit  | unsigned integer | Maximum number of subscriptions allowed on a Queue before rejection (Bad Request).             |  Optional     |     25          |  Read/Write   |

        
### Subscriptions Collection

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /subscriptions                 | Collection  | GET, POST, HEAD, DELETE, OPTIONS |

Endpoints identified by a pluralised resource name, i.e subscriptions, offer collection semantics via the network interface's [paging](#paging), [keys](#keys), and [filters](#filters) query options.

Collection resources have no associated data fields, and merely represent a collection of other non-trival objects (e.g a subscription). Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned, unless query parameters have been set to alter the default behaviour.

### Subscription Resource

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /subscriptions/{uuid}          | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |

The subscription resource represents the desired configuration for a message consumer.

| Property            |   Type           | Description                                                                                    | Restriction   | Default Value   | Access        |
| ------------------- | :--------------: |----------------------------------------------------------------------------------------------- | :-----------: | :-------------: | :-----------: |
| type                | bytes            | Identifies the resource category.                                                              |  Internal     |  subscription   |  Read-Only    |
| created             | numeric          | Unix epoch holding creation timestamp.                                                         |  Internal     |    n/a          |  Read-Only    |
| modified            | numeric          | Unix epoch maintaining modification timestamp.                                                 |  Internal     |    n/a          |  Read-Only    |
| revision            | bytes            | Hash uniquely identifing this edition of the resource.                                         |  Internal     |    n/a          |  Read-Only    |
| origin              | string           | Originating address of the client responsible for creation.                                    |  Internal     |    n/a          |  Read-Only    |
| endpoint            | uri              | Uniform Resource Identifier detailing how to reach the subscription consumer.                  |  Mandatory    |    n/a          |  Read/Write   |


### Messages Collection

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /messages                      | Collection  | POST, OPTIONS                    |
| /queues/{uuid}/messages        | Collection  | POST, OPTIONS                    |

Endpoints identified by a pluralised resource name, i.e subscriptions, offer collection semantics via the network interface's [paging](#paging), [keys](#keys), and [filters](#filters) query options.

Collection resources have no associated data fields, and merely represent a collection of other non-trival objects (e.g a subscription). Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned, unless query parameters have been set to alter the default behaviour.

### Message Resource

| Path                           |  Type       | Methods                          |
| ------------------------------ | ----------- | -------------------------------- |
| /messages/{uuid}               | Resource    | OPTIONS                          |
| /queues/{uuid}/messages/{uuid} | Resource    | OPTIONS                          |

The HTTP Request body of a Message is not interpreted by the exchange and is forwarded without modification to subscribed consumers.  This allows any form for data to be sent across the wire e.g Text, Image, Binary.

### Asterisk Resource

The Asterisk (*) endpoint is to help aid monitoring of an exchange. This resource only accommodates the HTTP OPTIONS method. When probed it displays hardware load covering CPU, RAM, Threads, and Runtime via HTTP headers CPU, Memory, Workers, and Uptime respectively.

```
> OPTIONS /* HTTP/1.1
> User-Agent: curl/7.35.0
> Host: localhost:1984
> Accept: */*
> 
< HTTP/1.1 204 No Content
< CPU: 3.0%
< Memory: 68.1%
< Workers: 1
< Uptime: 16991
< Date: Fri, 01 Apr 2016 05:43:15 GMT
< Accept-Ranges: none
< Allow: OPTIONS
< Cache-Control: private,max-age=0,no-cache,no-store
< Connection: close
< Expires: 0
< Pragma: no-cache
< Server: corvusoft/restq
< Vary: Accept,Accept-Encoding,Accept-Charset,Accept-Language
``` 

## Query Parameter Support

| parameter |   Type     | Range                        | Default Value         |
| --------- | :--------: | :--------------------------: | :-------------------: |
| filter    | pair(s)    | one or more name=value pairs.|  null                 |
| fields    | string(s)  | one or more strings.         |  all available fields |
| index     | numeric    | 0 - max(unsigned integer)    |  0                    |
| limit     | numeric    | 0 - max(unsigned integer)    |  max(unsigned integer)|
| echo      | boolean    | yes/no, true/false, 1/0      |  true                 |
| style     | boolean    | yes/no, true/false, 1/0      |  false                |
| keys      | string(s)  | one or more UUID strings.    |  null                 |

### Filter

### Fields

### Index

### Limit

### Echo

### Style

### Keys

## HTTP Header Support

### Accept-Charset
### Accept-Encoding
### Accept-Language
### Accept-Ranges
### Accept
### Content-Encoding
### Content-Language
### Content-Length
### Content-MD5
### Content-Type
### Date
### ETag
### Expect
### Host
### Last-Modified
### Location
### Range
