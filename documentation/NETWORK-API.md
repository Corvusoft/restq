Overview
--------

RestQ provides an open Hyper Text Transfer Protocol (HTTP) API for technology agnostic and language neutral message broking services. It is the intention to maintain a standards compliant interface as outlined in [RFC 7230](https://tools.ietf.org/html/rfc7230) and friends; see [Further Reading](#further-reading).

This document will describe the available [network endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) for [queue](#queue-resource), [subscription](#subscription-resource), and [message](#message-resource) management. For detailed examples of interacting with the network interface, please see the [acceptance test suite](https://github.com/Corvusoft/restq/tree/master/test/acceptance/features).

Interpretation
--------------

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

Table of Contents
-----------------

1.	[Overview](#overview)
2.	[Interpretation](#interpretation)
3.	[URI Map](#uri-map)
4.	[Restful Resources](#restful-resources)
5.	[Supported Query Parameters](#supported-query-parameters)
6.	[Supported HTTP Headers](#supported-http-headers)
7.	[Further Reading](#further-reading)

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

All resources, with the exception of Message and Collection entities, may hold any number of generic properties presented to the exchange in a supported document format (see [add_format](API.md#exchangeadd_format)). These properties are persisted in the repository and can then be used with the [filters](#filters) functionality to discover entities of interest.

The exchange reserves a select number of property names for internal use and Queue/Subscription configuration. Altering these properties with invalid content will result in a 400 (Bad Request) error response status code.

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

| Property              | Type             | Description                                                                                                 | Restriction | Default Value | Access     |
|-----------------------|:----------------:|-------------------------------------------------------------------------------------------------------------|:-----------:|:-------------:|:----------:|
| type                  |      bytes       | Identifies the resource category.                                                                           |  Reserved   |     queue     | Read-Only  |
| created               |     numeric      | Unix epoch holding creation timestamp.                                                                      |  Reserved   |      n/a      | Read-Only  |
| modified              |     numeric      | Unix epoch maintaining modification timestamp.                                                              |  Reserved   |      n/a      | Read-Only  |
| revision              |      bytes       | Hash uniquely identifying this edition of the resource.                                                     |  Reserved   |      n/a      | Read-Only  |
| origin                |      string      | Originating address of the client responsible for creation.                                                 |  Reserved   |      n/a      | Read-Only  |
| pattern               |      string      | Indicates the Queues message paradigm.                                                                      |  Reserved   |    pub-sub    | Read-Only  |
| message-limit         | unsigned integer | Maximum number of messages allowed on a Queue before rejection (Bad Request).                               |  Optional   |      100      | Read/Write |
| message-size-limit    | unsigned integer | Maximum allowed size in bytes of the message body before rejection (Request Entity Too Large).              |  Optional   |     1024      | Read/Write |
| subscription-limit    | unsigned integer | Maximum number of subscriptions allowed on a Queue before rejection (Bad Request).                          |  Optional   |      25       | Read/Write |
| max-delivery-attempts | unsigned integer | Maximum number of delivery attempts the exchange will make before setting the message state to UNREACHABLE. |  Optional   |       3       | Read/Write |


#### Queues Collection

| Path    | Type       | Methods                                                                                                       |
|---------|------------|---------------------------------------------------------------------------------------------------------------|
| /queues | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e queues, offer collection semantics via [paging](#paging), [keys](#keys), [index](#index), [limit](#limit) and [filter](#filters) query parameters.

Collection resources have no associated data fields, and represent a grouping of non-trival entities.

Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned; unless query parameters have been applied, altering the default behaviour.

#### Subscription Resource

| Path                  | Type     | Methods                                                                                                      |
|-----------------------|----------|--------------------------------------------------------------------------------------------------------------|
| /subscriptions/{uuid} | Resource | [GET, PUT, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

The subscription resource represents the desired configuration for a message consumer.

| Property | Type    | Description                                                         | Restriction | Default Value | Access     |
|----------|:-------:|---------------------------------------------------------------------|:-----------:|:-------------:|:----------:|
| type     |  bytes  | Identifies the resource category.                                   |  Reserved   | subscription  | Read-Only  |
| created  | numeric | Unix epoch holding creation timestamp.                              |  Reserved   |      n/a      | Read-Only  |
| modified | numeric | Unix epoch maintaining modification timestamp.                      |  Reserved   |      n/a      | Read-Only  |
| revision |  bytes  | Hash uniquely identifying this edition of the resource.             |  Reserved   |      n/a      | Read-Only  |
| origin   | string  | Originating address of the client responsible for creation.         |  Reserved   |      n/a      | Read-Only  |
| endpoint |   uri   | Uniform Resource Identifier describing how to contact the consumer. |  Mandatory  |      n/a      | Read/Write |

#### Subscriptions Collection

| Path           | Type       | Methods                                                                                                       |
|----------------|------------|---------------------------------------------------------------------------------------------------------------|
| /subscriptions | Collection | [GET, POST, HEAD, DELETE, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e subscriptions, offer collection semantics via [paging](#paging), [keys](#keys), [index](#index), [limit](#limit) and [filter](#filters) query parameters.

Collection resources have no associated data fields, and represent a grouping of non-trival entities.

Reading ([HTTP GET](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)) a collection will result in all available resources being returned; unless query parameters have been applied, altering the default behaviour.

#### Message Resource

| Path                           | Type     | Methods                                                                              |
|--------------------------------|----------|--------------------------------------------------------------------------------------|
| /messages/{uuid}               | Resource | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /queues/{uuid}/messages/{uuid} | Resource | [OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

The HTTP Request body of a Message is not interpreted by the exchange and is forwarded without modification to subscribed consumers. This allows any form of data to be sent across the wire e.g Text, Image, Binary.

#### Messages Collection

| Path                    | Type       | Methods                                                                                    |
|-------------------------|------------|--------------------------------------------------------------------------------------------|
| /messages               | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |
| /queues/{uuid}/messages | Collection | [POST, OPTIONS](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) |

[Endpoints](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) identified by pluralised resource names, i.e messages, offer collection semantics via [paging](#paging), [keys](#keys), [index](#index), [limit](#limit) and [filter](#filters) query parameters.

Collection resources have no associated data fields, and represent a grouping of non-trival entities.

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

-	[Fields](#fields)
-	[Index](#index)
-	[Limit](#limit)
-	[Echo](#echo)
-	[Style](#style)
-	[Keys](#keys)
-	[Filters](#filters)

#### Fields

| name   | type      | range                | Default              |
|--------|:---------:|:--------------------:|:--------------------:|
| fields | string(s) | one or more strings. | all available fields |

The fields query parameter helps reduce network load by allowing the client to return only the required properties from one or more entities.

```
https://exchange/queues/123e4567-e89b-12d3-a456-426655440000?fields=name,tags
```

#### Index

| name  | type    | range                     | Default |
|-------|:-------:|:-------------------------:|:-------:|
| index | numeric | 0 - max(unsigned integer) |    0    |

The index query parameter allows for accessing into a collection and fetching only the desired entities, helping reduce redundant data processing and transmission.

```
https://exchange/queues?index=3
```

#### Limit

| name  | type    | range                     | Default               |
|-------|:-------:|:-------------------------:|:---------------------:|
| limit | numeric | 0 - max(unsigned integer) | max(unsigned integer) |

If you need only a specified number of entities from a collection, use the limit query parameter, rather than fetching the whole collection and throwing away the redundant data.

```
https://exchange/queues?limit=10
```

#### Echo

| name | type    | range                   | Default |
|------|:-------:|:-----------------------:|:-------:|
| echo | boolean | yes/no, true/false, 1/0 |  true   |

In scenarios where you're not interested in the result of an operation you may supply the echo query parameter to remove the response body; reducing redundant data transmission.

```
https://exchange/queues?echo=false
```

#### Style

| name  | type    | range                   | Default |
|-------|:-------:|:-----------------------:|:-------:|
| style | boolean | yes/no, true/false, 1/0 |  false  |

During debugging its handy to present a human friendly response format. Providing a style query parameter allows formatters (JSON, XML, YAML) to present a response body that is easily consumed by humans.

```
https://exchange/queues?style=true
```

#### Keys

| name | type      | range                                                                                    | Default |
|------|:---------:|:----------------------------------------------------------------------------------------:|:-------:|
| keys | string(s) | one or more [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) strings. |  null   |

To select specific entities from a collection you may set the keys query parameter.

```
https://exchange/queues?keys=e287ab8c-2537-4fca-8a78-bd632853ae96,abd244fe-e974-49a3-b2f8-1fda83b215c6
```

This approach allows for the creation of Virtual Collections. Whereby all other query parameters are applied on top of the keys specified.

```
https://exchange/queues?keys=e287ab8c-2537-4fca-8a78-bd632853ae96,abd244fe-e974-49a3-b2f8-1fda83b215c6&tags=disk-usage&index=0&limit=2
```

#### Filters

| name   | type    | range                         | Default |
|--------|:-------:|:-----------------------------:|:-------:|
| filter | pair(s) | one or more name=value pairs. |  null   |

If you desire to discover entities with specific field values, filters may be set to weed out irrelevant data.

The following should be read as: Read all queues that contain both the 'rain' *AND* 'weather' tag.

```
https://exchange/queues?tags=rain,weather
```

Another example: Read all queues with a tag of 'weather' and a supplier of 'MET Office'.

```
https://exchange/queues?tags=weather&supplier=MET%20Office
```

Supported HTTP Headers
----------------------

-	[Accept](#accept)
-	[Accept-Charset](#accept-charset)
-	[Accept-Encoding](#accept-encoding)
-	[Accept-Language](#accept-language)
-	[Accept-Ranges](#accept-ranges)
-	[Content-Encoding](#content-encoding)
-	[Content-Language](#content-language)
-	[Content-Length](#content-length)
-	[Content-MD5](#content-md5)
-	[Content-Type](#content-type)
-	[Date](#date)
-	[ETag](#etag)
-	[Expect](#expect)
-	[Host](#host)
-	[Last-Modified](#last-modified)
-	[Location](#location)
-	[Range](#range)

#### Accept

The "[Accept](https://tools.ietf.org/html/rfc7231#section-5.3.2)" header field can be used by user agents to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.

#### Accept-Charset

The "[Accept-Charset](https://tools.ietf.org/html/rfc7231#section-5.3.3)" header field can be sent by a user agent to indicate what charsets are acceptable in textual response content. This field allows user agents capable of understanding more comprehensive or special-purpose charsets to signal that capability to an origin server that is capable of representing information in those charsets.

#### Accept-Encoding

The "[Accept-Encoding](https://tools.ietf.org/html/rfc7231#section-5.3.4)" header field can be used by user agents to indicate what response content-codings (Section 3.1.2.1) are acceptable in the response. An "identity" token is used as a synonym for "no encoding" in order to communicate when no encoding is preferred.

#### Accept-Language

The "[Accept-Language](https://tools.ietf.org/html/rfc7231#section-5.3.5)" header field can be used by user agents to indicate the set of natural languages that are preferred in the response.

#### Accept-Ranges

The "[Accept-Ranges](https://tools.ietf.org/html/rfc7233#section-2.3)" header field allows a server to indicate that it supports range requests for the target resource.

#### Content-Encoding

The "[Content-Encoding](https://tools.ietf.org/html/rfc7231#section-3.1.2.2)" header field indicates what content codings have been applied to the representation, beyond those inherent in the media type, and thus what decoding mechanisms have to be applied in order to obtain data in the media type referenced by the Content-Type header field. Content-Encoding is primarily used to allow a representation's data to be compressed without losing the identity of its underlying media type.

#### Content-Language

The "[Content-Language](https://tools.ietf.org/html/rfc7231#section-3.1.3.2)" header field describes the natural language(s) of the intended audience for the representation. Note that this might not be equivalent to all the languages used within the representation.

#### Content-Length

When a message does not have a Transfer-Encoding header field, a [Content-Length](https://tools.ietf.org/html/rfc7230#section-3.3.2) header field can provide the anticipated size, as a decimal number of octets, for a potential payload body. For messages that do include a payload body, the Content-Length field-value provides the framing information necessary for determining where the body (and message) ends. For messages that do not include a payload body, the Content-Length indicates the size of the selected representation.

#### Content-MD5

The [Content-MD5](https://tools.ietf.org/html/rfc1864) entity-header field, as defined in RFC 1864, is an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) of the entity-body. (Note: a MIC is good for detecting accidental modification of the entity-body in transit, but is not proof against malicious attacks.)

#### Content-Type

The "[Content-Type](https://tools.ietf.org/html/rfc7231#section-3.1.1.5)" header field indicates the media type of the associated representation: either the representation enclosed in the message payload or the selected representation, as determined by the message semantics. The indicated media type defines both the data format and how that data is intended to be processed by a recipient, within the scope of the received message semantics, after any content codings indicated by Content-Encoding are decoded.

#### Date

The "[Date](https://tools.ietf.org/html/rfc7231#section-7.1.1.2)" header field represents the date and time at which the message was originated, having the same semantics as the Origination Date Field (orig-date) defined in Section 3.6.1 of [RFC5322]. The field value is an HTTP-date, as defined in Section 7.1.1.1.

#### ETag

The "[ETag](https://tools.ietf.org/html/rfc7232#section-2.3)" header field in a response provides the current entity-tag for the selected representation, as determined at the conclusion of handling the request. An entity-tag is an opaque validator for differentiating between multiple representations of the same resource, regardless of whether those multiple representations are due to resource state changes over time, content negotiation resulting in multiple representations being valid at the same time, or both. An entity-tag consists of an opaque quoted string, possibly prefixed by a weakness indicator.

#### Expect

The "[Expect](https://tools.ietf.org/html/rfc7231#section-5.1.1)" header field in a request indicates a certain set of behaviors (expectations) that need to be supported by the server in order to properly handle this request. The only such expectation defined by this specification is 100-continue.

#### Host

The "[Host](https://tools.ietf.org/html/rfc7230#section-5.4)" header field in a request provides the host and port information from the target URI, enabling the origin server to distinguish among resources while servicing requests for multiple host names on a single IP address.

#### Last-Modified

The "[Last-Modified](https://tools.ietf.org/html/rfc7232#section-2.2)" header field in a response provides a timestamp indicating the date and time at which the origin server believes the selected representation was last modified, as determined at the conclusion of handling the request.

#### Location

The "[Location](https://tools.ietf.org/html/rfc7231#section-7.1.2)" header field is used in some responses to refer to a specific resource in relation to the response. The type of relationship is defined by the combination of request method and status code semantics.

#### Range

The "[Range](https://tools.ietf.org/html/rfc7233#section-3.1)" header field on a GET request modifies the method semantics to request transfer of only one or more subranges of the selected representation data, rather than the entire selected representation data.

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
