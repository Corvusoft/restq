##Design Overview

Unless otherwise specified all primary data-types originate within the Standard Template Library (STL). Including but not limited to string, map, list, multimap, set, any, and friends.

This document does not concern itself with API specifics and primarly focuses on architectrual desicions made during development, see API.md for contract detail.

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

### String

Utiltiy class of static scope offering a common suite of string manipulation routines. Additional methods are inherited from restbed::String and will not be restated here convenience and clarity.
```
+--------------------------------------+
|              <<static>>              |
|                String                |
+--------------------------------------+
| + is_integer(string)          bool   |
| + is_boolean(string)          bool   |
| + is_fraction(string)         bool   |
| + trim( string,string)        string |
| + trim_leading(string,string) string |
| + trim_lagging(string,string) string |
+--------------------------------------+
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

### Session

This is my session description.

```
             +---------------+
             |   <<class>>   | 1
     1 +-----@    Session    @------+
       |     +---------------+      |
       |                            |
     1 |                            | 1
+------+-------+             +------+-------+
|   <<class>>  |             |   <<class>>  |
|    Request   |             |   Response   |
+--------------+             +--------------+
```

### Request



### Response


## Sequence Overview

Highlevel sequence diagram.
