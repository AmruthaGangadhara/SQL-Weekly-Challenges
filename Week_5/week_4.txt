/*Question 1
How can you produce a list of the start times for bookings by members named 'David Farrell'?*/

Solution:
SELECT b.starttime
FROM cd.bookings b INNER JOIN cd.members m --Joined the two tables
on b.memid=m.memid
where (m.firstname like '%David%' and m.surname like '%Farrell%') -useed wild cards to match the names . Used WHERE because I wanted to filter out on the name

SELECT b.starttime
FROM cd.bookings b INNER JOIN cd.members m --Joined the two tables
on b.memid=m.memid
where concat(m.firstname,' ',m.surname)='David Farrell' --we could use concat instead of wild cards as well

/*Question 2

Produce a list of the total number of slots booked per facility per month in the year of 2012.
 In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. 
The output table should consist of facility id, month and slots, sorted by the id and month. 
When calculating the aggregated values for all months and all facids, return null values in the month and facid columns..*/
 
Solution: 
WITH T1 AS (SELECT f.facid facid,date_part('month',b.starttime) as month,sum(b.slots) as slots --created a query to select total num of slots by facid and month where year equals 2012
FROM cd.facilities f INNER JOIN cd.bookings b
on f.facid=b.facid
WHERE date_part('year',b.starttime)='2012'
GROUP BY 1,2
ORDER BY 1,2)
SELECT facid,month,slots                                       --since i had to join the tables, i used union all because it had unequal number of columns                     
FROM T1                                                        --selected facid and sum (slots) by grouping just the facid
UNION ALL
SELECT facid,NULL,sum(slots) slots                              --merged this with the final table. using null beacsue i want only the facid and sum(slots)
FROM T1
GROUP BY 1
UNION ALL
SELECT null,null,sum(slots) slots                                --using nulls because i need only the overall total slots for all the facilities
FROM T1
ORDER BY facid,month