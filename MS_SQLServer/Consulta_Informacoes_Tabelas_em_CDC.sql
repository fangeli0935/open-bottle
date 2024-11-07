SELECT * 
  FROM cdc.change_tables AS c
 INNER JOIN sys.tables AS t ON (c.[source_object_id] = t.[object_id])
 INNER JOIN sys.schemas AS s ON (t.[schema_id] = s.[schema_id])


SELECT ( SELECT    CC.column_name + ','
          FROM      cdc.captured_columns CC
                    INNER JOIN cdc.change_tables CT ON CC.[object_id] = CT.[object_id]
          WHERE     capture_instance = 'dbo_TABELA'
                    AND sys.fn_cdc_is_bit_set(CC.column_ordinal,
                                              PD.__$update_mask) = 1
        FOR
          XML PATH('')
        ) AS changedcolumns, *
FROM    cdc.dbo_TABELA_CT PD where COLUNA = VALOR
