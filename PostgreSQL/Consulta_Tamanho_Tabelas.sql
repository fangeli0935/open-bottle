select table_schema
     , table_name
	 , pg_size_pretty(pg_total_relation_size(quote_ident(table_schema) ||'.'|| quote_ident(table_name))), pg_relation_size(quote_ident(table_schema) ||'.'|| quote_ident(table_name))
  from information_schema.tables
 where table_type = 'BASE TABLE'
 order by pg_relation_size desc