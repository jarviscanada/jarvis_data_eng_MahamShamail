#!/bin/bash
#This script:
# 1. collects hardware specification data
# 2. inserts the data to the psql instance.
# hardware specifications are static therefore script will be executed only once.

#validate number of arguments
if [ "$#" -ne 5 ];
then
  echo "ERROR: Invalid number of arguments"
  exit 1
fi

#assign CLI arguments to variables (e.g. `psql_host=$1`)
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

export PGPASSWORD=$psql_password

#save cpu, mem info
lscpu_out=$(lscpu)
memory_info=$(cat /proc/meminfo)

hostname=$psql_host
#parse host hardware specifications using bash cmds
#hardware
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "Model name:" | awk '{print $3" "$4" "$5}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{print $3}' | sed 's/[^0-9]*//g' | xargs)
total_mem=$(echo "$memory_info" | egrep "MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(date +%F" "%T) #current timestamp in `2019-11-26 14:40:19` format

echo "cpu_number=$cpu_number"
echo "cpu_architecture=$cpu_architecture"
echo "cpu_model=$cpu_model"
echo "cpu_mhz=$cpu_mhz"
echo "l2_cache=$l2_cache"
echo "total_mem=$total_mem"
echo "timestamp= $timestamp"

#construct the INSERT statement
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp)
VALUES ('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$total_mem', '$timestamp');"

#execute the INSERT statement through psql CLI tool
psql -h "$hostname" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"

exit $?
