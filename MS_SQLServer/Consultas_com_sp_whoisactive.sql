
--Listar sessões e o plano de execução (se estiver disponível)
exec sp_whoisactive @get_plans=2;

--Listar locks
exec sp_WhoIsActive @find_block_leaders = 1, @sort_order = '[blocked_session_count] DESC';

--Lista sessoes, com o plano se disponível e locks de objetos
Exec sp_whoisactive @get_plans=2, @get_locks=1;

--Lista sessoes com informacoes adicionais da conexao, idioma, formato de data, etc
exec sp_whoisactive @get_additional_info=1