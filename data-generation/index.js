/*
  For changing constants like the number of employees, go to ./definitions.js
*/

import clipboardy from "clipboardy"

import { generateGroups } from "./STUDENT/group/index.js"
import { generateStudents } from "./STUDENT/student/index.js"
import { generateGrades } from "./STUDENT/grade/index.js"
import { generateEmployees } from "./HR/employees/index.js"
import { generateCustomers } from "./OE/customers/index.js"
import { generateOrders } from "./OE/orders/index.js"

generateStudentData()
// generateHrData()
// generateOeData()

function generateStudentData () {
  const code = getCode([generateGroups(), generateStudents(), generateGrades()])
  generate(code)
}

function generateHrData () {
  const code = getCode([generateEmployees()])
  generate(code)
}

function generateOeData () {
  const code = getCode([generateCustomers(), generateOrders()])
  generate(code)
}

function getCode (arr) {
  return arr.join("\n") + '\n'
}

function generate (code) {
  console.log(code)
  clipboardy.writeSync(code)
}
