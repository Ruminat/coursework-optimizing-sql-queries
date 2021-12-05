import {
  createCounter,
  randomFrom,
  randomInt,
  generateSurnameEn,
  generateNameEn,
  generateEmail,
  generatePhoneNumber
} from "../../utils.js"
import { customerStartId, customersCount } from "../../definitions.js"

export function generateCustomers () {
  const customers = []
  for (let i = customerStartId; i < customerStartId + customersCount; i++) {
    customers.push(generateCustomer(i))
  }
  return customers.join("\n")
}

function generateCustomer (i) {
  const columns = `customer_id, cust_first_name, cust_last_name, gender`
  const values = [
    `${i}`,
    `'${generateNameEn(i)}'`,
    `'${generateSurnameEn(i)}'`,
    `'${randomInt(0, 1) === 1 ? "M" : "F"}'`,
  ].join(", ")
  return `INSERT INTO oe.customers (${columns}) VALUES (${values});`
}

// delete from oe.customers where customer_id > 1000;

