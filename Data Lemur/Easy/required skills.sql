/* Question
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Assumption:

There are no duplicates in the candidates table.
candidates Table:
Column Name	Type
candidate_id	integer
skill	varchar
candidates Example Input:
candidate_id	skill
123	Python
123	Tableau
123	PostgreSQL
234	R
234	PowerBI
234	SQL Server
345	Python
345	Tableau
Solution:*/


WITH CTE AS (SELECT candidate_id,
CASE WHEN skill IN ('Python','Tableau','PostgreSQL') THEN 1 else 0 END skill_count  --added a case when to check if the skills in the list
FROM candidates)
SELECT candidate_id
FROM CTE 
GROUP BY candidate_id
HAVING  SUM(skill_count)=3  --using this as cte, selected the ids which had sum=3 which means they have all the required ctes
ORDER BY 1
