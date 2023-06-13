/*Question 1
The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.*/


Solution 1:

select memid,regexp_replace(telephone,'\D','','g') from cd.members --replaced any non numeric character with space

Solution 2: 
with t1 as (select memid, 
regexp_match(telephone, '[\(|\)|\-|\s]([0-9]{3})[\(|\)|\-|\s][\(|\)|\-|\s]([0-9]{3})[\(|\)|\-|\s]([0-9]{4})') regex     --used regex to match the digits which will result in a 
from cd.members)                                                                                                        --set of 3 matches. 
select t1.memid,concat(t1.regex[1],t1.regex[2],t1.regex[3]) telephone                                                    --concatenetaed the 3 matches of sets as telephone
from t1

/*Question 2

Produce a list of the total number of slots booked per facility per month in the year of 2012.
 In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. 
The output table should consist of facility id, month and slots, sorted by the id and month. 
When calculating the aggregated values for all months and all facids, return null values in the month and facid columns..*/
 
Solution: 

WITH T1 AS (SELECT f.facid facid,date_part('month',b.starttime) as month,sum(b.slots) as slots
FROM cd.facilities f INNER JOIN cd.bookings b
on f.facid=b.facid
WHERE date_part('year',b.starttime)='2012'
GROUP BY 1,2
ORDER BY 1,2)
SELECT facid,month,slots
FROM T1
UNION ALL
SELECT facid,NULL,sum(slots) slots
FROM T1
GROUP BY 1
UNION ALL
SELECT null,null,sum(slots) slots
FROM T1
ORDER BY facid,month
