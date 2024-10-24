-- This statement is a MariaDB extension. It returns the exact string that can be used to re-create the named stored procedure, 
--  as well as the SQL_MODE that was used when the trigger has been created and the character set used by the connection.
-- https://mariadb.com/kb/en/show-create-procedure/

-- !!! Warning Users with SELECT privileges on mysql.proc or USAGE privileges on *.* can view the text of routines, 
--  even when they do not have privileges for the function or procedure itself.
--  ou seja, vc tambem pode usar uma consulta na mysql.proc para ver os dados se tiver acesso nela.

SHOW CREATE PROCEDURE banco.sp_xpto\G

SHOW CREATE FUNCTION banco.fn_xyz\G

SHOW CREATE SEQUENCE sq_xpto\G

-- Outros comandos presentes no SHOW

SHOW CREATE TABLE tbl_name\G

SHOW CREATE TRIGGER trigger_name\G

SHOW CREATE USER [user]\G

SHOW CREATE VIEW example\G

-- Lista completa disponível em https://mariadb.com/kb/en/show/