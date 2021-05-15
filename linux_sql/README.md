# Linux Cluster Monitoring Agent

## Introduction
``` diff
+ _**Linux Cluster Monitoring Agent (LCMA) is a minimum viable product (MVP) that consists of a set of software tools.**_
```

LCMA is designed to automate the **_collection_**, **_persistence_** and **_real-time monitoring_** of hardware specifications and resource usage data of all the nodes within a cluster of linux servers.


**LCMA has numerous applications:**
It can be utilised by Network and System Adminstrators and Analysts to catch network and system failures. It can be used to analyse hardware resourse usage and redundacies. Consequently, important decisions can be made about the risks, challenges and opportunities related to network load distribution and balancing within a cluster of linux servers. 

The LCMA software toolset is implemented using the iterative **SCRUM** framework. Which allows the incorporation of Agile **software development life cycle (SDLC)** methodologies. project makes use of an array of different technologies: Linux Bash CLI, Docker, PSQL, Git
(e.g. CentOS, bash CLI, docker, PSQL, SQL, DDL, DML, git, gitflow etc..)


### Quick Start
- Prerequisites: on a linux enterprise system, have docker installed
- Start a psql instance using psql_docker.sh
- make sure your file is executable 
- create a docker container, start or stop it
- Create tables using ddl.sql
- Insert hardware specs data into the db using host_info.sh
- Insert hardware usage data into the db using host_usage.sh
- Crontab setup

## Implementation

### Architecture

![linux_sql_arch](https://user-images.githubusercontent.com/50436238/118318188-04fb4600-b4c7-11eb-9b86-316be03e5a2a.png)

### Scripts

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

## Tests

## Improvements
