
 WITH tablespaces AS (
    SELECT
        spcname AS tbl_name,
        --coalesce(nullif(pg_tablespace_location(oid), ''), (current_setting('data_directory') || '/base')) AS tbl_location
	    coalesce(nullif(pg_tablespace_location(oid), ''), (current_setting('data_directory') )) AS tbl_location
    FROM pg_tablespace
),
tablespace_suffix AS (
    SELECT
        tbl_name,
        --tbl_location || '/pgsql_tmp' AS path
	    tbl_location AS path
    FROM tablespaces
    WHERE tbl_name = 'pg_default'
    UNION ALL
    SELECT
        tbl_name,
        tbl_location || '/' || path || '/pgsql_tmp'
    FROM tablespaces, LATERAL pg_ls_dir(tbl_location) AS path
    WHERE path ~ ('PG_' || substring(current_setting('server_version') FROM '^(?:\d\.\d\d?|\d+)'))
),
stat AS (
    SELECT
        substring(file from '\d+\d') AS pid,
        tbl_name AS temp_tablespace,
        pg_size_pretty(sum(pg_size_bytes(size))) AS size
    FROM tablespace_suffix, LATERAL pg_ls_dir(path, true, false) AS file,
    LATERAL pg_size_pretty((pg_stat_file(path || '/' || file, true)).size) AS size
    GROUP BY pid, temp_tablespace
)
SELECT
    a.datname,
    a.pid,
    coalesce(size, '0 MB') AS temp_size_written,
    coalesce(temp_tablespace, 'not using temp files') AS temp_tablespace,
    a.application_name,
    a.client_addr,
    a.usename,
    (clock_timestamp() - a.query_start)::interval(0) AS duration,
    (clock_timestamp() - a.state_change)::interval(0) AS duration_since_state_change,
    trim(trailing ';' FROM left(query, 1000)) AS query,
    a.state,
    a.wait_event_type || ':' || a.wait_event AS wait
FROM pg_stat_activity AS a
LEFT JOIN stat ON a.pid = stat.pid::int
WHERE a.pid != pg_backend_pid()
ORDER BY temp_size_written DESC;