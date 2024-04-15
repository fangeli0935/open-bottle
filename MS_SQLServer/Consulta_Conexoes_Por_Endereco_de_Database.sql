SELECT s1.name AS databasename,
       decc.local_net_address,
       decc.local_tcp_port,
       s.spid,
       s.status,
       s.hostname,
       s.program_name
 FROM sys.sysprocesses AS S
 JOIN sys.dm_exec_connections AS decc ON S.spid = decc.session_id
 JOIN sys.sysdatabases s1 ON S.dbid = s1.dbid
WHERE S.net_library = 'TCP/IP'  
  AND S.status not in ('sleeping')
  AND s.spid != @@spid