select tablespace_name ,
       t.Status,
       t.CONTENTS,
       t.LOGGING,
       t.EXTENT_MANAGEMENT,
       t.ALLOCATION_TYPE,
       t.PLUGGED_IN,
       t.segment_space_management,
       trunc((d.tbs_size-nvl(s.free_space, 0))/1024/1024) ktbs_em_uso,
       trunc(d.tbs_size/1024/1024) ktbs_size,
       trunc(d.tbs_maxsize/1024/1024) ktbs_maxsize,
       trunc(nvl(s.free_space, 0)/1024/1024) kfree_space,
       trunc((d.tbs_maxsize - d.tbs_size + nvl(s.free_space, 0))/1024/1024) kspace,
       round(decode(d.tbs_maxsize, 0, 0, (d.tbs_size-nvl(s.free_space, 0))*100/d.tbs_maxsize),4) kperc
from
( select SUM(bytes) tbs_size,
SUM(decode(sign(maxbytes - bytes), -1, bytes, maxbytes)) tbs_maxsize,
tablespace_name tablespace
from ( select nvl(bytes, 0) bytes, nvl(maxbytes, 0) maxbytes, tablespace_name
from dba_data_files
union all
select nvl(bytes, 0) bytes, nvl(maxbytes, 0) maxbytes, tablespace_name
from dba_temp_files
)
group by tablespace_name
) d,
( select SUM(bytes) free_space,
tablespace_name tablespace
from dba_free_space
group by tablespace_name
) s,
dba_tablespaces t
where t.tablespace_name = d.tablespace(+) and
t.tablespace_name = s.tablespace(+)
order by 1;
