SELECT JobName      = j.name
     , ScheduleName = s.name
	 , js.next_run_date
	 , js.next_run_time   
	 , s.active_start_date	 
	 , s.active_start_time
  FROM msdb.dbo.sysjobs AS j
  LEFT JOIN msdb.dbo.sysjobschedules AS js ON j.job_id = js.job_id
  LEFT JOIN msdb.dbo.sysschedules AS s ON js.schedule_id = s.schedule_id