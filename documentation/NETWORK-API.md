## Network API Overview

This document describes the available network endpoints for queue, subscription, and message management.

## URI Map

| Path                  |  Type       | Methods                          |
| --------------------- | ----------- | -------------------------------- |
| /queues               | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /queues/{uuid}        | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /subscriptions        | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /subscriptions/{uuid} | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /messages             | Collection  | POST, OPTIONS                    |
| /messages/{uuid}      | Resource    | OPTIONS                          |
| /*                    | Resource    | OPTIONS                          |

## RESTful Resources

All resources with the exception of Message and Collection entities may hold any number of generic properties presented to the exchange in a supported document format (JSON, YAML, XML). These properties are persisted in the repository and then made available to the query parameter discovery functionality. 

### Queue Collection

### Queue Resource

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

        
### Subscription Collection

### Subscription Resource

| Property            |   Type           | Description                                                                                    | Restriction   | Default Value   | Access        |
| ------------------- | :--------------: |----------------------------------------------------------------------------------------------- | :-----------: | :-------------: | :-----------: |
| type                | bytes            | Identifies the resource category.                                                              |  Internal     |  subscription   |  Read-Only    |
| created             | numeric          | Unix epoch holding creation timestamp.                                                         |  Internal     |    n/a          |  Read-Only    |
| modified            | numeric          | Unix epoch maintaining modification timestamp.                                                 |  Internal     |    n/a          |  Read-Only    |
| revision            | bytes            | Hash uniquely identifing this edition of the resource.                                         |  Internal     |    n/a          |  Read-Only    |
| origin              | string           | Originating address of the client responsible for creation.                                    |  Internal     |    n/a          |  Read-Only    |
| endpoint            | uri              | Uniform Resource Identifier detailing how to reach the subscription consumer.                  |  Mandatory    |    n/a          |  Read/Write   |


### Message Collection

### Message Resource

The HTTP Request body of a Message is not interpreted by the exchange and is forwarded without modification to subscribed consumers.  This allows any form for data to be sent across the wire e.g Text, Image, Binary.

### Asterisk Resource

The Asterisk (*) endpoint is to help aid monitoring of an exchange. This resource only accommodates the HTTP OPTIONS method. When probed it displays hardware load covering CPU, RAM, and Threads via HTTP headers CPU, Memory, and Workers respectively.

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
< Accept-Ranges: none
< Allow: OPTIONS
< Cache-Control: private,max-age=0,no-cache,no-store
< Connection: close
< Date: Fri, 01 Apr 2016 05:43:15 GMT
< Expires: 0
< Pragma: no-cache
* Server corvusoft/restq is not blacklisted
< Server: corvusoft/restq
< Uptime: 16991
< Vary: Accept,Accept-Encoding,Accept-Charset,Accept-Language
``` 

## Query Parameter Support

## HTTP Header Support

