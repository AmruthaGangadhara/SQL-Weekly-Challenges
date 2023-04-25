/* Question:

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

tweets Table:
Column Name	Type
tweet_id	integer
user_id	integer
msg	string
tweet_date	timestamp


Solution:*/

WITH CTE AS (SELECT user_id,count(*) num_tweets
FROM tweets
WHERE DATE_PART('year',tweet_date)=2022
GROUP BY 1)
SELECT num_tweets tweet_bucket,count(user_id) users_num  
FROM CTE 
GROUP BY 1
--The approach was to filter the data where the year is 2022.
--Once the data was filtered, grouping by the user_id num of tweets was calculated.
--Finally using this as cte, grouped by the count as tweet buckets to check howmany users fall into that particular bucket
