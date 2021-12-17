# Intro to DBMS

## Objectives:
1. Purposes of DBMS 
2. Components of DBMS
3. Evolution of DMBS

---

## 1 - `Purposes of DBMS `

### Overcoming Filesystems through Databases
* Data redundancy and inconsistency
* Difficulty in accessing data
* Data isolation —multiple files and formats
* Integrity problems
* Atomicity of updates (could leave data in inconsistent format)
* Access by multiple users
* Security: Access to only few

### When `not` to use DBMS
* Overhead costs high
* If db is not properly designed or implemented
* Mass use is not required

---

## 2 - `Components of DBMS`

### `Abstraction`
Level|Description
-|-
Physical|Describe how a record is stored
Logical|Data acturally stored in db (`ID: string . . .`)
Views| can hide data or show only what is needed

### `Instances` and `schemas`
Type|Description
-|-
Physical Schema |design at physical level
Logical Schema  |design at logical level
Instance        |value of a given variable or field
Physical Data Independence | Can modify physical schema without changing logical schema

### Data models
Model|Description
-|-
Relational model                |
Entity-Relationship data model  | for database design
Object-based data models (OOP)  |
Semistructured data model (XML) |
Network model                   |
Hierarchical model              |

### Data Definition Language (DDL)
* Metadata
* Information aboyr schemas, cardinality, authorization
```sql
create table instructor (
    ID          char(5),
    name        varchar(20),
    dept_name   varchar(20),
    salary      numeric(8,2)
)
```

### Database design
* Relational databases help reduces: 
    1. `inconsistency`
    2. `query response time`
    3. `storage`

### Transaction Management
Definiton|Description
-|-
`transaction` | operations performed onsingle logical function in database
Transaction-management | Ensures that database is consistent despite system failures
Concurrency-control manager| Controls interaction of transcations to ensure consistency of database

### Database architecture
System          | Description
-|-
Centralized     |
Client-server   | Server -> App -> user
Parallel (multi-processor) |
Distributed     | 

#### Approaches to better database design"
1. Normalization
2. Entity Relationship models

---

## 3 - `Evolution of DMBS`

### 1950s-60s
* Magnetic tape and punch cards

### Late 1960s and 1970s
* HArd disks = direct access to data
* Network/hierarchical data modesl used
* Relational model formed by Ted Codd (IBM, UC Berkeley, and Oracle form)
* High performance transaction processing begins

### 80s
* SQL is the standard
* PArallel/distributed/OOP databases 

### 90s
* Data mining
* Data warehousing (multi-terabyte)
* Web commerce

### 2000s
* XML, Xquery
* Automation to DBAs
* Big data

### 2010s
* Multicore
* Mass parallel databases

