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