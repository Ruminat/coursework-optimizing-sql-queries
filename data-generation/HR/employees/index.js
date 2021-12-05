import {
  createCounter,
  randomFrom,
  randomInt,
  generateSurnameRu,
  generateSurnameEn,
  generateNameEn,
  generateEmail,
  generatePhoneNumber
} from "../../utils.js"
import { employeeStartId, employeesCount } from "../../definitions.js"
import { jobIds, departmentIds, firstNames, salaries } from "./definitions.js"

const employeeCounter = createCounter(employeeStartId)
const getEmployeeId = () => employeeCounter()

export function generateEmployees () {
  const employees = []
  for (let i = employeeStartId; i < employeeStartId + employeesCount; i++) {
    employees.push(generateEmployee(i))
  }
  return employees.join("\n")
}

function generateEmployee (i) {
  const columns = `employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id`
  const values = [
    `${getEmployeeId()}`,
    `'${randomFrom(firstNames)}'`,
    `'${generateSurnameEn(i)}'`,
    `'${generateEmail(i)}'`,
    `'${generatePhoneNumber(i)}'`,
    `TO_DATE('12.06.1999', 'dd.mm.yyyy')`,
    `'${randomFrom(jobIds)}'`,
    `${randomFrom(salaries)}`,
    `0`,
    `${randomInt(200, 206)}`,
    `'${randomFrom(departmentIds)}'`,
  ].join(", ")
  return `INSERT INTO employees (${columns}) VALUES (${values});`
}

// delete from hr.employees where employee_id > 1000;
