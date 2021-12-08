DROP INDEX emp_name_ix;
CREATE INDEX emp_name_ix ON hr.employees (first_name, last_name);

DROP INDEX employees_last_name_idx;
CREATE INDEX employees_last_name_idx ON hr.employees (last_name);


EXEC DBMS_STATS.GATHER_TABLE_STATS('HR', 'EMPLOYEES');
EXEC DBMS_STATS.GATHER_TABLE_STATS('HR', 'DEPARTMENTS');


-- original
SELECT first_name
FROM hr.employees
GROUP BY first_name
HAVING COUNT(*) >= 3
MINUS
SELECT hr.employees.first_name
FROM hr.employees
  JOIN (
    SELECT manager_id
    FROM hr.employees
    WHERE manager_id IS NOT NULL
    UNION ALL
    SELECT manager_id
    FROM hr.departments
    WHERE manager_id IS NOT NULL
  ) manager_ids
  ON hr.employees.employee_id = manager_ids.manager_id;

SELECT first_name
FROM hr.employees
GROUP BY first_name
HAVING COUNT(*) >= 3
MINUS
SELECT hr.employees.first_name
FROM hr.employees
  JOIN (
    SELECT NVL(hr.employees.manager_id, hr.departments.manager_id) as manager_id
    FROM hr.employees
      JOIN hr.departments
        ON hr.employees.manager_id IS NOT NULL
          OR hr.departments.manager_id IS NOT NULL
  ) manager_ids
  ON hr.employees.employee_id = manager_ids.manager_id;

-- with NOT EXISTS
SELECT upper_employees.first_name
FROM hr.employees upper_employees
WHERE NOT EXISTS (
  SELECT hr.employees.first_name
  FROM hr.employees
    JOIN (
      SELECT manager_id
      FROM hr.employees
      WHERE manager_id IS NOT NULL
      UNION ALL
      SELECT manager_id
      FROM hr.departments
      WHERE manager_id IS NOT NULL
    ) manager_ids
    ON hr.employees.employee_id = manager_ids.manager_id
  WHERE hr.employees.first_name = upper_employees.first_name
)
GROUP BY upper_employees.first_name
HAVING COUNT(*) >= 3;


SELECT * FROM hr.employees_names_mview;

GRANT CREATE MATERIALIZED VIEW TO HR;
GRANT ON COMMIT REFRESH TO HR;

CREATE MATERIALIZED VIEW LOG ON hr.employees WITH ROWID (employee_id) INCLUDING NEW VALUES;

-- materialized view
CREATE MATERIALIZED VIEW employees_names_mview
  BUILD IMMEDIATE
  REFRESH COMPLETE
    AS
      SELECT first_name
      FROM hr.employees
      GROUP BY first_name
      HAVING COUNT(*) >= 3
      MINUS
      SELECT hr.employees.first_name
      FROM hr.employees
        JOIN (
          SELECT manager_id
          FROM hr.employees
          WHERE manager_id IS NOT NULL
          UNION ALL
          SELECT manager_id
          FROM hr.departments
          WHERE manager_id IS NOT NULL
        ) manager_ids
        ON hr.employees.employee_id = manager_ids.manager_id;
