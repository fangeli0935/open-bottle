SELECT 
       clock_timestamp() - a.xact_start                          AS duration_so_far,
       coalesce(a.wait_event_type ||'.'|| a.wait_event, 'false') AS waiting,
       a.state,
       p.phase,
       CASE p.phase
           WHEN 'initializing' THEN '1 of 12'
           WHEN 'waiting for writers before build' THEN '2 of 12'
           WHEN 'building index: scanning table' THEN '3 of 12'
           WHEN 'building index: sorting live tuples' THEN '4 of 12'
           WHEN 'building index: loading tuples in tree' THEN '5 of 12'
           WHEN 'waiting for writers before validation' THEN '6 of 12'
           WHEN 'index validation: scanning index' THEN '7 of 12'
           WHEN 'index validation: sorting tuples' THEN '8 of 12'
           WHEN 'index validation: scanning table' THEN '9 of 12'
           WHEN 'waiting for old snapshots' THEN '10 of 12'
           WHEN 'waiting for readers before marking dead' THEN '11 of 12'
           WHEN 'waiting for readers before dropping' THEN '12 of 12'
       END AS phase_progress,
       format(
           '%s (%s of %s)',
           coalesce(round(100.0 * p.blocks_done / nullif(p.blocks_total, 0), 2)::text || '%', 'not applicable'),
           p.blocks_done::text,
           p.blocks_total::text
       ) AS scan_progress,
       format(
           '%s (%s of %s)',
           coalesce(round(100.0 * p.tuples_done / nullif(p.tuples_total, 0), 2)::text || '%', 'not applicable'),
           p.tuples_done::text,
           p.tuples_total::text
       ) AS tuples_loading_progress,
       format(
           '%s (%s of %s)',
           coalesce((100 * p.lockers_done / nullif(p.lockers_total, 0))::text || '%', 'not applicable'),
           p.lockers_done::text,
           p.lockers_total::text
       ) AS lockers_progress,
       format(
           '%s (%s of %s)',
           coalesce((100 * p.partitions_done / nullif(p.partitions_total, 0))::text || '%', 'not applicable'),
           p.partitions_done::text,
           p.partitions_total::text
       ) AS partitions_progress,
       p.current_locker_pid,
       trim(trailing ';' from l.query) AS current_locker_query
  FROM pg_stat_progress_create_index   AS p
  JOIN pg_stat_activity                AS a ON a.pid = p.pid
  LEFT JOIN pg_stat_activity           AS l ON l.pid = p.current_locker_pid
 ORDER BY clock_timestamp() - a.xact_start DESC;