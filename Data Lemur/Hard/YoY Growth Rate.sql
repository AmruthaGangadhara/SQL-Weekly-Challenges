/* Question:

Assume you are given the table below containing information on user transactions for particular products. Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.

Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

user_transactions Table:
Column Name	Type
transaction_id	integer
product_id	integer
spend	decimal
transaction_date	datetime
user_transactions Example Input:
transaction_id	product_id	spend	transaction_date
1341	123424	1500.60	12/31/2019 12:00:00
1423	123424	1000.20	12/31/2020 12:00:00
1623	123424	1246.44	12/31/2021 12:00:00
1322	123424	2145.32	12/31/2022 12:00:00

Solution:*/

with cte as (SELECT DATE_PART('year',transaction_date) as year,product_id,spend curr_year_spend,
lag(spend,1) OVER(PARTITION BY PRODUCT_ID ORDER BY DATE_PART('year',transaction_date)) prev_year_spend
FROM user_transactions)
SELECT year,product_id,curr_year_spend,prev_year_spend,
round(((curr_year_spend - prev_year_spend) / prev_year_spend)*100,2) yoy_rate
FROM cte
