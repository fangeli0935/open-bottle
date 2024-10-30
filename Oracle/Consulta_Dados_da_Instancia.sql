SELECT INSTANCE_NAME
     , HOST_NAME
     , VERSION || '-' || EDITION AS VERSION
     , floor((SYSDATE - startup_time)*60*60*24) AS UPTIME
     , STATUS
     , ARCHIVER
     , (SELECT value FROM V$PARAMETER WHERE NAME = 'processes') - (SELECT COUNT(*) processos FROM v$process) as processos_restantes
     , (SELECT round(sum(bytes)/1024/1024,2) FROM V$SGASTAT where pool = 'shared pool') as used_shared_pool
     , (SELECT round(sum(bytes)/1024/1024,2) FROM V$SGASTAT where pool = 'large pool') as used_large_pool
     , (SELECT NVL(MBYTES,0) FROM (SELECT round(sum(bytes)/1024/1024,2) AS MBYTES FROM V$SGASTAT where pool = 'java pool')) as used_java_pool
     , (SELECT round(sum(bytes)/1024/1024,2) FROM V$SGASTAT where pool = 'streams pool') as used_streams_pool
     , (SELECT round(sum(bytes)/1024/1024,2) FROM V$SGASTAT) as TAMANHO_SGA
     , (select round(sysdate - max(completion_time),0) from v$backup_piece where tag like 'INCR_0') as DIASBKP 
  FROM v$instance;
