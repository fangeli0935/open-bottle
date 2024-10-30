SELECT count(*) as available_redo
  from v$log t 
 where t.status in ('INACTIVE', 'UNUSED')
