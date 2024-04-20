SELECT 
  t1.hostname AS HostName,
  (select top 1 t3.client_net_address from sys.dm_exec_connections t3 where t3.session_id = t1.spid) client_net_address,
       DB_NAME(dbid) [DatabaseName],
       t1.hostprocess AS HostProcess,
       t1.loginame AS LogiName,
       t1.spid AS Spid,
       t1.blocked AS Blocked,
       t1.cpu AS Cpu,
       t1.physical_io AS PhysicalIO,
       t1.memusage AS MemUsage,
       t1.status AS [Status],
       t1.waittime AS WaitTime,
       t1.lastwaittype AS LastWaitType,
       (
      SELECT [text] AS [query_text] FROM sys.dm_exec_sql_text(sql_handle) --(SELECT TEXT FROM ::fn_get_sql(SQL_Handle)) AS Comando_SQL, 
       ) AS SQLBatch,
    WaitResource,
     CASE transaction_isolation_level
    WHEN 0 THEN
      'Unspecified'
    WHEN 1 THEN
      'ReadUncommitted'
    WHEN 2 THEN
      'ReadCommitted'
    WHEN 3 THEN
      'Repeatable'
    WHEN 4 THEN
      'Serializable'
    WHEN 5 THEN
      'Snapshot'
  END AS IsolationLevel,
       t1.login_time AS LoginTime,
       t1.last_batch AS LastBatch,
       GETDATE() AS ScanDate,
       CASE
           WHEN t1.last_batch > sqlserver_start_time THEN
               DATEDIFF_BIG(SECOND, t1.last_batch, GETDATE())
           ELSE
               0
       END AS LastBatchStartedInSec,
       t1.open_tran OpenTran,
       t1.program_name ProgramName,
       'Kill ' + CAST(t1.spid AS VARCHAR(8)) + ';'    AS CmdToKill
FROM master.dbo.sysprocesses t1
INNER JOIN sys.dm_exec_sessions t2
    ON t2.session_id = t1.spid
CROSS APPLY sys.dm_os_sys_info si
