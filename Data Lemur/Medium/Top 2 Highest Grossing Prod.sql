/* Question:

Assume you're given a table with information on Amazon customers and their spending on products in different categories, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

product_spend Table:
Column Name	Type
category	string
product	string
user_id	integer
spend	decimal
transaction_date	timestamp
product_spend Example Input:
category	product	user_id	spend	transaction_date
appliance	refrigerator	165	246.00	12/26/2021 12:00:00
appliance	refrigerator	123	299.99	03/02/2022 12:00:00
appliance	washing machine	123	219.80	03/02/2022 12:00:00
electronics	vacuum	178	152.00	04/05/2022 12:00:00
electronics	wireless headset	156	249.90	07/08/2022 12:00:00
electronics	vacuum	145	189.00	07/15/2022 12:00:00

Solution:

with cte as (SELECT DISTINCT category,product,
sum(spend) OVER(PARTITION BY category,product)  total_spend
FROM product_spend
WHERE date_part('year',transaction_date)=2022
order by 1,3 DESC),

cte2 as (SELECT category,product,total_spend,
DENSE_RANK() OVER(partition by category ORDER BY total_spend DESC) as dr
from cte)

SELECT category,product,total_spend
FROM cte2 WHERE dr in (1,2)
