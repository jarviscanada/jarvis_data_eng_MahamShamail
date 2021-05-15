# Linux Cluster Monitoring Agent

## Introduction

_**Linux Cluster Monitoring Agent (LCMA)** is a minimum viable product **(MVP)**. It consists of a set of software tools. LCMA is designed to automate the collection, persistence and real-time monitoring of hardware specifications and resource usage data of all the nodes within a cluster of linux servers._

#### **LCMA has countless applications:**
It can be utilised by Network or System Adminstrators and Analysts to catch network and system failures. It delivers additional value when used to analyse hardware resourse usage and redundacy of servers in a linux cluster. Consequently, important conclusion can be drawn about the risks, challenges and opportunities related to network resource distribution and load balancing within the cluster. 

The LCMA software toolset is implemented using the iterative/incremental **SCRUM**  framework. Which allows the incorporation of **Agile** software development life cycle (**SDLC**) methodologies. 

#### **Array of softwares / technologies that form the foundations of the LCMA are:**
- **Google Cloud Platform VM instance:** used to connect to the Jarvis Remote Desktop (JRD), a remote linux Cent OS 7 server designed for training software developers. It allows them to work on the same software development environment. 
- **Linux Bash Scripts and CLI:**  The main scripts `psql_docker.sh`, `host_info.sh`,`host_usage.sh` are implemented using Bash scripting language, command line tools (`crontab`), character encoding and regex to automate the creation, starting and stopping of docker psql container as well as the collection and insertion of data into the host_agent database.
- **Docker and PostgreSQL:** docker container, image and volume are used to contain the PostgreSQL server processes that enable the persistence and queryiing of data 
- **Git, GitHub and Gitflow:** Git distributed version control and gitflow is used to iteratively implement features, track their changes using individual feature branches and incrementally merge them into the develop branch, where the code is reviewed by a senior developer using a pull request (PR) and after PR approval the develop branch is merged into releasse branch. GitHub hosts the git services and helps us manage our gitflow.


### Quick Start
&#x1F53D; _**Prerequisites:** make sure your on on a linux system or VM instance that has docker installed_
1. Make sure your bash files are executable 
```diff 
      chmod +x bashFileName.sh
```
2. Create, start (or stop) a docker container named jrvs-psql containing a psql instance using `psql_docker.sh` 
```diff 
      bash ./scripts/psql_docker.sh start|stop|create [db_username][db_password]
      
      db_username = postgres
      db_password - password
```
3. Login to your PSQL server using the Linux CLI, password is "password"
```diff
      psql -h localhost -U postgres
```
4. Create a database in your psql 
```diff
      connect to the database using: \c host_agent
      
      host_agent# CREATE DATABASE host_agent;
```
5. Create host_info and host_usage tables using `ddl.sql`
```diff 
      bash psql -h localhost -p 5432 -U db_username -f ./sql/ddl.sql
```
6. Insert hardware specs data into the db using host_info.sh
```diff     
      bash ./scripts/host_info.sh localhost 5432 db_name db_username db_password
```
7. Insert hardware usage data into the db using host_usage.s 
```diff     
      bash ./scripts/host_usage.sh localhost 5432 db_name db_username db_password
```
8. Use Crontab to trigger host_usage.sh every minute
```diff
   crontab -e
   
   * * * * * bash ~full_path~/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```
9. Exequte queries.sql or query data using psql instance to draw conclusions about the hardware resourse usage

## Implementation

The image below depicts that a bash script `psql_docker.sh` creates, starts or stops a docker PostgreSQL container on the host server. Every linux server in the cluster has a monitoring agent which consists of two bash scripts: `host_info.sh` and `host_usage.sh`. These scripts send data to the host server's docker psql instance using a switch for insertion and persistence of hardware specification and resource usage data. 

### Architecture
![Untitled Diagram](https://user-images.githubusercontent.com/50436238/118348200-b4133e00-b516-11eb-8e44-1cb882d4ee2a.png)


### Scripts
- `psql_docker.sh` 
   >  hello
- `host_info.sh` 
   >  hello
- `host_usage.sh` 
   >  hello
- `ddl.sql` 
   >  hello
- `queries.sql` 
   >  hello

### Database Modeling

COLUMN NAMES | DATA TYPES | DATA CONSTRAINTS
------------ | -------------| -------------
`id`| SERIAL| PRIMARY KEY _and_ NOT NULL
`hostname`| VARCHAR | UNIQUE _and_ NOT NULL
`cpu_number`| INTEGER | NOT NULL
`cpu_architecture`| VARCHAR | NOT NULL
`cpu_model`| VARCHAR | NOT NULL
`cpu_mhz`| NUMERIC | NOT NULL
`L2_cache`| INTEGER | NOT NULL
`total_mem`| INTEGER | NOT NULL,
`timestamp` | TIMESTAMP | NOT NULL



COLUMN NAMES | DATA TYPES | DATA CONSTRAINTS
------------ | -------------| -------------
`id`| SERIAL| PRIMARY KEY _and_ NOT NULL
`timestamp`| TIMESTAMP | NOT NULL
`host_id`| INTEGER | SERIAL _and_ NOT NULL _and_ FORIEGN KEY _as_ host_info.id
`memory_free`| INTEGER | NOT NULL
`cpu_idle`| SMALLINT | NOT NULL
`cpu_kernel`| SMALLINT | NOT NULL
`disk_io`| INTEGER | NOT NULL
`disk_available`| INTEGER | NOT NULL

## Tests

## Improvements
