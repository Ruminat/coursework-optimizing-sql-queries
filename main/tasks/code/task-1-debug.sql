DROP INDEX customers_gender_btmidx;
DROP INDEX orders_order_date_fnidx;

DROP INDEX customers_gender_btmidx;
CREATE BITMAP INDEX customers_gender_btmidx ON oe.customers (gender);


DROP INDEX orders_order_date_fnidx;
CREATE INDEX orders_order_date_fnidx ON oe.orders (TRUNC(order_date, 'dd'));
/*+ INDEX (orders orders_order_date_fnidx)*/ 

EXEC DBMS_STATS.GATHER_TABLE_STATS('OE', 'CUSTOMERS');
EXEC DBMS_STATS.GATHER_TABLE_STATS('OE', 'ORDERS');

SELECT
  '29-06-2007' AS "Date",
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
          = TRUNC(TO_DATE('29-06-2007', 'dd-mm-yyyy'), 'dd')
    ) customer_ids
    ON oe.customers.customer_id = customer_ids.customer_id;



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
