# Linux Cluster Monitoring Agent

## Introduction

_Linux Cluster Monitoring Agent (LCMA) is a minimum viable product (MVP). It consists of a set of software tools. LCMA is designed to automate the collection, persistence and real-time monitoring of hardware specifications and resource usage data of all the nodes within a cluster of linux servers._

#### **LCMA has countless applications:**
It can be utilised by Network or System Adminstrators and Analysts to catch network and system failures. It delivers additional value when used to analyse hardware resourse usage and redundacy of servers in a linux cluster. Consequently, important conclusion can be drawn about the risks, challenges and opportunities related to network resource distribution and load balancing within the cluster. 

The LCMA software toolset is implemented using the iterative/incremental `SCRUM`  framework. Which allows the incorporation of `Agile` software development life cycle `(SDLC)` methodologies. 

#### **Array of softwares / technologies that form the foundations of the LCMA are:**
- **Google Cloud Platform VM instance:** 
- **Linux Cent Os 7:** for development, closest to red hat enterprise linux
- **Linux Bash Scripts and CLI:**  The main scripts `psql_docker.sh`, `host_info.sh`,`host_usage.sh` are implemented using Bash scripting language, command line tools (`crontab`), character encoding and regex to automate the creation, initialisation of docker psql container as well as the collection and insertion of data into the host_agent database.
- **Docker and PostgreSQL:** docker container, image and volume are used to contain the PostgreSQL server processes that enable the persistence and queryiing of data 
- **Git, GitHub and Gitflow:**


### Quick Start
&#x1F53D; _**Prerequisites:** on a linux system that has docker installed_
1. Make sure your bash files are executable 
2. Create, start or stop a docker container containing a psql instance using psql_docker.sh 
```diff 
      bash ./scripts/psql_docker.sh start|stop|create [db_username][db_password]
```
3. Create tables using ddl.sql
```diff 
      bash psql -h localhost -p 5432 -U db_username -f ./sql/ddl.sql
```
4. Insert hardware specs data into the db using host_info.sh
```diff     
      bash ./scripts/host_info.sh localhost 5432 db_name db_username db_password
```
5. Insert hardware usage data into the db using host_usage.s 
```diff     
      bash ./scripts/host_usage.sh localhost 5432 db_name db_username db_password
```
6. Crontab setup
```diff
   crontab -e
   * * * * * bash ~full_path~/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```

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
