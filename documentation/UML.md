UML Overview
------------

Corvusoft's development teams frequently employee the use of the Unified Modeling Language (UML) to assist in communicating core concepts and design decisions of a system or sub-system to technical and non-technical parties alike.

Of the many tools available within UML we primarily employ Class diagrams for detailing static structure that describes the system by showing the classes, their attributes, operations, and the relationships among objects. With behavioral characteristics shown via Sequence diagrams detailing interaction between entities that operate with one another and in what order.

This document outlines our interpretation of relevant UML concepts and aims in creating a level playing field for all participants during software design discussions.

Interpretation
--------------

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](http://tools.ietf.org/pdf/rfc2119.pdf).

### Class Diagrams

#### Relationships

```
 Association:   ^   Aggregation:   O   Composition:   @   Generalisation:   #   Realisation:   :
                |                  |                  |                     |                  |
              <-+->              O-+-O              @-+-@                 #-+-#              :-+-:
                |                  |                  |                     |                  |
                V                  O                  @                     #                  :
```

##### Association

Describes logical connections or relationships between two entities. The direction of the relationship is represented by a line with an arrowhead.

##### Aggregation

refers to the formation of a particular class as a result of one class being aggregated or built as a collection. For example, the class “library” is made up of one or more books, among other materials. In aggregation, the contained classes are not strongly dependent on the life cycle of the container. In the same example, books will remain so even when the library is dissolved. To render aggregation in a diagram, draw a line from the parent class to the child class with a diamond shape near the parent class.

##### Composition

is very similar to the aggregation relationship, with the only difference being its key purpose of emphasizing the dependence of the contained class to the life cycle of the container class. That is, the contained class will be obliterated when the container class is destroyed. For example, a shoulder bag’s side pocket will also cease to exist once the shoulder bag is destroyed. To depict a composition relationship in a UML diagram, use a directional line connecting the two classes, with a filled diamond shape adjacent to the container class and the directional arrow to the contained class.

##### Generalisation / Inheritance

refers to a type of relationship wherein one associated class is a child of another by virtue of assuming the same functionalities of the parent class. In other words, the child class is a specific type of the parent class. To depict inheritance in a UML diagram, a solid line from the child class to the parent class is drawn using an unfilled arrowhead.

##### Realisation

denotes the implementation of the functionality defined in one class by another class. To show the relationship in UML, a broken line with an unfilled solid arrowhead is drawn from the class that defines the functionality to the class that implements the function. In the example, the printing preferences that are set using the printer setup interface are being implemented by the printer.

#### Sterotypes

| &lt;&lt;Sterotype&gt;&gt; | Description                                                                                                                                                                                                                |
|:-------------------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|          static           | Indicates an entity whose lifetime or "extent" extends across the entire run of the program.                                                                                                                               |
|           class           | Represents an entity providing initial values for state and implementations of behavior.                                                                                                                                   |
|          typedef          | Used to create an alias for any other data-type. As such, it is often used to simplify the syntax of declaring complex data structures.                                                                                    |
|           enum            | enumeration sterotype shows a set of named values called elements, members, enumeral, or enumerators of the type. The enumerator names are usually identifiers that behave as constants in the program.                    |
|         interface         | Shows a common means for unrelated objects to communicate with each other. These are definitions of methods and values which the objects agree upon in order to co-operate.                                                |
|         abstract          | Describes an entity in a nominative type system that cannot be instantiated directly. Abstract types are also known as existential types. An abstract type may provide no implementation, or an incomplete implementation. |

### Multiplicity

Optional notation indicating the range of entities within a relationship.

| Notation | Description                    |
|:--------:|--------------------------------|
|   0..1   | No instances, or one instance. |
|    1     | Exactly one instance.          |
|  0..\*   | Zero or more instances.        |
|    \*    | Zero or more instances.        |
|  1..\*   | One or more instances.         |

### Visibility

It is encouraged to only show public methods, reducing rework of the documentation during each software development cycle. The use of Private, Protected, Derived, and Package visibility should only be present when highlighting important core design decision. For example inheriting from a base class and altering parent method/property visibility.

| Symbol | Description |
|:------:|-------------|
|   \+   | Public      |
|   \-   | Private     |
|   \#   | Protected   |
|   ~    | Package     |

To specify the visibility of a class member (i.e. any attribute or method), these notations must be placed before the member's name.

#### Example

The following diagram shows that a Session class is composed and in a one-to-one relationship with both the Request and Response classes.

```
             +---------------+
             |   <<class>>   | 1
     1 +----@+    Session    +@-----+
       |     +---------------+      |
       |                            |
     1 |                            | 1
+------+-------+             +------+-------+
|   <<class>>  |             |   <<class>>  |
|    Request   |             |   Response   |
+--------------+             +--------------+
```
