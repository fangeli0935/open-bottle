SELECT ROUND(VALUE,2) as lib_cache_ratio
  FROM V$SYSMETRIC 
 WHERE GROUP_ID = 2
   AND metric_name = 'Library Cache Hit Ratio'
