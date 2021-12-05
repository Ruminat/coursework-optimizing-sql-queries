import { createCounter, randomInt, randomFrom } from "../../utils.js"
import { customerStartId, customersCount, orderStartId } from "../../definitions.js"
import { dates } from "./definitions.js"

const courseIds = [`2001`, `2003`]

const orderCounter = createCounter(orderStartId)
const getOrderId = () => orderCounter()

export function generateOrders () {
  const orders = []
  for (let i = customerStartId; i < customerStartId + customersCount; i++) {
    const date = randomFrom(dates)
    const ordersCount = randomInt(0, 5)
    const customerId = i

    for (let order = 0; order < ordersCount; order++) {
      orders.push(generateOrder({ date, customerId }))
    }
  }
  return orders.join("\n")
}

function generateOrder ({ date = date1, customerId } = {}) {
  const columns = `order_id, order_date, customer_id`
  const values = `${getOrderId()}, ${date}, ${customerId}`
  return `INSERT INTO oe.orders (${columns}) VALUES (${values});`
}

// INSERT INTO oe.orders () VALUES ()

// select DISTINCT TRUNC(order_date, 'dd') AS "Date" from oe.orders;
// select DISTINCT TRUNC(order_date, 'dd') AS "Date" from oe.orders;


// 2450 11.04.07 17:18:10,362632                                                    direct           147            3        1636          159

