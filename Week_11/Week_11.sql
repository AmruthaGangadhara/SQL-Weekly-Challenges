/*question 1 
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write an SQL query to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.*/

Solution:
with t1 as (SELECT article_id,author_id,viewer_id
FROM views),
t2 as ( SELECT author_id
from views)
SELECT DISTINCT t2.author_id id  --using CTEs and selecting the data by using self join
FROM t1 INNER JOIN  t2 on 
t1.viewer_id=t2.author_id
ORDER BY 1 


/* question 2

Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
Each row of this table indicates the name and the price of each product.
Table: Sales

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+-------------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to the Product table.
Each row of this table contains some information about one sale.
 

Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.

Return the result table in any order.*/

SELECT s.product_id,p.product_name
FROM sales s INNER JOIN product p ON
s.product_id=p.product_id
GROUP BY 1,2
having  min(s.sale_date)>= '2019-01-01' AND max(s.sale_date) <='2019-03-31' 

--I had first written a where condition which was fetching wrong results. looks like I had misunderstood the quest. the quest is to look for prod which were only sold in q1 and not in any other quarters. So grouped by productid,name and put a condition such that the min date was the beginning of Q1 and the max date was the end of q1.