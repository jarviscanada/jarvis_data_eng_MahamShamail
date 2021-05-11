-- DATA DEFINITION LANGUAGE (DDL):
--1. used to define the database schema
--2. and to create and modify the structure of database objects
-- CREATE ? is used to create the database or its objects (like table, index, function, views, store procedure and triggers).
-- DROP ? is used to delete objects from the database.
-- ALTER-is used to alter the structure of the database.
-- TRUNCATE?is used to remove all records from a table, including all spaces allocated for the records are removed.
-- COMMENT ?is used to add comments to the data dictionary.
-- RENAME ?is used to rename an object existing in the database.

-- create two tables: host_ifo and host_usage

--host_info:  to store hardware specifications
CREATE TABLE IF NOT EXISTS PUBLIC.host_info(
    id SERIAL NOT NULL,
    hostname VARCHAR NOT NULL,
    cpu_number INTEGER NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz NUMERIC NOT NULL,
    L2_cache INTEGER NOT NULL,
    total_mem INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(hostname));

--host_usage: to store resource usage data
CREATE TABLE IF NOT EXISTS PUBLIC.host_usage(
    timestamp TIMESTAMP NOT NULL,
    host_id SERIAL NOT NULL REFERENCES host_ifo (id),
    memory_free INTEGER NOT NULL,
    cpu_idle SMALLINT NOT NULL,
    cpu_kernel SMALLINT NOT NULL,
    disk_io INTEGER NOT NULL,
    disk_available INTEGER NOT NULL
);

-- psql -h localhost -U postgres -d host_agent -f sql/ddl.sql