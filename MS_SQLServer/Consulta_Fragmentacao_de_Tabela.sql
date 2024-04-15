DECLARE @db_id INT;  
DECLARE @object_id INT;  

SET @db_id = db_id(N'database');  
SET @object_id = OBJECT_ID(N'table');  

SELECT * 
  FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'LIMITED');    
GO