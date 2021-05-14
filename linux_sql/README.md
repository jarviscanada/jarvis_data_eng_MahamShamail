# Linux Cluster Monitoring Agent

## Introduction

### Quick Start

## Implementation

### Architecture

![linux_sql_arch](https://user-images.githubusercontent.com/50436238/118318188-04fb4600-b4c7-11eb-9b86-316be03e5a2a.png)

### Database Modeling

Column Names | Data Types
------------ | -------------
id| SERIAL PRIMARY KEY NOT NULL
hostname| UNIQUE VARCHAR NOT NULL
cpu_number| INTEGER NOT NULL
cpu_architecture| VARCHAR NOT NULL
cpu_model| VARCHAR NOT NULL
cpu_mhz| NUMERIC NOT NULL
L2_cache| INTEGER NOT NULL
total_mem| INTEGER NOT NULL,
timestamp | TIMESTAMP NOT NULL



Column Names | Data Types
------------ | -------------
id| SERIAL PRIMARY KEY NOT NULL
timestamp| TIMESTAMP NOT NULL
host_id| SERIAL NOT NULL FORIEGN KEY host_info id
memory_free| INTEGER NOT NULL
cpu_idle| SMALLINT NOT NULL
cpu_kernel| SMALLINT NOT NULL
disk_io| INTEGER NOT NULL
disk_available| INTEGER NOT NULL
