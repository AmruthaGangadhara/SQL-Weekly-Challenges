/* 1.Spotify SQL Interview Question:

Assume there are three Spotify tables containing information about the artists, songs, and music charts. Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. From now on, we'll refer to this ranking number as "song appearances".

Output the top 5 artist names in ascending order along with their song appearances ranking (not the number of song appearances, but the rank of who has the most appearances). The order of the rank should take precedence.

For example, Ed Sheeran's songs appeared 5 times in Top 10 list of the global song rank table; this is the highest number of appearances, so he is ranked 1st. Bad Bunny's songs appeared in the list 4, so he comes in at a close 2nd.

Assumptions:

If two artists' songs have the same number of appearances, the artists should have the same rank.
The rank number should be continuous (1, 2, 2, 3, 4, 5) and not skipped (1, 2, 2, 4, 5).

artists Table:
Column Name	Type
artist_id	integer
artist_name	varchar
artists Example Input:
artist_id	artist_name
101	Ed Sheeran
120	Drake

songs Table:
Column Name	Type
song_id	integer
artist_id	integer
songs Example Input:
song_id	artist_id
45202	101
19960	120

global_song_rank Table:
Column Name	Type
day	integer (1-52)
song_id	integer
rank	integer (1-1,000,000)
global_song_rank Example Input:
day	song_id	rank
1	45202	5
3	45202	2
1	19960	3
9	19960	15

Example Output:
artist_name	artist_rank
Ed Sheeran	1
Drake	2

Solution :*/

WITH top_10 as(SELECT artist_name,DENSE_RANK() OVER(ORDER BY count(rank) DESC) ARTIST_RANK
FROM artists a INNER JOIN songs s ON
a.artist_id=s.artist_id
INNER JOIN global_song_rank g ON g.song_id=s.song_id
where rank<=10
GROUP BY 1
ORDER BY 2 )
SELECT artist_name,artist_rank
FROM top_10
where artist_rank<=5

--the approach used for this was once joining the necessary tables, I filteered the data where  the rank was below/= to 10 ( as I wanted top 10 artists)
--Once this was done,I grouped by the artist, and calculated the count of ranks in order to find who has the most number of song appearances.
--Later, I used dense_rank to rank the artists by their count(rank) in the desc order.
--using this as a CTE, i selected the artist name and rank which was below/= to 5



/* 2.Signup Activation Rate [TikTok SQL Interview Question]

New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

emails table contain the information of user signup details.
texts table contains the users' activation information.
Assumptions:

The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
For example, user 123 in the emails table may not be in the texts table and vice versa.
Effective April 4th 2023, we added an assumption to the question to provide additional clarity.

emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
236	6950	07/01/2022 00:00:00
433	1052	07/09/2022 00:00:00

texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	varchar
texts Example Input:
text_id	email_id	signup_action
6878	125	Confirmed
6920	236	Not Confirmed
6994	236	Confirmed
'Confirmed' in signup_action means the user has activated their account and successfully completed the signup process.

Example Output:
confirm_rate
0.67

Solution */:

with cte as (SELECT cast(SUM(CASE WHEN signup_action='Confirmed' THEN 1 END) as DECIMAL) confirmed,
                    cast(SUM(CASE WHEN signup_action='Not Confirmed' THEN 1 END) as DECIMAL) not_confirmed
                    FROM emails e INNER JOIN texts t ON 
                    e.email_id=t.email_id)
select ROUND((cte.confirmed/(cte.confirmed+cte.not_confirmed)),2) confirm_rate
from cte

--I was getting zero as the output becasue I had cast both conf and not conf as integeres! learnt about casting!



