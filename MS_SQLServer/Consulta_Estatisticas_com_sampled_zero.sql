declare @lockTimeout int = 5000;
declare @percentColletion int = 5;

 SELECT * 
    FROM (
          SELECT S.object_id
               , sch.name AS schema_name
               , ao.name AS object_name
               , s.name AS stat_name
               , sp.rows
               , sp.rows_sampled
               , (sp.rows_sampled * 100)/sp.rows AS sampled_percent
               , sp.modification_counter
			   , sp.last_updated               
			   , s.auto_created
               , CONCAT('SET LOCK_TIMEOUT ',@lockTimeout,'; update statistics ',QUOTENAME(DB_NAME()),'.',QUOTENAME(sch.name),'.',QUOTENAME(ao.name), ' ', QUOTENAME(s.name), ' WITH SAMPLE ',@percentColletion,' PERCENT;') AS sqlcmd
            FROM sys.stats s
     CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
            JOIN sys.all_objects ao on ao.object_id = s.object_id
	        JOIN sys.schemas sch on sch.schema_id = ao.schema_id
           WHERE ao.is_ms_shipped = 0
             AND s.no_recompute = 0
             AND sp.rows IS NOT NULL
	      ) V
    WHERE sampled_percent = 0
