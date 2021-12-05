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