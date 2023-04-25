/* Question :
This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

transactions Table:
Column Name	Type
user_id	integer
spend	decimal
transaction_date	timestamp

user_id	spend	transaction_date
111	100.50	01/08/2022 12:00:00
111	55.00	01/10/2022 12:00:00
121	36.00	01/18/2022 12:00:00
145	24.99	01/26/2022 12:00:00
111	89.60	02/05/2022 12:00:00

Solution: */

WITH CTE AS (SELECT *,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) trans_num
FROM transactions)
SELECT user_id,spend,transaction_date
FROM CTE
WHERE trans_num=3
--The approach was to use window functions and to partition the data by user id and rank it by date.
--once this was done used this as cte to select the data where the rank was 3(3rd transaction of each user)
