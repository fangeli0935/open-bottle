
select a.* 
  from pg_stat_activity a
 where a.query_start <= NOW() - INTERVAL '1 HOUR'
   and a.state <> 'idle'
   and a.datname = 'database_name'