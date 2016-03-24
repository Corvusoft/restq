
## UML Overview

Corvusoft's development team frequently employee the use of Unified Modelling Language (UML) diagrams to assist in communicating key concept and design ideas of a system or sub-system to techincal and non-technical parties alike.

This document outlines our understanding of relevant UML structure helping all participants to start on common ground and better communicate software design.

### Relationships ###

```
 Association:   ^   Aggregation:   O   Composition:   @   Generalisation:   #   Realisation:   :
                |                  |                  |                     |                  |
              <-+->              O-+-O              @-+-@                 #-+-#              :-+-:
                |                  |                  |                     |                  |
                V                  O                  @                     #                  :
```

#### Association

Describes logical connections or relationships between two entities. The direction of the relationship is represented by a line with an arrowhead. 

#### Aggregation

refers to the formation of a particular class as a result of one class being aggregated or built as a collection. For example, the class “library” is made up of one or more books, among other materials. In aggregation, the contained classes are not strongly dependent on the life cycle of the container. In the same example, books will remain so even when the library is dissolved. To render aggregation in a diagram, draw a line from the parent class to the child class with a diamond shape near the parent class.

#### Composition

is very similar to the aggregation relationship, with the only difference being its key purpose of emphasizing the dependence of the contained class to the life cycle of the container class. That is, the contained class will be obliterated when the container class is destroyed. For example, a shoulder bag’s side pocket will also cease to exist once the shoulder bag is destroyed. To depict a composition relationship in a UML diagram, use a directional line connecting the two classes, with a filled diamond shape adjacent to the container class and the directional arrow to the contained class.

#### Generalisation / Inheritance

refers to a type of relationship wherein one associated class is a child of another by virtue of assuming the same functionalities of the parent class. In other words, the child class is a specific type of the parent class. To depict inheritance in a UML diagram, a solid line from the child class to the parent class is drawn using an unfilled arrowhead.

#### Realisation

denotes the implementation of the functionality defined in one class by another class. To show the relationship in UML, a broken line with an unfilled solid arrowhead is drawn from the class that defines the functionality to the class that implements the function. In the example, the printing preferences that are set using the printer setup interface are being implemented by the printer.

###Sterotypes###

| &lt;&lt;Sterotype&gt;&gt; | Description |
|------------|-------------| 
| static | Indicates an entity whose lifetime or "extent" extends across the entire run of the program. |
| class | Represents an entity providing initial values for state and implementations of behavior. |
| typedef | Used to create an alias for any other data-type. As such, it is often used to simplify the syntax of declaring complex data structures. |
| enum | enumeration sterotype shows a set of named values called elements, members, enumeral, or enumerators of the type. The enumerator names are usually identifiers that behave as constants in the program. |
| interface | Shows a common means for unrelated objects to communicate with each other. These are definitions of methods and values which the objects agree upon in order to co-operate. |
| abstract | Describes an entity in a nominative type system that cannot be instantiated directly. Abstract types are also known as existential types. An abstract type may provide no implementation, or an incomplete implementation. |

### Example ###

The following diagram shows that a Session class is composed and in a one-to-one relationship with both the Request and Response classes.

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


