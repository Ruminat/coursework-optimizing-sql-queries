Rem
Rem $Header: surr_test.sql 16-jan-2003.20:42:28 ahunold Exp $
Rem
Rem surr_test.sql
Rem
Rem Copyright (c) 2002, 2015, Oracle Corporation.  All rights reserved.  
Rem 
Rem Permission is hereby granted, free of charge, to any person obtaining
Rem a copy of this software and associated documentation files (the
Rem "Software"), to deal in the Software without restriction, including
Rem without limitation the rights to use, copy, modify, merge, publish,
Rem distribute, sublicense, and/or sell copies of the Software, and to
Rem permit persons to whom the Software is furnished to do so, subject to
Rem the following conditions:
Rem 
Rem The above copyright notice and this permission notice shall be
Rem included in all copies or substantial portions of the Software.
Rem 
Rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
Rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
Rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
Rem NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
Rem LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
Rem OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
Rem WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Rem
Rem    NAME
Rem      surr_test.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ahunold     01/16/03 - from _KEY to _ID
Rem    ahunold     10/15/02 - ahunold_oct_15_b
Rem    ahunold     10/14/02 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

--
-- Create a table that holds:
--	- Dimension name
--	- Column name for surrogate key at each level of the hierarchy
--	- All distinct data values per level
--

CREATE TABLE surr_test (
    dimension VARCHAR2(20),
    key_level VARCHAR2(30),
    key_value number);

INSERT INTO surr_test 
	SELECT 'CHANNELS','CHANNEL_ID',NUM_IDS 
	FROM (SELECT DISTINCT (CHANNEL_ID) NUM_IDS FROM CHANNELS);
INSERT INTO surr_test 
	SELECT 'CHANNELS','CHANNEL_CLASS_ID',NUM_IDS
	FROM (SELECT DISTINCT (CHANNEL_CLASS_ID) NUM_IDS FROM CHANNELS);
INSERT INTO surr_test 
	SELECT 'CHANNELS','CHANNEL_TOTAL_ID',NUM_IDS
	FROM (SELECT DISTINCT (CHANNEL_TOTAL_ID) NUM_IDS FROM CHANNELS);

COMMIT;

--
-- Populate the table with all distinct surrogate key values
--  from each dimension
--

INSERT INTO surr_test  
	SELECT 'COUNTRIES/CUSTOMERS','COUNTRY_SUBREGION_ID',NUM_IDS
	FROM (SELECT DISTINCT (COUNTRY_SUBREGION_ID) NUM_IDS FROM COUNTRIES);
INSERT INTO surr_test  
	SELECT 'COUNTRIES/CUSTOMERS','COUNTRY_REGION_ID',NUM_IDS
	FROM (SELECT DISTINCT (COUNTRY_REGION_ID) NUM_IDS FROM COUNTRIES);
INSERT INTO surr_test  
	SELECT 'COUNTRIES/CUSTOMERS','COUNTRY_TOTAL_ID',NUM_IDS
	FROM (SELECT DISTINCT (COUNTRY_TOTAL_ID) NUM_IDS FROM COUNTRIES);
INSERT INTO surr_test  
	SELECT 'COUNTRIES/CUSTOMERS','CUST_STATE_PROVINCE_ID',NUM_IDS
	FROM (SELECT DISTINCT (CUST_STATE_PROVINCE_ID) NUM_IDS FROM CUSTOMERS);
INSERT INTO surr_test
	SELECT 'COUNTRIES/CUSTOMERS','COUNTRY_ID',NUM_IDS
	FROM (SELECT DISTINCT (COUNTRY_ID) NUM_IDS FROM CUSTOMERS);
INSERT INTO surr_test
	SELECT 'COUNTRIES/CUSTOMERS','CUST_TOTAL_ID',NUM_IDS
	FROM (SELECT DISTINCT (CUST_TOTAL_ID) NUM_IDS FROM CUSTOMERS);
INSERT INTO surr_test
	SELECT 'COUNTRIES/CUSTOMERS','CUST_CITY_ID',NUM_IDS
	FROM (SELECT DISTINCT (CUST_CITY_ID) NUM_IDS FROM CUSTOMERS);
