# Linux Cluster Monitoring Agent

## Introduction

**`Linux Cluster Monitoring Agent (LCMA)`** consists of a set of software tools. LCMA is designed to automate the _collection_, _persistence_ and _real-time monitoring_ of hardware specifications and resource usage data of all the nodes within a cluster of linux servers. It is a minimum viable product (**`MVP`**).

#### **LCMA has various applications:**
It can be utilised by Network or System Administrators and Analysts to catch network and system failures. It delivers additional value when used to analyse hardware resource usage and redundancy of servers in a linux cluster. Consequently, important conclusions can be drawn about the risks, challenges and opportunities related to network resource distribution and load balancing within the cluster. 

The **`LCMA`** software toolset is implemented using the iterative/incremental **`SCRUM`**  framework. Which allows the incorporation of **`Agile`** software development (**`SDLC`**) methodologies. 

#### **Array of softwares / technologies that form the foundations of the LCMA are:**
- **`Google Cloud Platform VM instance`:** used to connect to the Jarvis Remote Desktop (JRD), a remote linux Centos 7 server designed for training software developers. It allows them to work in the same software development environment. 
- **`Linux Bash Scripts and CLI`:**  The main scripts `psql_docker.sh`, `host_info.sh`,`host_usage.sh` are implemented using Bash scripting language, command line tools (`crontab`), character encoding and regex to automate the creation, starting and stopping of docker psql container as well as the collection and insertion of data into the host_agent database.
- **`Docker and PostgreSQL`:** docker container, image and volume are used to contain the PostgreSQL server processes that enable the persistence and querying of data 
- **`Git`, `GitHub` and `Gitflow`:** Git distributed version control and gitflow is used to iteratively implement features, track their changes using individual feature branches and incrementally merge them into the develop branch, where the code is reviewed by a senior developer using a pull request (PR) and after PR approval the develop branch is merged into release branch. GitHub hosts the git services and helps us manage our gitflow.


### Quick Start
&#x1F53D; _**Prerequisites:** make sure your on on a linux system or VM instance that has docker installed_
1. Make sure your bash files are executable 
```console 
      chmod +x bashFileName.sh
```
2. Create, start (or stop) a docker container named jrvs-psql containing a psql instance using `psql_docker.sh` 
```console 
      bash ./scripts/psql_docker.sh start|stop|create [db_username][db_password]
      
      db_username = postgres
      db_password - password
```
3. Login to your PSQL server using the Linux CLI, password is "password"
```console 
      psql -h localhost -U postgres
```
4. Create a database in your psql and connect to it
```sql 
      CREATE DATABASE host_agent;
```
```console 
      \c host_agent
```
5. Create host_info and host_usage tables using `ddl.sql`
```console 
      psql -h localhost -p 5432 -U db_username -f ./sql/ddl.sql
```
6. Insert hardware specs data into the db using host_info.sh
```console     
      bash ./scripts/host_info.sh localhost 5432 db_name db_username db_password
```
7. Insert hardware usage data into the db using host_usage.s 
```console     
      bash ./scripts/host_usage.sh localhost 5432 db_name db_username db_password
```
8. Use Crontab to trigger host_usage.sh every minute
```console
   crontab -e
   
   * * * * * bash ~full_path~/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```
9. Execute queries.sql or query data using psql instance to draw conclusions about the hardware resource usage

## Implementation
- To execute this project you must first create a PostgreSQL database containerised within docker using the `psql_docker.sh` script. 
- `psql_docker.sh` takes 3 arguments as input: The first argument can either be `create`, `start`, or `stop`, based on what you want to do with the PostgreSQL docker container. If you are running the script for the first time use the `create` input argument. The following two input arguments are the `username` and `password` of the PostgreSQL database on this server.
- After creating a docker container the next step would be to `start` the docker container, by running the `psql_docker.sh` script again using the `start` input argument.
- Once the docker container of the PSQL database is active, you can now connect to the PostgreSQL server and proceed with creating a new `host_agent` database. 
- Next would be to execute the `ddl.sql` script in order to create `host_info` and `host_agent` tables within the database.
- Upon successful creation of tables the database is now ready to be populated.
- Next step would be to execute the `host_info.sh` script. The `host_info.sh` script is used to collect the hardware specifications using the `lscpu` command and insert the data into the PSQL database.
- Once hardware specs have been successfully inserted into the host_info table execute the `host_usage.sh` script. The `host_usage.sh` script is used to collect the real time resource usage of the server using the `vmstat` command and insert the data into the PSQL database.
- The `host_usage.sh` script is automated to get triggered every minute using `contrab`. This will allow for the user to see CPU usages in real time to aid with any server maintenance or monitoring.

### Architecture
The image below depicts that a bash script `psql_docker.sh` creates, starts or stops a docker PostgreSQL container on the host server. Every linux server in the cluster has a monitoring agent which consists of two bash scripts: `host_info.sh` and `host_usage.sh`. These scripts send data to the host server's docker psql instance using a switch for insertion and persistence of hardware specification and resource usage data. 

