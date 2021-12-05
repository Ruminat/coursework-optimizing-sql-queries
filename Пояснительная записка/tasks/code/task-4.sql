SELECT
  sh.customers.cust_last_name AS "Surname",
  sh.customers.cust_first_name AS "Name",
  SUM(sh.sales.amount_sold * sh.sales.quantity_sold) AS "Spent"
FROM sh.sales
  JOIN sh.customers
    ON sh.sales.cust_id = sh.customers.cust_id
  JOIN sh.channels
    ON sh.sales.channel_id = sh.channels.channel_id
  JOIN sh.promotions
    ON sh.sales.promo_id = sh.promotions.promo_id
WHERE
  sh.channels.channel_desc IN ('Internet', 'Partners')
    AND sh.promotions.promo_name = 'NO PROMOTION #'
    AND TRUNC(sh.sales.time_id, 'YEAR')
      = TRUNC(TO_DATE('1998', 'yyyy'), 'YEAR')
GROUP BY
  sh.customers.cust_id,
  sh.customers.cust_first_name,
  sh.customers.cust_last_name
ORDER BY "Spent" DESC
FETCH FIRST 1 ROWS ONLY;