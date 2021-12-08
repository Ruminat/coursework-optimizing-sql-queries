## Connection strings

```bash
sqlplus sys/oracle@xepdb1 as sysdba
sqlplus hr/oracle@xepdb1
sqlplus oe/oracle@xepdb1
sqlplus student/oracle@xepdb1
sqlplus sh/oracle@xepdb1
```

```sql
CONNECT sys/oracle@xepdb1 as sysdba
CONNECT hr/oracle@xepdb1
CONNECT oe/oracle@xepdb1
CONNECT sh/oracle@xepdb1
CONNECT student/oracle@xepdb1
SET LIN 280
```

## Main stuff

```sql
-- Flush the shit and run the fucking query
alter system flush shared_pool;
alter system flush buffer_cache;
set autotrace on
@task-3.sql
set autotrace off

-- set timing off

-- Dumbass Bitch Indexes
SELECT
  CAST(ind.table_name AS VARCHAR2(36)) AS "Table",
  CAST(ind.index_name AS VARCHAR2(36)) AS "Index name",
  CAST(col.column_name AS VARCHAR2(36)) AS "Column",
  CAST(ind.index_type AS VARCHAR2(36)) AS "Index type"
FROM user_indexes ind
  INNER JOIN user_ind_columns col
    ON ind.index_name = col.index_name
-- WHERE ind.table_name = 'SALES'
ORDER BY 1, 2, 3, 4;

```

## Data

```sql
INSERT INTO grades (num, grade, exam_date, stud_num, course_num)
  VALUES (228, 4, TO_DATE('10.06.1999', 'dd.mm.yyyy'), 3412, 2001);

INSERT INTO student (stud_num, last_name, first_name, patronymic, scholarship, group_num)
  VALUES (9000, 'Фурман-1', 'Владос-1', 'Бандос-1', 228, 121);

INSERT INTO study_group (group_num, spec_num) VALUES (666, 1);
```

## Some shit, I don't know what it is

 (\d+) to \1

```sql
SELECT
  CAST(index_name as varchar2(36)) as "name",
  CAST(table_owner as varchar2(12)) "owner",
  CAST(table_name as varchar2(36)) "table-name",
  INCLUDE_COLUMN,
  CAST(uniqueness as varchar2(16)) "uniq"
from user_indexes;

SELECT
  CAST(table_name AS VARCHAR2(36)),
  CAST(column_name AS VARCHAR2(36)) 
FROM USER_IND_COLUMNS
ORDER BY 1, 2;
```