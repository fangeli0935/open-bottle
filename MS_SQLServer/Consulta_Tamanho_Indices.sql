
DECLARE @INDEX_NAME VARCHAR(MAX) = 'name_of_index' 

SELECT top 100 
    s.[name] AS [schema],
    t.[name] AS [table_name],
    i.[name] AS [index_name],
    i.[type_desc],
    p.[rows] AS [row_count],
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [size_mb],
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [used_mb], 
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS [unused_mb],
	p.data_compression_desc,
	fileroup_name = f.name
FROM
    sys.tables t
    JOIN sys.indexes i ON t.[object_id] = i.[object_id]
    JOIN sys.partitions p ON i.[object_id] = p.[object_id] AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.[partition_id] = a.container_id
    JOIN sys.filegroups f ON i.data_space_id = f.data_space_id
	LEFT JOIN sys.schemas s ON t.[schema_id] = s.[schema_id]
	
WHERE 
    t.is_ms_shipped = 0
    AND i.[object_id] > 255 
	and i.name = @INDEX_NAME
GROUP BY
    t.[name], 
    s.[name],
    i.[name],
    i.[type_desc],
    p.[rows],
	p.data_compression_desc,
	f.name
ORDER BY 
    [size_mb] DESC


SELECT [t].[name] AS [Table], 
       [i].[name] AS [Index],  
       [p].[partition_number] AS [Partition],
       [p].[data_compression_desc] AS [Compression]
FROM [sys].[partitions] AS [p]
INNER JOIN sys.tables AS [t] 
     ON [t].[object_id] = [p].[object_id]
INNER JOIN sys.indexes AS [i] 
     ON [i].[object_id] = [p].[object_id] AND i.index_id = p.index_id
WHERE [p].[index_id] not in (0,1)
  AND i.name = @INDEX_NAME