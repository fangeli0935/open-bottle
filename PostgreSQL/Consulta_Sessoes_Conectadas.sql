SELECT datname
     , usename
	 , application_name
	 , client_addr
	 , client_hostname
	 , client_port
	 , query_start
	 , query
	 , *
     --, 'select pg_terminate_backend('||pid||');' as killcmd 
 FROM pg_stat_activity
WHERE 1=1
  --AND (now() - pg_stat_activity.query_start) > interval '5 minutes'
  --AND datname = 'datalake'
  --AND usename = 'PowerBI'
ORDER BY backend_start DESC;