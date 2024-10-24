
-- The Information Schema GLOBAL_STATUS and SESSION_STATUS tables store a record of all status variables and their global and session values respectively. 
-- This is the same information as displayed by the SHOW STATUS commands SHOW GLOBAL STATUS and SHOW SESSION STATUS.
-- https://mariadb.com/kb/en/information-schema-global_status-and-session_status-tables/

SELECT * FROM information_schema.GLOBAL_STATUS;


-- SHOW [GLOBAL | SESSION] STATUS
--     [LIKE 'pattern' | WHERE expr]
--
-- https://mariadb.com/kb/en/show-status/


SHOW STATUS;

SHOW GLOBAL STATUS;