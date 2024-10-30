select round((1-(sum(getmisses)/sum(gets)))*100,2) as "CACHE_HIT_RATIO"
  from gv$rowcache;
