#!/bin/bash

if [ "$#" -ne 5 ];
then
  echo "Invalid number of arguments."
  exit 1
fi

#assign CLI arguments to variables (e.g. `psql_host=$1`)
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

export PGPASSWORD=$psql_password

timestamp=$(vmstat -t | egrep -v 'timestamp|UTC' | awk '{ print $18" "$19 }' | xargs)
#host_id=$()
memory_free=$(vmstat --unit MB | egrep -v 'memory|free' | awk '{print $4}' | xargs)
cpu_idle=$(vmstat | egrep -v 'cpu|id' | awk '{print $15}' | xargs)
cpu_kernel=$(vmstat -t | tail -1 | awk '{print $14}' | xargs)
disk_io=$(vmstat -d | egrep -v 'IO|cur' | awk '{ print $10 }' | xargs)
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed "s/M//" | xargs)

echo "timestamp= $timestamp"
echo "cpu_idle =$cpu_idle"
echo "cpu_kernel =$cpu_kernel"
echo "disk_io =$disk_io"
echo "disk_available =$disk_available"
insert_stmt="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
SELECT '$timestamp', host_info.id, '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io', '$disk_available'
FROM host_info
WHERE host_info.hostname='$psql_host';"

psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"

exit $?