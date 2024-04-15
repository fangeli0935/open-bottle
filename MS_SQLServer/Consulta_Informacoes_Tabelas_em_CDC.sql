SELECT * 
  FROM cdc.change_tables AS c
 INNER JOIN sys.tables AS t ON (c.[source_object_id] = t.[object_id])
 INNER JOIN sys.schemas AS s ON (t.[schema_id] = s.[schema_id])