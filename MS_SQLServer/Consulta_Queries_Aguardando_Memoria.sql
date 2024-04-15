SELECT mg.session_id
     , s.login_name
     , mg.granted_memory_kb
     , mg.requested_memory_kb
     , mg.ideal_memory_kb
     , mg.request_time
     , mg.grant_time
     , mg.query_cost
     , mg.dop
     , st.[TEXT]
     , qp.query_plan
  FROM sys.dm_exec_query_memory_grants AS mg
 CROSS APPLY sys.dm_exec_sql_text(mg.plan_handle) AS st
 CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
  JOIN sys.dm_exec_sessions s on s.session_id = mg.session_id
 ORDER BY mg.required_memory_kb DESC;