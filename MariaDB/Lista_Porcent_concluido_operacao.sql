SELECT 
    EVENT_NAME, 
    WORK_COMPLETED, 
    WORK_ESTIMATED, 
    ROUND(WORK_COMPLETED / WORK_ESTIMATED * 100, 2) AS "% Complete" 
FROM 
    performance_schema.events_stages_current 
WHERE 
    EVENT_NAME LIKE 'stage/innodb/alter%';
