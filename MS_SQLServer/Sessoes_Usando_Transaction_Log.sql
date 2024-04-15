--transaction log usage
select  s.session_id,
        s.host_name, 
        s.login_name, 
        s.nt_domain + '\' + s.nt_user_name as [user_name],
        s.open_transaction_count as [tran_count],
        d.name as [database_name],
        d.log_reuse_wait_desc,
        r.command,
        s.status,
        cast((
                dt.database_transaction_log_bytes_reserved + 
                dt.database_transaction_log_bytes_reserved_system + 
                dt.database_transaction_log_bytes_used + 
                dt.database_transaction_log_bytes_used_system) / 1048576 as decimal(20, 2)) as used_log_size_mb,
         ls.total_log_size_mb
from sys.dm_exec_sessions s
inner join sys.dm_tran_session_transactions st  on s.session_id = st.session_id
inner join sys.dm_tran_database_transactions dt on st.transaction_id = dt.transaction_id
inner join sys.databases d with (nolock)        on dt.database_id = d.database_id
cross apply sys.dm_db_log_stats(dt.database_id) ls
left join sys.dm_exec_requests r                on s.session_id = r.session_id
where s.open_transaction_count > 0