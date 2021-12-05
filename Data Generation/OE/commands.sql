select order_id, order_date, customer_id from oe.orders ORDER BY 1 DESC FETCH FIRST 10 ROWS ONLY;
select customer_id, cust_first_name, cust_last_name, gender from oe.customers ORDER BY 1 DESC FETCH FIRST 10 ROWS ONLY;

select count(*) from oe.orders;
select count(*) from oe.customers;
