SELECT 
    table_schema AS database_name,
    table_name,
    table_rows,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_MB,
    IF(ROW_FORMAT = 'COMPRESSED', 'Yes', 'No') AS comprimida,
    CASE 
        WHEN ROW_FORMAT = 'COMPRESSED' THEN '' 
        ELSE CONCAT('ALTER TABLE ', table_schema, '.', table_name, ' ROW_FORMAT=COMPRESSED;') 
    END AS cmd,
    CASE 
        WHEN ROW_FORMAT = 'COMPRESSED' THEN '' 
        ELSE ROUND((data_length + index_length) * 0.5 / 1024 / 1024, 2) 
    END AS estimado_compressao_mb
FROM 
    information_schema.tables
WHERE 
    table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')
ORDER BY 
    size_MB DESC, table_schema, table_name;