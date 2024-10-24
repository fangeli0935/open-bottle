
--Privilegios do usuario
select * 
  from information_schema.user_privileges 
 where grantee like '%usuario%'

--Privilegios no schema
select * 
  from information_schema.SCHEMA_PRIVILEGES 
 where grantee like '%usuario%'
