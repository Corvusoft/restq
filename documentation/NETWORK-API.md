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

### Asterisk Resource
