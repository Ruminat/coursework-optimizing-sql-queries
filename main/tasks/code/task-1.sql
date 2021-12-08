ACCEPT date CHAR PROMPT 'Enter date in format dd-mm-yyyy (e.g. 29-06-2007): '

SELECT
  '&date' AS "Date",
  100
    * COUNT(CASE WHEN oe.customers.gender = 'M' THEN 1 END)
    / COUNT(*)
    AS "Males (%)",
  100
    * COUNT(CASE WHEN oe.customers.gender = 'F' THEN 1 END)
    / COUNT(*)
    AS "Females (%)"
FROM
  oe.customers
    JOIN (
      SELECT DISTINCT customer_id
      FROM oe.orders
      WHERE
        TRUNC(order_date, 'dd')
          = TRUNC(TO_DATE('&date', 'dd-mm-yyyy'), 'dd')
    ) customer_ids
    ON oe.customers.customer_id = customer_ids.customer_id;