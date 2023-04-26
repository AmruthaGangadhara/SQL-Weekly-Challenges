/* Question:

Assume you are given the table on Walmart user transactions. Based on a user's most recent transaction date, write a query to obtain the users and the number of products bought.

Output the user's most recent transaction date, user ID and the number of products sorted by the transaction date in chronological order.

P.S. As of 10 Nov 2022, the official solution was changed from output of the transaction date, number of users and number of products to the current output.

user_transactions Table:
Column Name	Type
product_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	123	68.90	07/08/2022 12:00:00
9623	123	274.10	07/08/2022 12:00:00
1467	115	19.90	07/08/2022 12:00:00
2513	159	25.00	07/08/2022 12:00:00
1452	159	74.50	07/10/2022 12:00:00

Solution:*/


WITH latest_date  AS (SELECT user_id,max(transaction_date) transaction_date
FROM user_transactions
GROUP BY 1)
SELECT u.transaction_date,u.user_id,count(*) purchase_count
FROM user_transactions u INNER JOIN latest_date l ON u.user_id=l.user_id AND
u.transaction_date=l.transaction_date
GROUP BY 1,2
ORDER BY 1