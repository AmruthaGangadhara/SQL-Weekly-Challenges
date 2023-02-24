/*Question 1
You'd like to get the first and last name of the last member(s) who signed up - not just the date.
 How can you do that?*/

Solution:
SELECT firstname,surname,joindate                  --selected the required fields based on the filter
FROM cd.members 
WHERE joindate=(SELECT MAX(joindate) from cd.members)   --used a subquery to fetch the latest date 

/*Question 2

How can you output a list of all members,
including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).*/
 
Solution: used CTEs

WITH t1 as(
  SELECT firstname fn,surname sr,recommendedby r  --selected the firstname,surname and recommendedby from the tables at first
  FROM cd.members),
  t2 as (SELECT memid id,firstname fn ,surname sr   --selected the memid,firstyname and surname 
		 FROM cd.members)
SELECT t1.fn memfname,t1.sr recsname,t2.fn recfname,t2.sr recsname FROM --joined the tables using left join since I wanted to retain all the records from the first table and show the recommenders only if any were present
t1 LEFT JOIN t2 on t1.r=t2.id
ORDER BY 2,1                                          --ordered by surname and firstname