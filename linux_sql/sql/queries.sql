--Group hosts by CPU number and sort by their memory size in descending order(within each cpu_number group)
SELECT cpu_number, id AS host_id, total_mem
FROM host_info
ORDER BY cpu_number, total_mem DESC;

--Average memory usage
CREATE FUNCTION round5(ts timestamp)
RETURNS timestamp AS $$
BEGIN
  RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION mem_usage(memory_free INTEGER, total_memory INTEGER )
RETURNS NUMERIC AS $$
BEGIN
    RETURN ((total_memory/1000) - memory_free) * 100 / (total_memory/1000);
END; $$ LANGUAGE PLPGSQL;

SELECT usage.host_id,
info.hostname AS host_name,
round5(usage.timestamp) AS time_stamp,
AVG(mem_usage(usage.memory_free , info.total_mem)) AS avg_used_mem_percentage
FROM host_info info JOIN host_usage usage ON info.id = usage.host_id
GROUP BY usage.host_id, host_name, time_stamp
ORDER BY host_id, time_stamp;

--Detect host failure
SELECT host_id,
round5(timestamp) AS time_stamp,
COUNT(*) AS num_data_points
FROM host_usage
GROUP BY host_id, time_stamp
HAVING COUNT(*) < 3
ORDER BY host_id, time_stamp;

