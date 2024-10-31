/* Todos os privilégios de uma role no banco */
SELECT 
    table_schema,
    table_name,
    privilege_type
FROM 
    information_schema.role_table_grants
WHERE 
    grantee = 'nome_da_role';

/* Saber se uma role pode criar arquivos temporarios */
SELECT 
    d.datname AS database,
    pg_catalog.pg_get_userbyid(d.datdba) AS owner,
    has_database_privilege(r.rolname, d.datname, 'TEMP') AS can_create_temp_tables
FROM 
    pg_database d
JOIN 
    pg_roles r ON r.rolname = 'nome_da_role';
