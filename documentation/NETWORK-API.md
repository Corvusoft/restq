Network API Overview
--------------------

RestQ provides an open Hyper Text Transfer Protocol (HTTP) API for technology agnostic and language neutral message broking services. It is the intention to maintain a standards compliant interface as outlined in [RFC 7230](https://tools.ietf.org/html/rfc7230) and friends; see [Further Reading](#further-reading).

This document will describe the available [network endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) for [queue](#queue-resource), [subscription](#subscription-resource), and [message](#message-resource) management. For detailed examples of interacting with the network interface, please see the [acceptance test suite](https://github.com/Corvusoft/restq/tree/master/test/acceptance/features).

Interpretation
--------------

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

Table of Contents
-----------------

1.	[Overview](#network-api-overview)
2.	[Interpretation](#interpretation)
3.	[URI Map](#uri-map)
4.	[Restful Resources](#restful-resources)
5.	[Supported Query Parameters](#supported-query-parameters)
6.	[Supported HTTP Headers](#supported-http-headers)

URI Map
-------

Below is a table of available network [endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier). Requesting any other path will result in 404 (Not Found) response status code. If you perform a [Method](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) on an [endpoint](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) that lacks support, yet is available elsewhere in the exchange, you will receive a 405 (Method Not Allowed) status, otherwise a 501 (Method Not Implemented) status code is returned.

| Path                           | Type       | Methods                                                                                                       |
|--------------------------------|------------|---------------------------------------------------------------------------------------------------------------|
| /queues                        | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /queues/{uuid}                 | Resource   | [GET, PUT, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)  |
| /queues/{uuid}/messages        | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)                    |
| /queues/{uuid}/messages/{uuid} | Resource   | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)                          |
| /subscriptions                 | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /subscriptions/{uuid}          | Resource   | [GET, PUT, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)  |
| /messages                      | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)                    |
| /messages/{uuid}               | Resource   | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)                          |
| /\*                            | Resource   | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)                          |

RESTful Resources
-----------------

RestQ exports a REpresentational State Transfer (REST) API which relies on a stateless, client-server, and cacheable communications protocol. This is achieved over the [HTTP 1.1 standard](https://tools.ietf.org/html/rfc7230).

The framework implements [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations to present a clean consistent experience for the configuration of interrelated entities.

All resources, with the exception of Message and Collection entities, may hold any number of generic properties presented to the exchange in a supported document format (see [add_format](API.md#exchangeadd_format)). These properties are persisted in the repository and can then be used with the filter functionality to discover data-sources (Queues) of interest.

The exchange reserves a select number of property names for internal use and/or Queue/Subscription configuration. Altering these properties with invalid content will result in a 400 (Bad Request) error response status code.

### Resources

-	[Queue](#queue-resource)
-	[Queues](#queues-collection)
-	[Subscription](#subscription-resource)
-	[Subscriptions](#subscriptions-collection)
-	[Message](#message-resource)
-	[Messages](#messages-collection)
-	[Asterisk](#asterisk-resource)

#### Queue Resource

| Path           | Type     | Methods                                                                                                      |
|----------------|----------|--------------------------------------------------------------------------------------------------------------|
| /queues/{uuid} | Resource | [GET, PUT, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

The queue resource represents the desired configuration for a message chain.

| Property           | Type             | Description                                                                                    | Restriction | Default Value | Access     |
|--------------------|:----------------:|------------------------------------------------------------------------------------------------|:-----------:|:-------------:|:----------:|
| type               |      bytes       | Identifies the resource category.                                                              |  Internal   |     queue     | Read-Only  |
| created            |     numeric      | Unix epoch holding creation timestamp.                                                         |  Internal   |      n/a      | Read-Only  |
| modified           |     numeric      | Unix epoch maintaining modification timestamp.                                                 |  Internal   |      n/a      | Read-Only  |
| revision           |      bytes       | Hash uniquely identifing this edition of the resource.                                         |  Internal   |      n/a      | Read-Only  |
| origin             |      string      | Originating address of the client responsible for creation.                                    |  Internal   |      n/a      | Read-Only  |
| message-limit      | unsigned integer | Maximum number of messages allowed on a Queue before rejection (Bad Request).                  |  Optional   |      100      | Read/Write |
| message-size-limit | unsigned integer | Maximum allowed size in bytes of the message body before rejection (Request Entity Too Large). |  Optional   |     1024      | Read/Write |
| subscription-limit | unsigned integer | Maximum number of subscriptions allowed on a Queue before rejection (Bad Request).             |  Optional   |      25       | Read/Write |

#### Queues Collection

| Path    | Type       | Methods                                                                                                       |
|---------|------------|---------------------------------------------------------------------------------------------------------------|
| /queues | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e queues, offer collection semantics via [paging](#paging), [keys](#keys), and [filters](#filters) query parameters.

Collection resources have no associated data fields, and represent a collection of non-trival entities.

Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned; unless query parameters have been applied altering the default behaviour.

#### Subscription Resource

| Path                  | Type     | Methods                                                                                                      |
|-----------------------|----------|--------------------------------------------------------------------------------------------------------------|
| /subscriptions/{uuid} | Resource | [GET, PUT, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

The subscription resource represents the desired configuration for a message consumer.

| Property | Type    | Description                                                         | Restriction | Default Value | Access     |
|----------|:-------:|---------------------------------------------------------------------|:-----------:|:-------------:|:----------:|
| type     |  bytes  | Identifies the resource category.                                   |  Internal   | subscription  | Read-Only  |
| created  | numeric | Unix epoch holding creation timestamp.                              |  Internal   |      n/a      | Read-Only  |
| modified | numeric | Unix epoch maintaining modification timestamp.                      |  Internal   |      n/a      | Read-Only  |
| revision |  bytes  | Hash uniquely identifing this edition of the resource.              |  Internal   |      n/a      | Read-Only  |
| origin   | string  | Originating address of the client responsible for creation.         |  Internal   |      n/a      | Read-Only  |
| endpoint |   uri   | Uniform Resource Identifier describing how to contact the consumer. |  Mandatory  |      n/a      | Read/Write |

#### Subscriptions Collection

| Path           | Type       | Methods                                                                                                       |
|----------------|------------|---------------------------------------------------------------------------------------------------------------|
| /subscriptions | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e subscriptions, offer collection semantics via [paging](#paging), [keys](#keys), and [filters](#filters) query parameters.

Collection resources have no associated data fields, and represent a collection of non-trival entities.

Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned; unless query parameters have been applied altering the default behaviour.

#### Message Resource

| Path                           | Type     | Methods                                                                              |
|--------------------------------|----------|--------------------------------------------------------------------------------------|
| /messages/{uuid}               | Resource | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /queues/{uuid}/messages/{uuid} | Resource | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

The HTTP Request body of a Message is not interpreted by the exchange and is forwarded without modification to subscribed consumers. This allows any form for data to be sent across the wire e.g Text, Image, Binary.

#### Messages Collection

| Path                    | Type       | Methods                                                                                    |
|-------------------------|------------|--------------------------------------------------------------------------------------------|
| /messages               | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /queues/{uuid}/messages | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e messages, offer collection semantics via [paging](#paging), [keys](#keys), and [filters](#filters) query options.

Collection resources have no associated data fields, and represent a collection of non-trival entities.

#### Asterisk Resource

The Asterisk (*) [endpoint](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) is to help aid monitoring of an exchange. This resource only accommodates the HTTP OPTIONS method. When probed it displays load information covering CPU, RAM, Threads, and Uptime via HTTP headers CPU, Memory, Workers, and Uptime respectively.

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

Supported Query Parameters
--------------------------

| parameter | type      | range                                                                                    | Default               |
|-----------|:---------:|:----------------------------------------------------------------------------------------:|:---------------------:|
| filter    |  pair(s)  |                              one or more name=value pairs.                               |         null          |
| fields    | string(s) |                                   one or more strings.                                   | all available fields  |
| index     |  numeric  |                                0 - max(unsigned integer)                                 |           0           |
| limit     |  numeric  |                                0 - max(unsigned integer)                                 | max(unsigned integer) |
| echo      |  boolean  |                                 yes/no, true/false, 1/0                                  |         true          |
| style     |  boolean  |                                 yes/no, true/false, 1/0                                  |         false         |
| keys      | string(s) | one or more [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) strings. |         null          |

### Parameters

-	[Fields](#fields)
-	[Index](#index)
-	[Limit](#limit)
-	[Echo](#echo)
-	[Style](#style)
-	[Keys](#keys)
-	[Filters](#filters)

#### Fields

#### Index

#### Limit

#### Echo

#### Style

#### Keys

#### Filters

Supported HTTP Headers
----------------------

-	[Accept](https://tools.ietf.org/html/rfc7231#section-5.3.2)
-	[Accept-Charset](https://tools.ietf.org/html/rfc7231#section-5.3.3)
-	[Accept-Encoding](https://tools.ietf.org/html/rfc7231#section-5.3.4)
-	[Accept-Language](https://tools.ietf.org/html/rfc7231#section-5.3.5)
-	[Accept-Ranges](https://tools.ietf.org/html/rfc7233#section-2.3)
-	[Content-Encoding](https://tools.ietf.org/html/rfc7231#section-3.1.2.2)
-	[Content-Language](https://tools.ietf.org/html/rfc7231#section-3.1.3.2)
-	[Content-Length](https://tools.ietf.org/html/rfc7230#section-3.3.2)
-	[Content-MD5](https://tools.ietf.org/html/rfc1864)
-	[Content-Type](https://tools.ietf.org/html/rfc7231#section-3.1.1.5)
-	[Date](https://tools.ietf.org/html/rfc7231#section-7.1.1.2)
-	[ETag](https://tools.ietf.org/html/rfc7232#section-2.3)
-	[Expect](https://tools.ietf.org/html/rfc7231#section-5.1.1)
-	[Host](https://tools.ietf.org/html/rfc7230#section-5.4)
-	[Last-Modified](https://tools.ietf.org/html/rfc7232#section-2.2)
-	[Location](https://tools.ietf.org/html/rfc7231#section-7.1.2)
-	[Range](https://tools.ietf.org/html/rfc7233#section-3.1)

Further Reading
---------------

Original HTTP / 1.1 [RFC](https://www.w3.org/Protocols/rfc2616/rfc2616.html) is replaced by multipile RFCs (7230-7237):

[RFC7230](https://tools.ietf.org/html/rfc7230) - Message Syntax and Routing. An overview of HTTP architecture and its associated terminology, defines the "http" and "https" Uniform Resource Identifier (URI) schemes, defines the HTTP/1.1 message syntax and parsing requirements, and describes related security concerns for implementations.

[RFC7231](https://tools.ietf.org/html/rfc7231) - Semantics and Content. Defines the semantics of HTTP/1.1 messages, as expressed by request methods, request header fields, response status codes, and response header fields, along with the payload of messages (metadata and body content) and mechanisms for content negotiation.

[RFC7232](https://tools.ietf.org/html/rfc7232) - Conditional Requests. Defines HTTP/1.1 conditional requests, including metadata header fields for indicating state changes, request header fields for making preconditions on such state, and rules for constructing the responses to a conditional request when one or more preconditions evaluate to false.

[RFC7233](https://tools.ietf.org/html/rfc7233) - Range Requests. Defines range requests and the rules for constructing and combining responses to those requests.

[RFC7234](https://tools.ietf.org/html/rfc7234) - Caching. Defines HTTP caches and the associated header fields that control cache behavior or indicate cacheable response messages.

[RFC7235](https://tools.ietf.org/html/rfc7235) - Authentication. Defines the HTTP Authentication framework.

[RFC7236](https://tools.ietf.org/html/rfc7236) - Authentication Scheme Registrations. Registers Hypertext Transfer Protocol (HTTP) authentication schemes that have been defined in RFCs before the IANA HTTP Authentication Scheme Registry was established.

[RFC7237](https://tools.ietf.org/html/rfc7237) - Method Registrations. Registers those Hypertext Transfer Protocol (HTTP) methods that have been defined in RFCs before the IANA HTTP Method Registry was established.

[RFC6265](https://tools.ietf.org/html/rfc6265) - HTTP State Management Mechanism.
