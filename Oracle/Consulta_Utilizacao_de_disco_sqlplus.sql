prompt
prompt **** Estatisticas das tablespaces ****
prompt
PROMPT 
PROMPT S: STATUS                    = O-ONLINE    F-OFFLINE    R-READ ONLY
PROMPT C: CONTENTS                  = T-TEMPORARY P-PERMANENT  U-UNDO
PROMPT L: LOGGING                   = Y-YES       N-NO
PROMPT E: EXTENT MANAGEMENT         = L-LOCAL     D-DICTIONARY
PROMPT A: ALLOCATION TYPE           = S-SYSTEM    U-UNIFORM
PROMPT P: PLUGGED IN                = Y-YES       N-NO
PROMPT M: SEGMENT SPACE MANAGEMENT  = A-AUTO      M-MANUAL
PROMPT

set linesize 110 pages 200 feedback off

COL KTABLESPACE  FOR A30      HEADING 'Tablespace'
COL KTBS_SIZE    FOR 999,990  HEADING 'Size|atual'         JUSTIFY RIGHT
COL KTBS_EM_USO  FOR 999,990  HEADING 'Used'               JUSTIFY RIGHT
COL KTBS_MAXSIZE FOR 999,990  HEADING 'Max|size'           JUSTIFY RIGHT
COL KFREE_SPACE  FOR 999,990  HEADING 'Free|atual'         JUSTIFY RIGHT
COL KSPACE       FOR 999,990  HEADING 'Free|Max'           JUSTIFY RIGHT
COL KPERC        FOR 990.9    HEADING '% Max|size'         JUSTIFY RIGHT
col Status       for a1       HEADING 'S'                  trunc
col Contents     for a1       HEADING 'C'                  trunc
col Logging      for a1       HEADING 'L'                  trunc
col Management   for a1       HEADING 'E'                  trunc
col Allocation   for a1       HEADING 'A'                  trunc
col Plugged      for a1       HEADING 'P'                  trunc
col space        for a1       HEADING 'M'                  trunc

break on report
compute sum label Total: of ktbs_size on report
compute sum of ktbs_em_uso on report
compute sum of ktbs_maxsize on report

select tablespace_name ktablespace,
decode(t.Status, 'ONLINE','O','OFFLINE','F','READ ONLY','R') Status,
decode(t.CONTENTS, 'PERMANENT', 'P','TEMPORARY','T','UNDO','U') CONTENTS,
decode(t.LOGGING, 'LOGGING', 'Y','N') LOGGING,
SUBSTR(t.EXTENT_MANAGEMENT,1,1) Management,
decode(t.ALLOCATION_TYPE, 'SYSTEM','S','UNIFORM','U') Allocation,
SUBSTR(t.PLUGGED_IN,1,1) Plugged,
decode(t.segment_space_management,'AUTO','A','MANUAL','M') space,
trunc((d.tbs_size-nvl(s.free_space, 0))/1024/1024) ktbs_em_uso,
trunc(d.tbs_size/1024/1024) ktbs_size,
trunc(d.tbs_maxsize/1024/1024) ktbs_maxsize,
trunc(nvl(s.free_space, 0)/1024/1024) kfree_space,
trunc((d.tbs_maxsize - d.tbs_size + nvl(s.free_space, 0))/1024/1024) kspace,
decode(d.tbs_maxsize, 0, 0, (d.tbs_size-nvl(s.free_space, 0))*100/d.tbs_maxsize) kperc
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
