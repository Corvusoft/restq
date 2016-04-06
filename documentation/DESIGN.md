##Design Overview

### Document Scope

This document is intented to communicate core architectural decisions within the system. For this reason alone accuracy has suffered. It does not concern itself with interface specifics and primarly focuses on architectrual decisions made during the design/development phase, see [Network API](NETWORK-API.md) and [API](API.md) for entity contract details.

All class definitions within the system strictly adhere to the [Opaque Pointer](https://en.wikipedia.org/wiki/Opaque_pointer) idiom. However, this level of detail in the follow suite of class diagrams is ommited for clarity; along with pointers, references and other background noise.

Unless otherwise specified all primary data-types originate within the Standard Template Library (STL). Including but not limited to string, map, list, multimap, set, any, and friends.

RestQ relies heavily on the [Restbed](https://github.com/corvusoft/restbed) framework for it's data structures and they will not be redocumented here for convenience.

## Interpretation
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

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

## System Entities

### Byte/Bytes

Byte represents an unsigned 8-bit wide data-type, Bytes provides container functionality with STL [vector](http://en.cppreference.com/w/cpp/container/vector) collection semantics. 

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
|     uint8_t    |
+----------------+
```

### Resource/Resources

Resource represents an [associative array](http://en.cppreference.com/w/cpp/container/multimap) allowing multiple duplicate key-value pairs. This type definition is the primary data-structure used throughout to represent RESTful resources. Container functionality is provided via the Resources container having STL [list](http://en.cppreference.com/w/cpp/container/list) collection semantics.
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
|   <<typedef>>   |
|    Callback     |
+-----------------+
|  std::function  |
+-----------------+
```

### Logger::Level

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) used in conjuction with the [Logger interface](#logger) to detail the level of severity towards a particular log entry.
```
+---------------+
|   <<enum>>    |
| Logger::Level |
+---------------+
| INFO          |
| DEBUG         |
| FATAL         |
| ERROR         |
| WARNING       |
| SECURITY      |
+---------------+
```

### StatusCode

[Enumeration](http://en.cppreference.com/w/cpp/language/enum) of HTTP response status codes as outlined in [RFC 7231 sub-section 6.1](https://tools.ietf.org/html/rfc7231#section-6.1).
```
+---------------------------+
|         <<enum>>          |
|        StatusCode         |
+---------------------------+
| See RFC 7231 for details. |
+---------------------------+
```

### String

Utility class with static scope offering a common suite of string manipulation routines. Additional methods are inherited from restbed::String and will not be restated here for convenience.
```
+---------------------------------------+
|              <<static>>               |
|                String                 |
+---------------------------------------+
| + is_integer(string)          boolean |
| + is_boolean(string)          boolean |
| + is_fraction(string)         boolean |
| + trim(string,string)         string  |
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

Represents a HTTP response with additional helper methods for minipulating data, and improving code readability.

```
 +------------------------------------+ 
 |             <<class>>              | 
 |              Response              |
 +------------------------------------+
 | See restbed::Response for details. |
 +------------------------------------+
```

### Session

Represents a conversation between a client and the service. Internally this class holds the network state and exposes public functionality to interact with the exchanges runloop for asynchronous data acquisation and/or sleep states, Only Authenticators and Repository developers require access to this functionality.

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

Represents a data store enquire for creating, reading, updating, and/or deleting resources.  This class is an implemention of the [Parameter Object](http://c2.com/cgi/wiki?ParameterObject) pattern allowing for greater extensiablilty during Repository interaction.

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

Represents Secure Socket Layer service configuration.

```
 +---------------------------------------+ 
 |               <<class>>               | 
 |              SSLSettings              |
 +---------------------------------------+
 | See restbed::SSLSettings for details. |
 +---------------------------------------+
```

### Settings

Represents the primary point of service, repository, and logger configuration. The mass majority of its implementation is inherited from restbed::Settings with a additional RestQ specific methods included and alterations of scope as detailed below.
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

Interface detailing the required contract for Format extensions. The concept of a format within RestQ is that of a document structure i.e JSON, XML, YAML, HTML.

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

Interface detailing the required contract for repository extensions. A repository represents a data-store for the long term persistence of dynamically created resources via the [Network API](#NETWORK-API.md).

It is encouraged that any implementation of this interface **SHOULD** be of an asynchronous nature, to reduce thread contention within the exchange. This can be achieved with MySQL, PostgreSQL, and other database products.
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

Interface detailing the required contract for logger extensions.  No default logger is supplied with the codebase and it is the responsibility of third-party developers to implement the desired characterics.

```
 +-----------------------------------------------+
 |                 <<interface>>                 |
 |                    Logger                     |
 +-----------------------------------------------+
 | + stop(void)                             void |
 | + start(Settings)                        void |
 | + log(Logger::Level,string)              void |
 | + log_if(condition,Logger::Level,string) void |
 +-----------------------------------------------+
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
                    +--------------------------------------------+------------------------------------------------+
                    |                                            |                                                |
                    |                                            |                                                |
                    |                                            |                                                |
 +------------------+---------------------+  +-------------------+---------------------+  +-----------------------------------------------+
 |            <<interface>>               |  |             <<interface>>               |  |                 <<interface>>                 |
 |              Formatter                 |  |               Repository                |  |                    Logger                     |
 +----------------------------------------+  +-----------------------------------------+  +-----------------------------------------------+
 | + parse(Bytes)               Resources |  | + stop(void)                       void |  | + stop(void)                             void |
 | + try_parse(Bytes,Resources) bool      |  | + start(Settings)                  void |  | + start(Settings)                        void |
 | + compose(Resources,bool)    Bytes     |  | + create(Resources,Query,Callback) void |  | + log(Logger::Level,string)              void |
 | + get_mime_type(void)        string    |  | + read(Query,Callback)             void |  | + log_if(condition,Logger::Level,string) void |
 | + set_logger(Logger)         void      |  | + update(Resources,Query,Callback) void |  |                                               |
 |                                        |  | + destroy(Query,Callback)          void |  |                                               |
 |                                        |  | + set_logger(Logger)               void |  |                                               |
 +----------------------------------------+  +-----------------------------------------+  +-----------------------------------------------+
```

## Entity Interactions

### Resource Creation

```
 [client]                                [exchange]            [formatter]         [repository]
    |                                         |                     '                    | 
    |         Create (POST) resource          |                     '                    |
    |---------------------------------------->|                     '                    |
    |                                      +--|                     '                    |
    | Find formatter (Content-Type header) |  |                     '                    |
    |                                      +->|     Parse bytes     |                    |
    |                                         |-------------------->|                    |
    |                                         |      Resources      |                    | 
    |                                         |<--------------------|                    |
    |                                      +--|                     |                    |
    |           Validate & setup resource  |  |                     '                    |
    |                                      +->|                     '                    |
    |                                         |----------------------------------------->|
    |                                         |          Create resource records         |
    |                                         |<-----------------------------------------|
    |                                      +--|                     '                    |
    |      Find formatter (Accept header)  |  |                     '                    |
    |                                      +->|  Compose Document   |                    |
    |                                         |-------------------->|                    |
    |                                         |        Bytes        |                    | 
    |           201 Created status            |<--------------------|                    | 
    |<----------------------------------------|                     '                    | 
    |                                         |                     '                    | 
```

### Resource Retrieval

```
 [client]                             [exchange]            [formatter]         [repository]
    |                                      |                     '                    | 
    |          Read (GET) resource         |                     '                    |
    |------------------------------------->|                     '                    |
    |                                      |----------------------------------------->|
    |                                      |          Read resource records           |
    |                                      |<-----------------------------------------|
    |                                   +--|                     '                    |
    |   Find formatter (Accept header)  |  |                     '                    |
    |                                   +->|   Compose Document  |                    |
    |                                      |-------------------->|                    |
    |                                      |        Bytes        |                    | 
    |           200 OK status              |<--------------------|                    |
    |<-------------------------------------|                     '                    | 
    |                                      |                     '                    | 
```

### Resource Modification

```
 [client]                                [exchange]            [formatter]         [repository]
    |                                         |                     '                    | 
    |         Update (PUT) resource           |                     '                    |
    |---------------------------------------->|                     '                    |
    |                                      +--|                     '                    |
    | Find formatter (Content-Type header) |  |                     '                    |
    |                                      +->|     Parse bytes     |                    |
    |                                         |-------------------->|                    |
    |                                         |      Resources      |                    | 
    |                                         |<--------------------|                    |
    |                                      +--|                     |                    |
    |           Validate & setup resource  |  |                     '                    |
    |                                      +->|                     '                    |
    |                                         |----------------------------------------->|
    |                                         |           Update resource records        |
    |                                         |<-----------------------------------------|
    |                                      +--|                     '                    |
    |      Find formatter (Accept header)  |  |                     '                    |
    |                                      +->|   Compose Document  |                    |
    |                                         |-------------------->|                    |
    |                                         |        Bytes        |                    | 
    |           201 Created status            |<--------------------|                    |
    |<----------------------------------------|                     '                    | 
    |                                         |                     '                    | 
```

### Resource Destruction

```
 [client]                                [exchange]            [formatter]         [repository]
    |                                         |                     '                    | 
    |        Destroy (DELETE) resource        |                     '                    |
    |---------------------------------------->|                     '                    |
    |                                         |----------------------------------------->|
    |                                         |           Destroy resource records       |
    |           204 No Cotent status          |<-----------------------------------------|
    |<----------------------------------------|                     '                    |
    |                                         |                     '                    | 
```

### Exchange Setup, Message Dispatch and Successful Reciept

The following diagram details the sequence of events for configuring an exchange (pub-sub), message dispatch and successful reciept.

```
[producer]            [consumer]                [exchange]                  [repository]
    |                     '                          |                            |
    |                     '                          |                            |          
    |          Create (POST /queues) queue           |                            |
    |----------------------------------------------->|                            |
    |                     '                          |--------------------------->|
    |                     '                          |    Create queue record     |    
    |       201 Created status and key               |<---------------------------|
    |<-----------------------------------------------|                            |
    |                     '                          |                            |
    |                     |                          |                            |
    |     Create (POST /subscriptions) subscription  |                            |
    |                     |------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          | Create subscription record |    
    |             201 Created status and key         |<---------------------------|
    |                     |<-------------------------|                            |
    |                     |                          |                            |
    |  Create (POST /queue/key/messages) message     |                            |
    |----------------------------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          |     Read queue records     |  
    |                     |                          |<---------------------------|
    |                     |                      +---|                            |
    |             Test queue limits not breached |   |                            |
    |                     |                      +-->|                            |
    |                     |                          |                            |
    |                     |                      +---|                            |
    |                  Schedule message dispatch |   |                            |
    |                     |                      +-->|                            |
    |           202 Accepted status and key          |                            |
    |<-----------------------------------------------|                            |
    |                     |                          |--------------------------->|
    |                     |                          |  Read subscription records |    
    |                     | Dispatch message (POST)  |<---------------------------|    
    |                     |<-------------------------|                            |
    |                     |   202 Accepted status    |                            |
    |                     |------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          |   Delete message record    |  
    |                     |                          |<---------------------------|
    |                     |                          |                            |
```

### Exchange Setup, Message Dispatch and Consumer Rejection

The following diagram details the sequence of events for configuring an exchange (pub-sub), message dispatch and consumer rejection.

```
[producer]            [consumer]                [exchange]                  [repository]
    |                     '                          |                            |
    |                     '                          |                            |          
    |          Create (POST /queues) queue           |                            |
    |----------------------------------------------->|                            |
    |                     '                          |--------------------------->|
    |                     '                          |    Create queue record     |    
    |       201 Created status and key               |<---------------------------|
    |<-----------------------------------------------|                            |
    |                     '                          |                            |
    |                     |                          |                            |
    |     Create (POST /subscriptions) subscription  |                            |
    |                     |------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          | Create subscription record |    
    |             201 Created status and key         |<---------------------------|
    |                     |<-------------------------|                            |
    |                     |                          |                            |
    |  Create (POST /queue/key/messages) message     |                            |
    |----------------------------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          |     Read queue records     |  
    |                     |                          |<---------------------------|
    |                     |                      +---|                            |
    |             Test queue limits not breached |   |                            |
    |                     |                      +-->|                            |
    |                     |                          |                            |
    |                     |                      +---|                            |
    |                  Schedule message dispatch |   |                            |
    |                     |                      +-->|                            |
    |           202 Accepted status and key          |                            |
    |<-----------------------------------------------|                            |
    |                     |                          |--------------------------->|
    |                     |                          |  Read subscription records |    
    |                     | Dispatch message (POST)  |<---------------------------|    
    |                     |<-------------------------|                            |
    |                     |   200 OK status          |                            |
    |                     |------------------------->|                            |
    |                     |                          |--------------------------->|
    |                     |                          |   Delete message record    |  
    |                     |                          |<---------------------------|
    |                     |                          |                            |
```

## Message Delivery

When a new message is delivered to the exchange it must be persisted with a range of information regarding the current state of the system. This approach avoids situations where one or more Queue/Subscription configurations are modified before the system has the oppurtunity to forward the message; which if left unchecked would produce erratic behaviour on behalf of the dispatch logic.

To achieve this the exchange persists a single copy of the message record within the repository and a collection of internal data-structures known as message-states. Each state record holds a reference to the message and duplicates the queue, and subscription configuration at time of message creation.

For example: A message delivered to a queue with 2x subscriptions will force the exchange to instantiate 2x state objects snapshotting each subscription and associated queue configuration.

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

## Ruleset


## Dependencies



## Further Reading

[Opaque Pointer](https://en.wikipedia.org/wiki/Opaque_pointer)

[Message Queue](https://en.wikipedia.org/wiki/Message_queue)

[Publish–subscribe pattern](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern)

[Uniform Resource Identifier (URI): Generic Syntax](https://tools.ietf.org/html/rfc3986).

[Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content](https://tools.ietf.org/html/rfc7231). 

[A Universally Unique IDentifier (UUID) URN Namespace](https://tools.ietf.org/html/rfc4122).
