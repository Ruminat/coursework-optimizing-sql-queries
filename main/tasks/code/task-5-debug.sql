DROP INDEX employees_salary_job_idx;
CREATE BITMAP INDEX employees_salary_job_idx ON hr.employees (salary DESC, job_id);
EXEC DBMS_STATS.GATHER_TABLE_STATS('HR', 'EMPLOYEES');

/*+PARALLEL*/

SELECT * FROM hr.employees_job_salary_mview;

-- materialized view
CREATE MATERIALIZED VIEW employees_job_salary_mview
  BUILD IMMEDIATE
  REFRESH COMPLETE
    AS
      SELECT
        job_id AS "Job ID",
        salary AS "Salary",
        -- CAST нужен для того, чтобы список помещался в одну строчку.
        CAST(
          LISTAGG(last_name, ', ')
            WITHIN GROUP (ORDER BY last_name)
          AS VARCHAR2(64)
        ) AS "Surnames"
      FROM hr.employees
      GROUP BY job_id, salary
      HAVING COUNT(*) > 1
      ORDER BY "Salary" DESC, "Job ID";

-- OG
SELECT
  job_id AS "Job ID",
  salary AS "Salary",
  -- CAST нужен для того, чтобы список помещался в одну строчку.
  CAST(
    LISTAGG(last_name, ', ')
      WITHIN GROUP (ORDER BY last_name)
    AS VARCHAR2(64)
  ) AS "Surnames"
FROM hr.employees
GROUP BY job_id, salary
HAVING COUNT(*) > 1
ORDER BY "Salary" DESC, "Job ID";


-- IOT
DROP TABLE employee_lookup PURGE;
CREATE TABLE employee_lookup (
  employee_id,
  last_name,
  job_id,
  salary,
  CONSTRAINT employee_lookup_pk PRIMARY KEY (employee_id)
)
ORGANIZATION INDEX
AS
  SELECT
    employee_id,
    job_id,
    last_name,
    salary
  FROM hr.employees;

SELECT
  job_id AS "Job ID",
  salary AS "Salary",
  -- CAST нужен для того, чтобы список помещался в одну строчку.
  CAST(
    LISTAGG(last_name, ', ')
      WITHIN GROUP (ORDER BY last_name)
    AS VARCHAR2(64)
  ) AS "Surnames"
FROM hr.employee_lookup
GROUP BY job_id, salary
HAVING COUNT(*) > 1
ORDER BY "Salary" DESC, "Job ID";
