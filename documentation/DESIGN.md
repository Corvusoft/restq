##Design Overview

### Scope

Unless otherwise specified all primary data-types originate within the Standard Template Library (STL). Including but not limited to string, map, list, multimap, set, any, and friends.

This document is primarily to aid communicating core architectural decisions and for this reason alone accuracy has suffered. It does not concern itself with API specifics and primarly focuses on architectrual desicions made during development, see API.md for contract detail.

pointers, references, etc.. are ommited.

Mention exchange State composition, private class pattern, etc...

Explain difference between RESTful resources and the resource data-type.

Relies heavily on Restbed for alot of data structures and will not redocument those cases here for convenience.

###

## Terminology

| Term            |  Definition   |
| --------------- | ------------- |
| Consumer        |   |
| Producer        |     |
| Exchange        |  |
| Subscription    |   |
| Queue           |     |
| Message         |             |
| Resource        |             |
| Formatter       |             |
| Repository      |             |
| Logger          |             |
| Encoder         |             |
| URI         |             |
| UUID         |             |
| Key         |             |
| Dispatch         |             |

## Network API

| Path                  |  Character  | Methods                          |
| --------------------- | ----------- | -------------------------------- |
| /queues               | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /queues/{uuid}        | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /subscriptions        | Collection  | GET, POST, HEAD, DELETE, OPTIONS |
| /subscriptions/{uuid} | Resource    | GET, PUT, HEAD, DELETE, OPTIONS  |
| /messages             | Collection  | POST, OPTIONS                    |
| /messages/{uuid}      | Resource    | OPTIONS                          |
| /*                    | Resource    | OPTIONS                          |

## Class Diagrams

All class definitions with the system strictly adhere to the [Opaque Pointer](https://en.wikipedia.org/wiki/Opaque_pointer) idioms. However this level of detail in the follow suite of class diagrams is ommited for clarity.

### Byte/Bytes

Byte represents an unsigned 16 bit data-type, with Bytes providing container functionality with STL std::vector semantics. 

```
+----------------+
|   <<typedef>>  |
|      Bytes     |
+----------------+
| vector< Byte > |
+--------@-------+
         |
         |
         |
+--------+-------+
|   <<typedef>>  |
|      Byte      |
+----------------+
|    uint16_t    |
+----------------+
```

### Resource/Resources

Resource represents an associative array allowing multiple duplicate key-value pairs. This type definition is the primary data-structure used throughout to represent RESTful resources.  Container functionality is provided via the Resources container having STL std::list semantics. 
```
+-----------------------+
|      <<typedef>>      |
|       Resources       |
+-----------------------+
|      list<Resource>   |
+-----------@-----------+
            |
            |
            |
+-----------+-----------+
|      <<typedef>>      |
|       Resource        |
+-----------------------+
| multimap<string,Byte> |
+-----------------------+
```

### Callback

Represents a functor with variable parameters and return; this is used to help illustrate the design without introducing unnecassary complexity.
```
+-----------------+
|    <<typedef>>  |
|     Callback    |
+-----------------+
|  std::function  |
+-----------------+
```

### LogLevel

Enumeration hinting at the level of priority to a particular log entry.
```
+--------------+
|   <<enum>>   |
|   LogLevel   |
+--------------+
| INFO         |
| DEBUG        |
| FATAL        |
| ERROR        |
| WARNING      |
| SECURITY     |
+--------------+
```

### StatusCode

Enumeration of HTTP response status codes as outlined in [RFC 7231 sub-section 6.1](https://tools.ietf.org/html/rfc7231#section-6.1). 
```
+---------------------------+
|         <<enum>>          |
|        StatusCode         |
+---------------------------+
| See RFC 7231 for details. |
+---------------------------+
```

### String

Utiltiy class with static scope offering a common suite of string manipulation routines. Additional methods are inherited from restbed::String and will not be restated here convenience and clarity.
```
+---------------------------------------+
|              <<static>>               |
|                String                 |
+---------------------------------------+
| + is_integer(string)          boolean |
| + is_boolean(string)          boolean |
| + is_fraction(string)         boolean |
| + trim( string,string)        string  |
| + trim_leading(string,string) string  |
| + trim_lagging(string,string) string  |
+---------------------------------------+
```

### URI

Represents a Uniform Resource Identifier as specificed in RFC 3986.

> A generic URI is of the form:
>
> scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

```
 +------------------------------------+ 
 |             <<class>>              | 
 |                Uri                 |
 +------------------------------------+
 | See restbed::Uri for details.      |
 +------------------------------------+
```

### Request

Represents a HTTP request with additional helper methods for minipulating data, and code readability.

```
 +------------------------------------+ 
 |             <<class>>              | 
 |              Response              |
 +------------------------------------+
 | See restbed::Response for details. |
 +------------------------------------+
```

### Response

Represents a HTTP response with additional helper methods for minipulating data, and code readability.

```
 +------------------------------------+ 
 |             <<class>>              | 
 |              Response              |
 +------------------------------------+
 | See restbed::Response for details. |
 +------------------------------------+
```

### Session

Represents a conversation between a producer and the exchange. Internally this class holds the network state and exposes public funcitionaly to interact with said state and the exchanges runloop for asynchronous data acquisation and/or sleep states, Only Authenticators and Repository developers require access to this functionality.

```
                     +-----------------------------------+
                     |             <<class>>             |
                     |              Session              |
                     +-----------------------------------+
                     | See restbed::Session for details. |
                     +-----------------@-----------------+
                                     1 | 1
                                       |
                    +------------------+-------------------+
                    |                                      |
                    |                                      | 
                  1 |                                      | 1
 +------------------+----------------+  +------------------+-----------------+ 
 |             <<class>>             |  |             <<class>>              | 
 |              Request              |  |              Response              |
 +-----------------------------------+  +------------------------------------+
 | See restbed::Request for details. |  | See restbed::Response for details. |
 +-----------------------------------+  +------------------------------------+
```

### Query

Represents a data store enquire for creating, reading, updating, and/or deleting resources.  This class is an implemention of the Parameter Object pattern, to increase code readability and extensiablilty during Repository interaction.

```
 +------------------------------------------------------------------------+
 |                                <<class>>                               |
 |                                  Query                                 |
 +------------------------------------------------------------------------+
 | + clear(void)                                   void                   |
 | + has_failed(void)                              boolean                |
 | + has_fields(void)                              boolean                |
 | + has_resultset(void)                           boolean                |
 | + get_include(void)                             Bytes                  |
 | + get_error_code(void)                          integer                |
 | + get_index(void)                               unsigned integer       |
 | + get_limit(void)                               unsigned integer       |
 | + get_resultset(void)                           Resources              |
 | + get_fields(void)                              set<string>            |
 | + get_keys(void)                                vector<string>         |
 | + get_session(void)                             Session                |
 | + get_inclusive_filters(void)                   multimap<string,Bytes> |
 | + get_exclusive_filters(void)                   multimap<string,Bytes> |
 | + set_error_code(integer)                       void                   |
 | + set_index(unsigned integer)                   void                   |
 | + set_limit(unsigned integer)                   void                   |
 | + set_resultset(Resources)                      void                   |
 | + set_include(Bytes)                            void                   |
 | + set_key(Bytes)                                void                   |
 | + set_key(string)                               void                   |
 | + set_keys(vector<string>)                      void                   |
 | + set_fields(set<string>)                       void                   |
 | + set_session(Session)                          void                   |
 | + set_inclusive_filter(string,Bytes)            void                   |
 | + set_inclusive_filters(multimap<string,Bytes>) void                   |
 | + set_exclusive_filter(string,Bytes)            void                   |
 | + set_exclusive_filters(multimap<string,Bytes>) void                   |
 +------------------------------------------------------------------------+
```

### SSLSettings

Represents Secure Socket Layer configuration for a exchange instance.

```
 +---------------------------------------+ 
 |               <<class>>               | 
 |              SSLSettings              |
 +---------------------------------------+
 | See restbed::SSLSettings for details. |
 +---------------------------------------+
```

### Settings

Represents the primary point of exchange, repository, and logger configuration.  The mass majority of its implementation is inherited from restbed::Settings with a few RestQ specific methods included and alterations of scope as detailed below.
```
 +----------------------------------------------------------------------------------+
 |                                     <<class>>                                    |
 |                                      Settings                                    |
 +----------------------------------------------------------------------------------+
 | + get_default_queue_message_limit(void)                  unsigned integer        |
 | + get_default_queue_message_size_limit(void)             unsigned integer        |
 | + get_default_queue_subscription_limit(void)             unsigned integer        |
 | + set_default_queue_message_limit(unsigned integer)      void                    |
 | + set_default_queue_message_size_limit(unsigned integer) void                    |
 | + set_default_queue_subscription_limit(unsigned integer) void                    | 
 | - get_case_insensitive_uris(void)                        boolean                 |
 | - get_property(string)                                   string                  |
 | - get_properties(void)                                   map<string,string>      |
 | - get_status_message(integer)                            string                  |
 | - get_status_messages(void)                              map<int,string>         |
 | - get_default_headers(void)                              multimap<string,string> |
 | - set_case_insensitive_uris(boolean)                     void                    |
 | - set_property(string,string)                            void                    |
 | - set_properties(map<string,string>)                     void                    |
 | - set_status_message(integer,string)                     void                    |
 | - set_status_messages(map<integer,string>)               void                    |
 | - set_default_header(string,string)                      void                    |
 | - set_default_headers(multimap<string,string>)           void                    |
 +-----------------------------------------@----------------------------------------+
                                           |
                                           |
                                           |
                       +-------------------+-------------------+ 
                       |               <<class>>               | 
                       |              SSLSettings              |
                       +---------------------------------------+
                       | See restbed::SSLSettings for details. |
                       +---------------------------------------+                        
```

### Formatter

Interface detailing the required contract for Formatter extensions. The concept of a format within RestQ is that of a document structure i.e JSON, XML, YAML, HTML.

```
 +------------------+---------------------+  
 |            <<interface>>               |
 |              Formatter                 | 
 +----------------------------------------+ 
 | + parse(Bytes)               Resources |
 | + try_parse(Bytes,Resources) boolean   |
 | + compose(Resources,boolean) Bytes     |
 | + get_mime_type(void)        string    |
 | + set_logger(Logger)         void      |
 +----------------------------------------+
```

### Repository

Interface detailing the required contract for repository extensions.  A repository represents a data-store for the long term persistence of dynamically created resources via the Network API (see above).

It is encouraged that any implementation of this interface be of an asynchronous nature to reduce thread locking within the exchange run-loop.  This can be achieved with both MySQL and PostgreSQL products.
```
 +-----------------------------------------+
 |             <<interface>>               |
 |               Repository                | 
 +-----------------------------------------+
 | + stop(void)                       void |
 | + start(Settings)                  void |
 | + create(Resources,Query,Callback) void |
 | + read(Query,Callback)             void |
 | + update(Resources,Query,Callback) void |
 | + destroy(Query,Callback)          void |
 | + set_logger(Logger)               void |
 +-----------------------------------------+
```

### Logger

Interface detailing the required contract for logger extensions.  No default logger is supplied with the code base and it is the responsibility of third-party developers to implement the desired characterics.

```
 +------------------------------------------+
 |             <<interface>>                |
 |                Logger                    |
 +------------------------------------------+
 | + stop(void)                        void |
 | + start(Settings)                   void |
 | + log(LogLevel,string)              void |
 | + log_if(condition,LogLevel,string) void |
 +------------------------------------------+
```

### Exchange

This my exchange description.

```
                                           +-----------------------------------------+
                                           |               <<class>>                 |
                                           |               Exchange                  |
                                           +-----------------------------------------+
                                           | + stop(void)                       void |
                                           | + start(Settings)                  void |
                                           | + restart(Settings)                void |
                                           | + add_format(string,Formatter)     void |
                                           | + set_logger(Logger)               void |
                                           | + set_repository(Repository)       void |
                                           | + set_ready_handler(Callback)      void |
                                           | + set_signal_handler(int,Callback) void |
                                           +---------------------O-------------------+
                                                                 |
                                                                 |
                    +--------------------------------------------+--------------------------------------------+
                    |                                            |                                            |
                    |                                            |                                            |
                    |                                            |                                            |
 +------------------+---------------------+  +-------------------+---------------------+  +------------------------------------------+
 |            <<interface>>               |  |             <<interface>>               |  |             <<interface>>                |
 |              Formatter                 |  |               Repository                |  |                Logger                    |
 +----------------------------------------+  +-----------------------------------------+  +------------------------------------------+
 | + parse(Bytes)               Resources |  | + stop(void)                       void |  | + stop(void)                        void |
 | + try_parse(Bytes,Resources) bool      |  | + start(Settings)                  void |  | + start(Settings)                   void |
 | + compose(Resources,bool)    Bytes     |  | + create(Resources,Query,Callback) void |  | + log(LogLevel,string)              void |
 | + get_mime_type(void)        string    |  | + read(Query,Callback)             void |  | + log_if(condition,LogLevel,string) void |
 | + set_logger(Logger)         void      |  | + update(Resources,Query,Callback) void |  |                                          |
 |                                        |  | + destroy(Query,Callback)          void |  |                                          |
 |                                        |  | + set_logger(Logger)               void |  |                                          |
 +----------------------------------------+  +-----------------------------------------+  +------------------------------------------+
```

## Sequence Diagrams

### Resource Creation

```
 [client]                                [exchange]            [formatter]         [repository]
    |                                         |                     '                    | 
    | Create (POST) resource.                 |                     '                    |
    |---------------------------------------->|                     '                    |
    |                                      +--|                     '                    |
    | Find formatter (Content-Type header).|  |                     '                    |
    |                                      +->|     Parse bytes.    |                    |
    |                                         |-------------------->|                    |
    |                                         |     Resources.      |                    | 
    |                                         |<--------------------|                    |
    |                                      +--|                     |                    |
    |           Validate & setup resource. |  |                     '                    |
    |                                      +->|                     '                    |
    |                                         |----------------------------------------->|
    |                                         |          Persist resource.               |
    |                                         |<-----------------------------------------|
    |                                      +--|                     '                    |
    |      Find formatter (Accept header). |  |                     '                    |
    |                                      +->|  Compose Resources. |                    |
    |                                         |-------------------->|                    |
    |                                         |        Bytes        |                    | 
    |           201 create status.            |<--------------------|                    | 
    |<----------------------------------------|                     '                    | 
    |                                         |                     '                    | 
```

### Resource Retrieval

```
 [client]                             [exchange]            [formatter]         [repository]
    |                                      |                     '                    | 
    | Read (GET) resource.                 |                     '                    |
    |------------------------------------->|                     '                    |
    |                                      |----------------------------------------->|
    |                                      |          Select resource(s).             |
    |                                      |<-----------------------------------------|
    |                                   +--|                     '                    |
    |   Find formatter (Accept header). |  |                     '                    |
    |                                   +->|  Compose Resources. |                    |
    |                                      |-------------------->|                    |
    |                                      |        Bytes.       |                    | 
    |           200 OK status.             |<--------------------|                    |
    |<-------------------------------------|                     '                    | 
    |                                      |                     '                    | 
```

### Resource Modification

```
 [client]                                [exchange]            [formatter]         [repository]
    |                                         |                     '                    | 
    |        Update (PUT) resource.           |                     '                    |
    |---------------------------------------->|                     '                    |
    |                                      +--|                     '                    |
    | Find formatter (Content-Type header).|  |                     '                    |
    |                                      +->|     Parse bytes.    |                    |
    |                                         |-------------------->|                    |
    |                                         |      Resources.     |                    | 
    |                                         |<--------------------|                    |
    |                                      +--|                     |                    |
    |           Validate & setup resource. |  |                     '                    |
    |                                      +->|                     '                    |
    |                                         |----------------------------------------->|
    |                                         |              Persist resource.           |
    |                                         |<-----------------------------------------|
    |                                      +--|                     '                    |
    |      Find formatter (Accept header). |  |                     '                    |
    |                                      +->|  Compose Resources. |                    |
    |                                         |-------------------->|                    |
    |                                         |        Bytes        |                    | 
    |           201 create status.            |<--------------------|                    |
    |<----------------------------------------|                     '                    | 
    |                                         |                     '                    | 
```

### Resource Destruction



### Exchange Setup, Message Dispatch and Successful Reciept

The following diagram details the sequence of events for configuring an exchange, message dispatch and successful reciept.

```
[producer]            [consumer]                [exchange]               [repository]
    |                     '                          |                         |
    |                     '                          |                         |          
    |          Create (POST /queues) queue.          |                         |
    |----------------------------------------------->|                         |
    |                     '                          |------------------------>|
    |                     '                          |      Persist queue.     |    
    |       201 created status and key (uuid).       |<------------------------|
    |<-----------------------------------------------|                         |
    |                     '                          |                         |
    |                     |                          |                         |
    |     Create (POST /subscriptions) subscription. |                         |
    |                     |------------------------->|                         |
    |                     |                          |------------------------>|
    |                     |                          |  Persist subscription.  |    
    |             201 created status and key (uuid). |<------------------------|
    |                     |<-------------------------|                         |
    |                     |                          |                         |
    |  Create (POST /queue/key/messages) message.    |                         |
    |----------------------------------------------->|                         |
    |                     |                          |------------------------>|
    |                     |                          |      Read queue(s).     |  
    |                     |                          |<------------------------|
    |                     |                      +---|                         |
    |            Test queue limits not breached. |   |                         |
    |                     |                      +-->|                         |
    |                     |                          |                         |
    |                     |                      +---|                         |
    |                  Schedule message dispatch.|   |                         |
    |                     |                      +-->|                         |
    |      202 accepted status and key (uuid).       |                         |
    |<-----------------------------------------------|                         |
    |                     |                          |------------------------>|
    |                     |                          |  Read subscription(s).  |    
    |                     | Dispatch message (POST). |<------------------------|    
    |                     |<-------------------------|                         |
    |                     |   202 accepted status.   |                         |
    |                     |------------------------->|                         |
    |                     |                          |------------------------>|
    |                     |                          |     Delete message.     |  
    |                     |                          |<------------------------|
    |                     |                          |                         |
```

### Message State

When a new message is delivered to the exchange it must be persisted with a range of information regarding the current setup of the system. This approach avoids the situation of Queue/Subscription modifications before the exchange has the oppurtunity to dispatch a message; which if left unattend would produce erratic behaviour on behalf of the dispatch routine.

To achieve this the exchange creates a single message record within the repository and then a collection of internal data-structures known as message states.  Each state records the message-key, queue, and subscription configuration.

For example: A queue with 2x subscriptions will force the exchange to instantiate 2x state objects snap-shooting a subscription and associated queue configuration.

While this approach duplicates data with respect to Queue and Subscription properties it has been deemed farless complicated and therefore prone to error than tracking changes between message creation and dispatch; disk is cheap.

Message state structures can hold one of the following conditions.

| Condition  |  Description                                               |
| ---------- | ---------------------------------------------------------- |
| pending    |  Message is awaiting delivery, that is exchange attention. |
| in-flight  |  Message is currently being processed by the exchange.     |    
| dispatched |  Message has been accepted by the consumer.                |
| rejected   |  Message was rejected by the consumer.                     |

A message and its associated states are not purged from the exchange until all state entites have recorded a dispatched or rejected condition.

```
[producer]            [consumer]                [exchange]               [repository]
    |                     '                          |                         |
```

## Further Reading

[Opaque Pointer](https://en.wikipedia.org/wiki/Opaque_pointer)

[Message Queue](https://en.wikipedia.org/wiki/Message_queue)

[Publish–subscribe pattern](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern)

[Uniform Resource Identifier (URI): Generic Syntax](https://tools.ietf.org/html/rfc3986).

[Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content](https://tools.ietf.org/html/rfc7231). 

[A Universally Unique IDentifier (UUID) URN Namespace](https://tools.ietf.org/html/rfc4122).
