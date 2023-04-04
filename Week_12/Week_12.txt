/* question 1
Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store1      | int     |
| store2      | int     |
| store3      | int     |
+-------------+---------+
product_id is the primary key for this table.
Each row in this table indicates the product's price in 3 different stores: store1, store2, and store3.
If the product is not available in a store, the price will be null in that store's column.
 

Write an SQL query to rearrange the Products table so that each row has (product_id, store, price). If a product is not available in a store, do not include a row with that product_id and store combination in the result table.

Return the result table in any order.

solution:*/

SELECT product_id,
CASE WHEN store1 !='null' THEN 'store1' END store,
CASE WHEN store1 !='null' THEN store1 END price
FROM products
where store1 is not null

UNION ALL
SELECT product_id,
CASE WHEN store2 !='null' THEN 'store2' END store,
CASE WHEN store2 !='null' THEN store2 END price
FROM products
where store2 is not null

UNION ALL
SELECT product_id,
CASE WHEN store3 !='null' THEN 'store3' END store,
CASE WHEN store3 !='null' THEN store3 END price
from products
where store3 is not null



/* question 2 


Table: Logins

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
(user_id, time_stamp) is the primary key for this table.
Each row contains information about the login time for the user with ID user_id.
 

Write an SQL query to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.

Return the result table in any order.

The query result format is in the following example.*/

solution:

SELECT user_id,max(time_stamp) last_stamp
FROM logins
WHERE year(time_stamp)='2020'
GROUP BY user_id
