
##UML Overview

###Relationships###

```
 Association:   ^   Aggregation:    O   Composition:    @   Inheritance:    #
                |                   |                   |                   |
              <-+->               O-+-O               @-+-@               #-+-#
                |                   |                   |                   |
                V                   O                   @                   #
```

###Sterotypes###

| &lt;&lt;Sterotype&gt;&gt; | Description |
|------------|-------------| 
| static | Static class |
| class | class |
| typedef | type definition |
| enum | enumeration |
| interface | interface |
| abstract | abstract class |

### Example ###

The following diagram shows that a Session class instance is composed of and in a one-to-one relationship with both a Request and Response class instance.

```
             +---------------+
             |   <<class>>   | 1
     1 +----@+    Session    +@-----+
       |     +---------------+      |
       |                            |
     1 @                            @ 1
+------+-------+             +------+-------+
|   <<class>>  |             |   <<class>>  |
|    Request   |             |   Response   |
+--------------+             +--------------+
```


