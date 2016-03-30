##Design Overview

### start with data types then progress to more complicated areas. LogLevel, , Resource, Resources, Callback.

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
+------- ---------------+
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

### Exchange

This my exchange description.

```
                                           +-----------------------------------------+
                                           |               <<class>>                 |
                                           |               Exchange                  |
                                           |                                         |
                                           +-----------------------------------------+
                                           | + stop(void) void                       |
                                           | + start(Settings) void                  |
                                           | + restart(Settings) void                |
                                           | + add_format(MIME,Formatter) void       |
                                           |                                         |
                                           | + set_logger(Logger) void               |
                                           | + set_repository(Repository) void       |
                                           | + set_ready_handler(Callback) void      |
                                           | + set_signal_handler(int,Callback) void |
                                           +---------------------O-------------------+
                                                                 |
                                                                 |
                    +--------------------------------------------+---------------------------------------------
                    |                                            |                                            |
                    |                                            |                                            |
                    |                                            |                                            |
 +------------------+----------------+     +---------------------+-------------------+  +---------------------+-----------------+
 |            <<interface>>          |     |               <<interface>>             |  |               <<interface>>           |
 |              Formatter            |     |                 Repository              |  |                 Logger                |
 |                                   |     |                                         |  |                                       |
 +-----------------------------------+     +-----------------------------------------+  +---------------------------------------+
 | + parse(Bytes) Resources          |     | + stop(void) void                       |  | + stop(void) void                     |
 | + try_parse(Bytes,Resources) bool |     | + start(Settings) void                  |  | + start(Settings) void                |
 | + compose(Resources,bool) Bytes   |     | + create(Resources,Query,Callback) void |  | + log(Level,string) void              |
 |                                   |     | + read(Query,Callback) void             |  | + log_if(condition,Level,string) void |
 | + get_mime_type(void) MIME        |     | + update(Resources,Query,Callback) void |  |                                       |
 |                                   |     | + destroy(Query,Callback) void          |  |                                       |
 | + set_logger(Logger) void         |     |                                         |  |                                       |
 |                                   |     | + set_logger(Logger) void               |  |                                       |
 +-----------------------------------+     +-----------------------------------------+  +---------------------------------------+
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
