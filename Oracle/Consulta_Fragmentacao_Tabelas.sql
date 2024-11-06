SELECT      
  owner, 
  table_name,  
  avg_row_len,     
  ROUND(((blocks*16/1024)),2) || 'MB' AS "TOTAL_SIZE",     
  ROUND((num_rows*avg_row_len/1024/1024),2) || 'MB' AS "ACTUAL_SIZE",     
  ROUND(((blocks*16/1024) - (num_rows*avg_row_len/1024/1024)),2) || 'MB' AS "FRAGMENTED_SPACE",     
  round((ROUND(((blocks*16/1024) - (num_rows*avg_row_len/1024/1024)),2) / ROUND(((blocks*16/1024)),2)),2) * 100 AS "PERCENTAGE",
  ROUND(SYSDATE - LAST_ANALYZED)
FROM DBA_TABLES T
WHERE ROUND(((blocks*16/1024)),2) > 0 
--AND ROUND(SYSDATE - LAST_ANALYZED) >= 7
AND ROUND(((blocks*16/1024) - (num_rows*avg_row_len/1024/1024)),2) > 10
--ORDER BY 6 DESC
ORDER BY PERCENTAGE DESC;
