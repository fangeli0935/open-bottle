SELECT 
    d.datname AS database,
    pg_catalog.pg_get_userbyid(d.datdba) AS owner,
    has_database_privilege(r.rolname, d.datname, 'TEMP') AS can_create_temp_tables
FROM 
    pg_database d
JOIN 
    pg_roles r ON r.rolname = 'nome_da_role';
