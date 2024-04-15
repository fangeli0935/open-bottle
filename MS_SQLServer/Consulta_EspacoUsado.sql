
SELECT t1.type_desc AS Tipo
     , t2.name AS Filegrp
     , t1.name AS Datafile
     , t1.physical_name AS ArquivoFisico
     , t1.size / 128 AS TamanhoMB
     , CAST(t1.size / 128.0 - CAST(FILEPROPERTY(t1.name, 'SpaceUsed') AS INT) / 128.0 AS BIGINT) AS LivreMB
     , CAST(CAST(FILEPROPERTY(t1.name, 'SpaceUsed') AS INT) / 128.0 AS BIGINT) AS UsadoMB
     , CONCAT(CAST((CAST(FILEPROPERTY(t1.name, 'SpaceUsed') AS INT) / 128.0) / (t1.size / 128) * 100 AS BIGINT), '%') AS PercentualUtilizado
     , CONVERT(INT, dovs.available_bytes / 1048576.0) AS EspacoDiscoLivreMB
	 , (SELECT TOP 1 CAST((CAST(dovs.available_bytes AS DECIMAL(19, 2)) / CAST(dovs.total_bytes AS DECIMAL(19, 2)) * 100) AS DECIMAL(10, 2)) AS PercentualLivreDisco FROM sys.master_files mf CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) dovs WHERE mf.file_id = t1.file_id) AS PercentualLivreDisco
      FROM sys.database_files t1
 LEFT JOIN sys.filegroups t2 ON t2.data_space_id = t1.data_space_id
INNER JOIN sys.master_files mf ON mf.file_id = t1.file_id AND DB_ID() = mf.database_id
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) dovs
ORDER BY t2.data_space_id;