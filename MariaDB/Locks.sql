select concat('kill ',it.trx_mysql_thread_id, ';') as killcmd
     , pl.user
     , pl.host
     , pl.db
     , it.trx_state
     , it.trx_started
     , it.trx_wait_started
     , it.trx_query
     , it.trx_mysql_thread_id as blocking_session
     , it.*
  from information_schema.processlist AS pl
  join information_schema.innodb_trx AS it ON pl.id = it.trx_mysql_thread_id
 order by it.trx_state DESC
 
 
 /* ----------------------- */
 
 SELECT b.trx_mysql_thread_id as blocking_session
     , pl.user as blocking_user
     , pl.host as blocking_host
     , pl.db as blocking_database
     , CONCAT('KILL ', b.trx_mysql_thread_id,';') as blocker_kill
     , time_to_sec(timediff(now(), b.trx_started)) AS trx_length_sec
     , '|-->|'
     , pl2.user as blocked_user
     , pl2.host as blocked_host
     , pl2.db as blocked_database
     , pl2.info
     , pl2.state
     ,'|--|'
     , w.*,b.*,r.*,pl.*,pl2.*
FROM information_schema.innodb_lock_waits w 
JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id 
JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id 
JOIN information_schema.innodb_locks lw ON lw.lock_trx_id = r.trx_id 
JOIN information_schema.innodb_locks lb ON lb.lock_trx_id = b.trx_id
JOIN information_schema.processlist pl ON pl.id = b.trx_mysql_thread_id
JOIN information_schema.processlist pl2 ON pl2.id = r.trx_mysql_thread_id
   ;
   
  
  
  