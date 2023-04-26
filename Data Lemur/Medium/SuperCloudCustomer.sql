/* Question:

Write a query to report the company ID which is a Supercloud customer.

As of 5 Dec 2022, data in the customer_contracts and products tables were updated.

customer_contracts Table:
Column Name	Type
customer_id	integer
product_id	integer
amount	integer
customer_contracts Example Input:
customer_id	product_id	amount
1	1	1000
1	3	2000
1	5	1500
2	2	3000
2	6	2000

Solution:*/

SELECT c.customer_id
FROM customer_contracts c INNER JOIN products p on c.product_id=p.product_id
GROUP BY 1
HAVING count(distinct p.product_category)>2