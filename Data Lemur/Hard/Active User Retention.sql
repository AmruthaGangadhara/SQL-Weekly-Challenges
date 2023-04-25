/* Question:

Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
user_actions Table:
Column Name	Type
user_id	integer
event_id	integer
event_type	string ("sign-in, "like", "comment")
event_date	datetime
user_actionsExample Input:
user_id	event_id	event_type	event_date
445	7765	sign-in	05/31/2022 12:00:00
742	6458	sign-in	06/03/2022 12:00:00
445	3634	like	06/05/2022 12:00:00
742	1374	comment	06/05/2022 12:00:00
648	3124	like	06/18/2022 12:00:00
 Solution:*/

with june as (select * from user_actions
where date_part('month',event_date)=6),
july as ( select * from user_actions
where date_part('month',event_date)=7)
SELECT date_part('month',july.event_date),count(distinct july.user_id)
from june inner join july ON june.user_id=july.user_id
where date_part('month',july.event_date)=7
group by 1  