![Untitled Diagram-2](https://user-images.githubusercontent.com/50436238/118369713-70e6b880-b572-11eb-8d00-2a4cbdbe042b.png)

### Scripts
- **`psql_docker.sh`** 
   >  This script provides an easy mechanism to create, start or stop the docker container with postgres server. 
   
   >  It takes in 3 inputs arguments: 
   >  * The first argument can be either **`create`**, **`start`** or **`stop`**.
   >  * The other two arguments are the database `password` and `username`
   
   >  It checks for the number of arguments, if there are less than 3 arguments the script will throw an error message and exit.
   
   >  If it receives three valid arguments it will then match and run the case statements accordingly.
```console 
      bash ./scripts/psql_docker.sh start|stop|create [db_username][db_password]
      
      db_username = postgres
      db_password - password
```
- **`ddl.sql`** 
   >  This script will assume that you have created a database within your PostgreSQL server. 
   
   >  Within that database it will try to create the host_info table using an CREATE SQL query. This table defines the hardware specifications of the linux node according to field names, data types and data constraints.
   
   >  Next it will try to create the host_uage table. This table defines the linux node resource usage according to field names, data types and data constraints.
- **`host_info.sh`**
   >  This script accepts 5 arguments:
   >  * hostname: localhost
   >  * port number: 5432
   >  * database name: host_agent
   >  * user name: postgres
   >  * password: password
   
   >   This script parses the hardware specifications of the machine it is run on.
   
   >   It uses the **`lscpu`** command to parse the hardware specifications data.

   >   Then, it inserts the data into the host_info table of the provided postgres server.
 
 ```console  
 ./scripts/host_info.sh localhost 5432 [database] [username] [password]
 ```   
- **`host_usage.sh`**
   >  This script accepts 5 input arguments:
   >  * hostname: localhost
   >  * port number: 5432
   >  * database name: host_agent
   >  * user name: postgres
   >  * password: password
    
   >   This script parses the hardware resource usage of the machine it is run on.
    
   >   It uses the **`vmstat`** and **`df`** commands to parse the machine usage data.
   
   >   Then, it inserts the data into the host_usage table of the provided postgres server.
```console
 ./scripts/host_usage.sh localhost 5432 [database] [username] [password]
```
- **`crontab`**
   >   crontab allows for host_usage script to parse real time information about the server and update the host_usage table by executing the script every minute
   
   >   Open crontab editor to create a new job using **`crontab -e`**
   
   >   Add the line to the open editor to collect the usage data every minute
   
   >   `* * * * * [full file path to]/linux_sql/scripts/host_usage.sh localhost 5432 [database] [username] [password]`

   > To check if the crontab implementation was successful use this command to ensure that the job is running: **`crontab -l`**
- **`queries.sql`** 
   >  This script assumes that both tables host_info and host_usage have a data population.
   >  It demonstrates examples of business questions that can be answered with the populated data, like:
   >  * Grouping and ordering of servers by the number of CPUs and memory amount.
   >  * Displaying average memory use over time intervals of varying length for every machine.
   >  * Identifying machine failures at times the server did not insert the data.

### Database Modeling

#### `Host_Info Table`
The host_info table stores the hardware specifications of each node in the linux cluster. 
The host_info table schema is as follows:

FIELD NAMES | DATA TYPES | DATA CONSTRAINTS
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


#### `Host_Usage Table`
The host_usage table stores the resource usage information of the linux server. 
This table automatically is updated every minute. 
The table schema is as follows:

FIELD NAMES | DATA TYPES | DATA CONSTRAINTS
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
Because this is a **MVP** all tests were carried out on a single node. However, the monitoring agent scripts `host_info.sh` and `host_usage.sh` can be used to collect and send data from multiple nodes and still achieve the same results.

The scripts in LCMA are written to **`fail-fast`**. If any of the input arguments are incorrect, the script will terminate with an **error** and **exit code** which is not equals to zero. Each script in the developed project was tested **manually** by comparing the execution outcomes with the expected results:

The **`psql_docker.sh`** script was tested using the bash terminal. It was verified that the docker container with postgres server was successfully created, started and stopped. The command **`docker ps`** is useful to test the starting and stopping of the docker container.

**`ddl.sql`** was tested manually by executing it in the terminal and checking if the database and tables were successfully created using the following commands:
- Open PSQL editor to check if database is created: `psql -h localhost -U [username] -W`
- List all tables to confirm if tables have been created: `postgres=# \dt`

**`queries.sql`** was tested by inserting synthetic data into a mock database and running the queries and comparing the results produced to the expected results.

The **`host_info.sh`** and **`host_usage.sh`** scripts were tested by running them and querying the corresponding tables to verify the insert operations. Similarly, the correct configuration of schedule crontab is verified by ensuring that a new entry is inserted every minute.

The **`queries.sql`** script was tested by generating data and running the queries on it.


## Improvements
1. Improve the psql_docker script to create any new docker container, not just jrvs-pql container.
2. Write additional SQL queries in queries.sql and  additional scripts to analyse the data and identify patterns of system failure, traffic anomalies, network traffic predictions.
3. Write additional scripts to create automated alerts when high risk patterns are detected in order to avoid system / network failure, for example a DOS attack. 
4. Expand the scope of this project by writing scripts that will provide support across multiple environments, not just a linux based cluster.

