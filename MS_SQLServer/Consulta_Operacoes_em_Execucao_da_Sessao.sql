-- defina a session_id ou informe zero para exibir todas as sessoes
DECLARE @spid int = 0

SELECT physical_operator_name, 
       SUM(row_count) row_count, 
       SUM(estimate_row_count) AS estimate_row_count,
       IIF(SUM(estimate_row_count) = 0,0,CAST(SUM(row_count)*100 AS float)/SUM(estimate_row_count))  as estimate_percent_complete	   
FROM sys.dm_exec_query_profiles   
WHERE (session_id = @spid or @spid = 0)
GROUP BY node_id,physical_operator_name  
ORDER BY node_id desc;

SELECT session_id
     , sql_handle
	 , plan_handle
	 , physical_operator_name
	 , node_id
	 , row_count
	 , estimate_row_count
	 , first_active_time
	 , last_active_time
	 , elapsed_time_ms
  FROM sys.dm_exec_query_profiles   
 WHERE (session_id = @spid or @spid = 0)