select round((sysdate - max(completion_time))*24*60) as minutes_last_completion_time
  from gv$backup_set bs
 where backup_type = 'L';
