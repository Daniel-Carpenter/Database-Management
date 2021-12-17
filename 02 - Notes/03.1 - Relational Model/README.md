# Relational Model

## Objectives:
1. Relational Model
2. Converting an ER diagram to relation schemas

---
 
## 1. Relational Model

* Difference between ER and Relational model:
    * ER: Model
    * Relational Model: Implementation

### Relations
> A relation is a table

Term | Description
-|-
`Attribute`   | Column 
`Tuple`       | Row

### Attribute Types
Type    | Description
--------|-------------
Domain  | Allowed values in attribute (*exception: `null` values*)
Atomic  | Indivisible, attributes are normally indivisible

### Relation Schemas and Instances
Type        | Description
------------|-------------
Schema      | instructor
Attributes  | ID, name, dept_name, salary

*Written Form:*
```
instructor (ID, name, dept_name, salary)
```

### Keys
> 1. Get set of `candidate` keys (which is a unique) from a set of `superkeys`
> 2. Select ***one*** `candidate` key to be the `primary key`

---

## 2. Converting an ER diagram to relation schemas

* Relational Database houses relational schemas
* A relational schema houses entity and relationship set 

### Example of `Schema` Conversions
Explanation         | Example   | Conversion
--------------------|-----------|--------
`Simple` Attribute  | <img src = "Images/conEntity1.png" width = 400> | <img src = "Images/conEntity2.png" width = 400>
`Composite` Attribute | <img src = "Images/conEntity3.png" height = 250> | <img src = "Images/conEntity4.png" width = 400>
`Multivalued` Attribute | <img src = "Images/conEntity3.1.jpg" height = 250> | Use Instructor ID as key and give phone number. <img src = "Images/conEntity4.1.png" width = 400>

### Example of `ER` Conversions
Explanation         | Example   | Conversion
--------------------|-----------|--------
`Many-to-Many`  | <img src = "Images/conEntity5.png" width = 400> | <img src = "Images/conEntity6.png" width = 400>
`One-to-One` (*Basic*)  | <img src = "Images/conEntity7.png" width = 400> | <img src = "Images/conEntity8.png" width = 400>
`One-to-One` (*Dept has Total Participation*)  | <img src = "Images/conEntity9.png" width = 400> | <img src = "Images/conEntity10.png" width = 400>
`One-to-One` (*Each have Total Participation*)  | <img src = "Images/conEntity11.png" width = 400> | <img src = "Images/conEntity12.png" width = 400>
`One-to-Many` | <img src = "Images/conEntity15.png" width = 400> | Create seperate schema to join the two:  <img src = "Images/conEntity16.png" width = 400>
`One-to-Many` | <img src = "Images/conEntity15.png" width = 400> | Or just add the dept ID in as a FK:  <img src = "Images/conEntity17.png" width = 400>
`Relationship w/Attributes` (*I.e. employee on multiple dates*)  | <img src = "Images/conEntity13.png" width = 400> | <img src = "Images/conEntity14.png" width = 400>

### Advanced Conversions

Explanation         | Example   | Conversion
--------------------|-----------|--------
`Weak to Strong`| <img src = "Images/weakToStrong1.png" width = 400> | No need for relation, just include course as `PK`: <img src = "Images/weakToStrong2.png" width = 400>
`Disjoint Total`| <img src = "Images/disjoint1.png" width = 400> | Don't create two schemas, just one since inherits same info: <img src = "Images/disjoint2.png" width = 400>
`Disjoint Partial`| <img src = "Images/disjoint1.png" width = 400> | Needs three schemas since some employees could be other: <img src = "Images/disjoint3.png" width = 400>
`Aggregation`| <img src = "Images/aggr1.png" width = 400> | Needs three schemas since some employees could be other: <img src = "Images/aggr2.png" width = 400>
`Recursive`| <img src = "Images/recur1.png" width = 400> | Needs three schemas since some employees could be other: <img src = "Images/recur2.png" width = 400>

### Schema Diagram
> Shows the relationships between `primary` and `foreign` keys
* Arrows show relationship of IDs, not the relationship of one-to-many, etc.

<img src = "Images/schemaDia.png" width = 550>