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