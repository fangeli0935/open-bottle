select sum(count(trunc(first_time))) trocas_dia
   from gv$log_history l
  where trunc(l.first_time) = trunc(sysdate)
  group by first_time
  order by first_time desc;
