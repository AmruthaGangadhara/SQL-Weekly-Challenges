CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
SELECT * FROM members;
SELECT * from sales;
SELECT * FROM menu;




Each of the following case study questions can be answered using a single SQL statement:

--What is the total amount each customer spent at the restaurant?

-- SELECT m.customer_id,sum(me.price) Total_amount_spent
-- FROM sales s INNER JOIN members m
-- on m.customer_id=s.customer_id
-- INNER JOIN menu me on s.product_id=me.product_id
-- GROUP BY 1
-- ORDER BY 2 DESC 
--The above solution is correct, but I did not realise that there was another member 'C' who's details were not added in members table but were order entries in sales table.
--I had to include the customer'C'. Hence the correction

SELECT s.customer_id,SUM(me.price) total_amt_spent
FROM sales s INNER JOIN menu me on
s.product_id=me.product_id
GROUP BY 1
ORDER BY 2 DESC

--How many days has each customer visited the restaurant?

WITH temp as(SELECT DISTINCT customer_id,order_date
FROM sales)
SELECT temp.customer_id,count(temp.order_date) num_days_visited
FROM temp
GROUP BY 1
ORDER by 2 DESC

--ALTERNATE SOLN FOR THIS
SELECT customer_id,COUNT(DISTINCT(order_date))
FROM sales
group by 1


--What was the first item from the menu purchased by each customer?

with T1 as(SELECT s.customer_id cust_id,min(s.order_date) order_date
FROM sales s INNER JOIN menu m on
s.product_id=m.product_id
group by 1)  --QUERY TO GET THE FIRST DAY THE CUSTOMERS PLACED ORDER
SELECT s.customer_id,s.order_date,me.product_name
FROM sales s INNER JOIN 
menu me on me.product_id=s.product_id
INNER JOIN T1 on
s.customer_id=T1.cust_id AND T1.order_date=s.order_date
ORDER BY 1

--ALTERNATE SOLN WITH WINDOW FUNCTION
with TEMP AS (SELECT *,DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date ) rank
FROM sales s INNER JOIN menu me on
s.product_id=me.product_id)
select DISTINCT temp.customer_id,temp.order_date,temp.product_name
FROM temp
where temp.rank=1


--What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT me.product_id,me.product_name,count(*)
FROM sales s INNER JOIN menu me on
s.product_id=me.product_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

--Which item was the most popular for each customer?


with most_liked as(SELECT s.customer_id customer_id,me.product_name prod_name,count(*) num_times_ordered,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY count(*) DESC) rank
FROM sales s INNER JOIN menu me on
s.product_id=me.product_id
GROUP BY 1 ,2)    --ranked the count of orders first and then using CTE solved for the rest of the prob
SELECT customer_id,prod_name,num_times_ordered
FROM most_liked
WHERE rank=1


--Which item was purchased first by the customer after they became a member?

WITH mem_tab AS (SELECT customer_id,join_date
		   FROM members), 
	sales_tab as(SELECT s.customer_id customer_id,s.order_date order_date,me.product_name prod_name
				FROM sales s INNER JOIN mem_tab on
				 s.customer_id=mem_tab.customer_id AND s.order_date>=mem_tab.join_date
				INNER JOIN menu me on me.product_id=s.product_id),
rank_tab as(SELECT sales_tab.customer_id cust_id,sales_tab.prod_name prod_name,(sales_tab.order_date) order_date,
dense_rank() over(partition by sales_tab.customer_id ORDER BY sales_tab.order_date) rank
FROM sales_tab)
SELECT rank_tab.cust_id,rank_tab.prod_name,rank_tab.order_date
FROM rank_tab
where rank=1
--This was a lengthy soln
--below is the alternate soln

with first_order as(SELECT s.customer_id,s.order_date,s.product_id,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) RANK
FROM sales s INNER JOIN members m on
s.customer_id=m.customer_id and s.order_date>=m.join_date)
SELECT fo.customer_id,fo.order_date,me.product_name
FROM first_order fo INNER JOIN menu me on
fo.product_id=me.product_id
WHERE rank=1





--Which item was purchased just before the customer became a member?

with first_order as(SELECT s.customer_id,s.order_date,s.product_id,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) RANK --created a cate to rank the data with partitioning by cust id and ordering by date(DESC date in this case) as we want to know the order placed just before joining date
FROM sales s INNER JOIN members m on
s.customer_id=m.customer_id and s.order_date<m.join_date)
SELECT fo.customer_id,fo.order_date,me.product_name --Joining menu tables to get prod name
FROM first_order fo INNER JOIN menu me on
fo.product_id=me.product_id
WHERE rank=1

--What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id,count(s.product_id) num_items_ordered,sum(me.price) money_spent
FROM sales s INNER JOIN members m on
s.customer_id=m.customer_id AND s.order_date<m.join_date
INNER JOIN menu me on me.product_id=s.product_id
GROUP BY 1
ORDER BY 1,2,3

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH points as(SELECT s.customer_id,
CASE WHEN me.product_name LIKE '%sushi%' THEN (me.price*10)*2    --using case when, calculate points for all the items based on what the item is
ELSE me.price*10 END member_points
FROM sales s INNER JOIN menu me on
s.product_id=me.product_id 
			  INNER JOIN members m on m.customer_id=s.customer_id)
SELECT p.customer_id,SUM(p.member_points)
FROM points p
GROUP BY 1
ORDER BY 2 DESC



--In the first week after a customer joins the program (including their join date) they earn 2x points on all items
--, not just sushi - how many points do customer A and B have at the end of January?

