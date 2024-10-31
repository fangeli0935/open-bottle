select pg_user.usename, pg_roles.rolname, *
from pg_user 
join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
--where pg_user.usename='USERNAME'
--where rolname like '%_write' and lower(usename) not like '%dev'
;