INSERT INTO surr_test
	SELECT 'COUNTRIES/CUSTOMERS','CUST_ID',NUM_IDS
	FROM (SELECT DISTINCT (CUST_ID) NUM_IDS FROM CUSTOMERS);

--
-- Only list COUNTRY_ID_ID once: Column appears twice in 
-- COUNTRIES/CUSTOMERS snowflake dimension. To test for uniqueness of 
-- surrogate key across dimension, the following INSERT is not needed.
-- 
-- INSERT INTO surr_test  
-- 	SELECT 'COUNTRIES/CUSTOMERS','COUNTRY_ID',NUM_IDS
--	FROM (SELECT DISTINCT (COUNTRY_ID) NUM_IDS FROM COUNTRIES);
--

COMMIT;

INSERT INTO surr_test
	SELECT 'PRODUCTS','PROD_TOTAL_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROD_TOTAL_ID) NUM_IDS FROM PRODUCTS);
INSERT INTO surr_test
	SELECT 'PRODUCTS','PROD_SUBCATEGORY_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROD_SUBCATEGORY_ID) NUM_IDS FROM PRODUCTS);
INSERT INTO surr_test
	SELECT 'PRODUCTS','PROD_CATEGORY_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROD_CATEGORY_ID) NUM_IDS FROM PRODUCTS);
INSERT INTO surr_test
	SELECT 'PRODUCTS','PROD_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROD_ID) NUM_IDS FROM PRODUCTS);

COMMIT;

INSERT INTO surr_test
	SELECT 'PROMOTIONS','PROMO_SUBCATEGORY_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROMO_SUBCATEGORY_ID) NUM_IDS FROM PROMOTIONS);
INSERT INTO surr_test
	SELECT 'PROMOTIONS','PROMO_CATEGORY_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROMO_CATEGORY_ID) NUM_IDS FROM PROMOTIONS);
INSERT INTO surr_test
	SELECT 'PROMOTIONS','PROMO_TOTAL_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROMO_TOTAL_ID) NUM_IDS FROM PROMOTIONS);
INSERT INTO surr_test
	SELECT 'PROMOTIONS','PROMO_ID',NUM_IDS
	FROM (SELECT DISTINCT (PROMO_ID) NUM_IDS FROM PROMOTIONS);

COMMIT;

INSERT INTO surr_test
	SELECT 'TIMES','FISCAL_QUARTER_ID',NUM_IDS
	FROM (SELECT DISTINCT (FISCAL_QUARTER_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','CALENDAR_YEAR_ID',NUM_IDS
	FROM (SELECT DISTINCT (CALENDAR_YEAR_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','FISCAL_YEAR_ID',NUM_IDS
	FROM (SELECT DISTINCT (FISCAL_YEAR_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','WEEK_ENDING_DAY_ID',NUM_IDS
	FROM (SELECT DISTINCT (WEEK_ENDING_DAY_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','CALENDAR_MONTH_ID',NUM_IDS
	FROM (SELECT DISTINCT (CALENDAR_MONTH_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','FISCAL_MONTH_ID',NUM_IDS
	FROM (SELECT DISTINCT (FISCAL_MONTH_ID) NUM_IDS FROM TIMES);
INSERT INTO surr_test
	SELECT 'TIMES','CALENDAR_QUARTER_ID',NUM_IDS
	FROM (SELECT DISTINCT (CALENDAR_QUARTER_ID) NUM_IDS FROM TIMES);

COMMIT;

CREATE INDEX surr_test_ix 
 ON surr_test (dimension, key_level, key_value);

--
-- Create table EXCEPTIONS
--

@?/rdbms/admin/utlexcpt

--
-- Find non-unique surrogate key values by trying to enable a unique constraint
--

ALTER TABLE surr_test
 ADD CONSTRAINT surr_test_uk
 UNIQUE (dimension, key_level, key_value)
 EXCEPTIONS INTO exceptions;

SELECT * 
 FROM surr_test
 WHERE rowid IN (SELECT row_id FROM exceptions);

DROP TABLE surr_test;
DROP TABLE exceptions;
