select (total_exec_time/calls)::integer as avg_time_ms
     , a.calls
     , c.datname
     , b.usename
     , a.rows
     , a.query
  from pg_stat_statements a
  join pg_user b on a.userid = b.usesysid
  join pg_database c on a.dbid = c.oid
 where 1=1
   --and b.usename <> 'xpto' 
   --and b.usename <> 'postgres'
 order by 1 desc;
