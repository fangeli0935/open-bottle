
SELECT s.login_name, 
       s.program_name, 
	   a.session_id,
       SUM(internal_objects_alloc_page_count) AS NumOfPagesAllocatedInTempDBforInternalTask,
       SUM(internal_objects_dealloc_page_count) AS NumOfPagesDellocatedInTempDBforInternalTask,
       SUM(user_objects_alloc_page_count) AS NumOfPagesAllocatedInTempDBforUserTask,
       SUM(user_objects_dealloc_page_count) AS NumOfPagesDellocatedInTempDBforUserTask
  FROM sys.dm_db_task_space_usage A
  JOIN sys.dm_exec_sessions s on s.session_id = a.session_id
 GROUP BY a.session_id, s.login_name, s.program_name
 ORDER BY NumOfPagesAllocatedInTempDBforInternalTask DESC, NumOfPagesAllocatedInTempDBforUserTask DESC