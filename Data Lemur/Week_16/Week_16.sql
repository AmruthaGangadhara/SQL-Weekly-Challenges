/* QUESTION 1-- amazon
Given the reviews table, write a query to get the average stars for each product every month.

The output should include the month in numerical value, product id, and average star rating rounded to two decimal places. Sort the output based on month followed by the product id.

P.S. If you've read the Ace the Data Science Interview, and liked it, consider writing us a review?

reviews Table:
Column Name	Type
review_id	integer
user_id	integer
submit_date	datetime
product_id	integer
stars	integer (1-5) */

Solution:

SELECT date_part('month',submit_date) mth ,product_id,ROUND(AVG(stars),2) avg_stars
FROM reviews
GROUP BY 1,2
ORDER BY 1,2


/* Question 2--google

This is the same question as problem #28 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table containing measurement values obtained from a Google sensor over several days. Measurements are taken several times within a given day.

Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns. Refer to the Example Output below for the output format.

Definition:

1st, 3rd, and 5th measurements taken within a day are considered odd-numbered measurements and the 2nd, 4th, and 6th measurements are even-numbered measurements.
measurements Table:
Column Name	Type
measurement_id	integer
measurement_value	decimal
measurement_time	datetime
measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	1109.51	07/10/2022 09:00:00
135211	1662.74	07/10/2022 11:00:00
523542	1246.24	07/10/2022 13:15:00
143562	1124.50	07/11/2022 15:00:00
346462	1234.14	07/11/2022 16:45:00 */
Solution:


WITH row_num as (SELECT *, ROW_NUMBER() OVER(ORDER BY  measurement_time )  --included row number by ordering the daat wrt time.
FROM measurements)
SELECT date_trunc('day',row_num.measurement_time) measurement_day,         --using cte, selected the required data using case when and group by
SUM(CASE WHEN row_number%2!=0 THEN measurement_value END) odd_sum,
SUM(CASE WHEN row_number%2=0 THEN measurement_value END) even_sum
FROM row_num
GROUP BY 1
