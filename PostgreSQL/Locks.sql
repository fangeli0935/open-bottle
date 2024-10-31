--
select pid, 
       'SELECT pg_terminate_backend('||pid||');' as killcmd,
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
  from pg_stat_activity
 where cardinality(pg_blocking_pids(pid)) > 0;


--
SELECT bl.pid     AS blocked_pid,
       a.usename  AS blocked_user,
       kl.pid     AS blocking_pid,
       ka.usename AS blocking_user,
       a.query    AS blocked_statement
 FROM pg_catalog.pg_locks         bl
 JOIN pg_catalog.pg_stat_activity a  ON a.pid = bl.pid
 JOIN pg_catalog.pg_locks         kl ON kl.transactionid = bl.transactionid AND kl.pid != bl.pid
 JOIN pg_catalog.pg_stat_activity ka ON ka.pid = kl.pid
WHERE NOT bl.granted;


--
;with recursive 
    find_the_source_blocker as (
        select  pid
               ,pid as blocker_id
        from pg_stat_activity pa
        where pa.state<>'idle'
              and array_length(pg_blocking_pids(pa.pid), 1) is null

        union all

        select              
                t.pid  as  pid
               ,f.blocker_id as blocker_id
        from find_the_source_blocker f 
        join (  SELECT
                    act.pid,
                    blc.pid AS blocker_id
                FROM pg_stat_activity AS act
                LEFT JOIN pg_stat_activity AS blc ON blc.pid = ANY(pg_blocking_pids(act.pid))
                where act.state<>'idle') t on f.pid=t.blocker_id
        )
    
select distinct 
       s.pid
      ,s.blocker_id
      ,pb.usename       as blocker_user
      ,pb.query_start   as blocker_start
      ,pb.query         as blocker_query
      ,pt.query_start   as trans_start
      ,pt.query         as trans_query
from find_the_source_blocker s
join pg_stat_activity pb on s.blocker_id=pb.pid
join pg_stat_activity pt on s.pid=pt.pid
where s.pid<>s.blocker_id