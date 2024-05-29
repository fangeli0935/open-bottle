SELECT table_name = t.name
     , column_name = ic.name
	 , ic.last_value
  FROM sys.identity_columns ic
  JOIN sys.tables t on t.object_id = ic.object_id
 ORDER BY t.name
GO 