--Data Lemur :
/* Question 1

Assume you are given the tables below containing information on Snapchat users, their ages, and their time spent sending and opening snaps. Write a query to obtain a breakdown of the time spent sending vs. opening snaps (as a percentage of total time spent on these activities) for each age group.

Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2 decimal places.

Notes:

You should calculate these percentages:
time sending / (time sending + time opening)
time opening / (time sending + time opening)
To avoid integer division in percentages, multiply by 100.0 and not 100.
activities Table:
Column Name	Type
activity_id	integer
user_id	integer
activity_type	string ('send', 'open', 'chat')
time_spent	float
activity_date	datetime
activities Example Input:
activity_id	user_id	activity_type	time_spent	activity_date
7274	123	open	4.50	06/22/2022 12:00:00
2425	123	send	3.50	06/22/2022 12:00:00
1413	456	send	5.67	06/23/2022 12:00:00
1414	789	chat	11.00	06/25/2022 12:00:00
2536	456	open	3.00	06/25/2022 12:00:00
age_breakdown Table:
Column Name	Type
user_id	integer
age_bucket	string ('21-25', '26-30', '31-25')
*/


WITH users AS (SELECT age.age_bucket age_bucket,
sum(CASE WHEN act.activity_type='open' THEN time_spent END) time_opening,  
sum(CASE WHEN act.activity_type='send' THEN time_spent END) time_sending
FROM activities act INNER JOIN age_breakdown age
ON act.user_id=age.user_id
WHERE act.activity_type in ('send','open')
GROUP BY 1)
SELECT age_bucket,
ROUND(((time_sending/(time_opening+time_sending))*100.0),2) send_perc,
ROUND(((time_opening/(time_opening+time_sending))*100.0),2) open_perc
FROM users  




/* Question 2 */

Assume you are given the tables below about Facebook pages and page likes. Write a query to return the page IDs of all the Facebook pages that don't have any likes. The output should be in ascending order.

pages Table:
Column Name	Type
page_id	integer
page_name	varchar
pages Example Input:
page_id	page_name
20001	SQL Solutions
20045	Brain Exercises
20701	Tips for Data Analysts
page_likes Table:
Column Name	Type
user_id	integer
page_id	integer
liked_date	datetime


SELECT p.page_id
FROM pages P LEFT JOIN page_likes pl ON p.page_id=pl.page_id
WHERE pl.liked_date IS NULL
ORDER BY 1