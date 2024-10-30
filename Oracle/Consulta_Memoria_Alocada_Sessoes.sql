SELECT round(Trunc(b.value/1024)/1024,2) AS memory_allocation_mb
     , a.username 
     , a.sid
     , a.serial#
     , a.status
     , a.machine
     , a.port
     , a.program
     , a.logon_time
     , a.blocking_session_status
     , a.type
     , b.*
     , c.*
  FROM v$session a,
       v$sesstat b,
       v$statname c
 WHERE a.sid = b.sid
   AND b.statistic# = c.statistic#
   AND c.name = 'session pga memory'
   AND a.program IS NOT NULL
   AND a.type = 'USER'
 ORDER BY memory_allocation_mb DESC  
