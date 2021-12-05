DROP INDEX sales_time_id_fnidx;
DROP INDEX sales_time_bix;
DROP INDEX customers_first_name_idx;
DROP INDEX customers_last_name_idx;

DROP INDEX sales_time_bix;
CREATE BITMAP INDEX sales_time_bix ON sh.sales (time_id) LOCAL NOLOGGING COMPUTE STATISTICS;

DROP INDEX sales_time_id_fnidx;
CREATE INDEX sales_time_id_fnidx ON sh.sales (TRUNC(time_id, 'YEAR'));
ALTER INDEX sh.sales_time_id_fnidx REBUILD;
EXEC DBMS_STATS.GATHER_TABLE_STATS('SH', 'SALES');

DROP INDEX customers_first_name_idx;
DROP INDEX customers_last_name_idx;
CREATE INDEX customers_first_name_idx ON sh.customers (cust_first_name);
CREATE INDEX customers_last_name_idx ON sh.customers (cust_last_name);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SH', 'CUSTOMERS');

DROP INDEX customers_cmpidx;
CREATE INDEX customers_cmpidx ON sh.customers (cust_id, cust_first_name, cust_last_name);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SH', 'CUSTOMERS');

-- IOT
CREATE TABLE customer_lookup (
  cust_id,
  cust_last_name,
  cust_first_name,
  CONSTRAINT customers_iot_pk PRIMARY KEY (cust_id)
)
ORGANIZATION INDEX
AS
  SELECT
    cust_id,
    cust_last_name,
    cust_first_name
  FROM sh.customers;

SELECT
  sh.customer_lookup.cust_last_name AS "Surname",
  sh.customer_lookup.cust_first_name AS "Name",
  SUM(sh.sales.amount_sold * sh.sales.quantity_sold) AS "Spent"
FROM sh.sales
  JOIN sh.customer_lookup
    ON sh.sales.cust_id = sh.customer_lookup.cust_id
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
  sh.customer_lookup.cust_id,
  sh.customer_lookup.cust_first_name,
  sh.customer_lookup.cust_last_name
ORDER BY "Spent" DESC
FETCH FIRST 1 ROWS ONLY;

-- original
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

-- BETWEEN
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
    AND sh.sales.time_id BETWEEN TO_DATE('01.01.1998', 'dd.mm.yyyy') AND TO_DATE('31.12.1998', 'dd.mm.yyyy')
GROUP BY
  sh.customers.cust_id,
  sh.customers.cust_first_name,
  sh.customers.cust_last_name
ORDER BY "Spent" DESC
FETCH FIRST 1 ROWS ONLY;

-- first_value
SELECT
  FIRST_VALUE("Surname") AS "Surname",
  FIRST_VALUE("Name") AS "Name",
  FIRST_VALUE("Spent") AS "Spent"
FROM (
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
);


-- OG
ACCEPT date CHAR PROMPT 'Enter year in format yyyy (e.g. 1998): '

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
      = TRUNC(TO_DATE('&date', 'yyyy'), 'YEAR')
GROUP BY
  sh.customers.cust_id,
  sh.customers.cust_first_name,
  sh.customers.cust_last_name
ORDER BY "Spent" DESC
FETCH FIRST 1 ROWS ONLY;

-- ROWNUM
SELECT *
FROM (
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
)
WHERE ROWNUM = 1;
