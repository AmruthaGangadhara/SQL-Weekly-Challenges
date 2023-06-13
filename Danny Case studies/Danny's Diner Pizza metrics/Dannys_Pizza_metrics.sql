CREATE SCHEMA pizza_runner;


DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
select * from customer_orders;

--Lets replace nulls

UPDATE customer_orders
SET extras='N/A'
WHERE (extras in ('','null')) OR (extras ISNULL);

UPDATE customer_orders
SET exclusions='N/A'
WHERE (exclusions in ('','null')) OR (exclusions ISNULL);

select * from runner_orders;

UPDATE runner_orders
SET pickup_time='N/A'
WHERE (pickup_time in ('','null')) OR (pickup_time ISNULL);

UPDATE runner_orders
SET distance='N/A'
WHERE (distance in ('','null')) OR (distance ISNULL);

UPDATE runner_orders
SET duration='N/A'
WHERE (duration in ('','null')) OR (duration ISNULL);

UPDATE runner_orders
SET cancellation='N/A'
WHERE (cancellation in ('','null')) OR (cancellation ISNULL);

select * from runner_orders
--distance,duration has some extra data like km/mins/minutes. lets clean it up

UPDATE runner_orders
SET distance=regexp_replace(distance,'[^0-9\.]+','','g')WHERE distance ~'km';

UPDATE runner_orders
SET duration=regexp_replace(duration,'[^0-9\.]+','','g')WHERE duration ~'minutes'
or duration~'mins' or duration~'minute' or duration ~'min';


--A. Pizza Metrics
--How many pizzas were ordered? --14 pizzas were ordered

SELECT count(*) FROM customer_orders;

--How many unique customer orders were made?--10
select count( DISTINCT order_id) from customer_orders


--How many successful orders were delivered by each runner? --8 successful orders
SELECT runner_id,COUNT(*)
FROM runner_orders
WHERE cancellation LIKE '%N/A%'
GROUP BY 1
 

--How many of each type of pizza was delivered?

SELECT p.pizza_id,p.pizza_name,count(*)
FROM runner_orders ro INNER JOIN customer_orders co ON
ro.order_id=co.order_id 
INNER JOIN pizza_names p on p.pizza_id=co.pizza_id
WHERE ro.cancellation like '%N/A%'
GROUP BY 1,2



--How many Vegetarian and Meatlovers were ordered by each customer?

SELECT co.customer_id,p.pizza_name,count(*) num_pizzas_ordered
FROM customer_orders co INNER JOIN pizza_names p on
co.pizza_id=p.pizza_id
GROUP BY 1,2
ORDER BY 1

--howmany pizzas were ordered per each category
SELECT p.pizza_name,count(*) num_pizzas_ordered
FROM customer_orders co INNER JOIN pizza_names p on
co.pizza_id=p.pizza_id
GROUP BY 1
ORDER BY 1

select * from runner_orders

--What was the maximum number of pizzas delivered in a single order?
SELECT MAX(num_pizzas_ordered)FROM 
(SELECT RO.ORDER_ID,count(co.pizza_id) num_pizzas_ordered
FROM customer_orders co INNER JOIN runner_orders ro ON
co.order_id=ro.order_id
WHERE ro.cancellation LIKE '%N/A%'
GROUP BY 1
ORDER BY 1 ) temp;

--For each customer, how many delivered pizzas had at least 1 
--change and how many had no changes?


SELECT co.customer_id,
SUM(CASE WHEN co.exclusions!='N/A' OR co.extras!='N/A'  THEN 1 ELSE 0 END) atleast_1_change,
SUM(CASE WHEN co.exclusions='N/A' AND co.extras='N/A' THEN 1 ELSE 0 END) no_change
FROM customer_orders co INNER JOIN runner_orders ro ON
co.order_id=ro.order_id
WHERE ro.cancellation LIKE '%N/A%'
GROUP BY 1
ORDER BY 1

--what it is doing is it is going to each record and first checks
--whether it is not equal to n/a. if it is not, then it will recotd 1  else 0
--then it will check if it is equal to n/a. kif it is, it will rec 1 else 0




--How many pizzas were delivered that had both exclusions and extras?
SELECT count(*)
FROM customer_orders co INNER JOIN runner_orders ro on
co.order_id=ro.order_id
WHERE ro.cancellation='N/A'
AND (co.exclusions!='N/A' AND co.extras!='N/A')

--What was the total volume of pizzas ordered for each hour of the day?

SELECT date_trunc('day',order_time) date,date_part('hour',order_time) hr ,count(*)
FROM customer_orders co
GROUP BY 1,2
ORDER BY 1,2

--What was the volume of orders for each day of the week?
 -- sets Monday as the first day of the week
SELECT to_char(EXTRACT(DOW FROM order_time::timestamp),'Day')
FROM customer_orders; -- returns 6 (Saturday)

SET datestyle = 'ISO, DMY';
SELECT to_char(order_time,'Day'),count(*)
from customer_orders
GROUP BY 1
ORDER BY 1


--B. Runner and Customer Experience

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT DATE_part('week',registration_date) WEEK,count(*)
FROM runners
GROUP BY 1
ORDER BY 1 DESC;

--check the week format


--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select * from runner_orders

--realised that pickuptime was of different daatrtype. let me dix it
UPDATE runner_orders
SET pickup_time = pickup_time::TIMESTAMP WITHOUT TIME ZONE
WHERE pickup_time <> 'N/A';

ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP WITHOUT TIME ZONE
USING (
  SELECT 
    CASE 
      WHEN pickup_time = 'N/A' THEN NULL 
      ELSE pickup_time::TIMESTAMP WITHOUT TIME ZONE 
    END
  FROM your_table 
  WHERE pickup_time <> 'N/A'
);

SELECT DATE_PART('year',ro.pickup_time)
FROM customer_orders co INNER JOIN runner_orders ro ON
co.order_id=ro.order_id
where ro.cancellation='N/A'
