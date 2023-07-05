Question:

For our first foray into aggregates, we're going to stick to something simple. We want to know how many facilities exist - simply produce a total count.

SELECT COUNT(DISTINCT facid) FROM cd.facilities

Question
Produce a count of the number of facilities that have a cost to guests of 10 or more.

SELECT COUNT(DISTINCT facid)
FROM cd.facilities
WHERE guestcost>=10


Question
Produce a count of the number of recommendations each member has made. Order by member ID.

SELECT m2.recommendedby,count(m1.memid)
FROM cd.members m1
INNER JOIN cd.members m2 ON
m2.recommendedby=m1.memid
GROUP BY 1
ORDER BY 1
#Used a self join

Question
Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.

SELECT facid,sum(slots)
FROM cd.bookings b
GROUP BY 1
ORDER BY 1


Question
Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.


SELECT f.facid,DATE_PART('month',b.starttime),sum(b.slots)
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
WHERE DATE_PART('year',b.starttime)=2012
GROUP BY 1,2

Question

Find the total number of members (including guests) who have made at least one booking.

SELECT COUNT(DISTINCT memid)
FROM cd.bookings

Question
Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!


SELECT f.name,
SUM(CASE WHEN memid=0 THEN (b.slots*f.guestcost) ELSE (b.slots*f.membercost) END ) Revenue
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
GROUP BY 1
HAVING 
SUM(CASE WHEN memid=0 THEN (b.slots*f.guestcost) ELSE (b.slots*f.membercost) END )<1000
ORDER BY 2

Question
Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause. This version will probably look messy!
SOLN 1:
WITH CTE AS (SELECT f.facid facid,
sum(b.slots) Total_Slots, 
DENSE_RANK() OVER(ORDER BY sum(b.slots) DESC) rn
FROM cd.facilities f INNER 

SOLN 2:
SELECT f.facid facid,
sum(b.slots) Total_Slots
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1JOIN cd.bookings b ON
f.facid=b.facid
GROUP BY 1
ORDER BY 2 DESC)
SELECT CTE.facid, CTE.Total_Slots
FROM CTE WHERE rn=1



Question
Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.

SELECT (SELECT COUNT(*) FROM cd.members),firstname,surname
FROM cd.members
ORDER BY joindate


SELECT count(*) OVER(),firstname,surname
FROM cd.members
ORDER BY joindate
		 
Question
Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.


SELECT row_number() over(order by memid),
firstname,
surname
FROM cd.members


Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

WITH CTE AS(SELECT f.facid facid,SUM(b.slots) total,
DENSE_RANK() OVER(ORDER BY sum(b.slots) DESC) dr
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
		   GROUP BY 1)

SELECT facid,total
FROM CTE
WHERE dr=1

Question
Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank, sorted by rank and facility name.


WITH CTE AS (SELECT f.name as name,
DENSE_RANK() OVER(ORDER BY SUM(CASE WHEN b.memid=0 THEN (b.slots*f.guestcost) ELSE (b.slots*f.membercost) END)DESC )dr 
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
GROUP BY 1)

SELECT cte.name,cte.dr
FROM CTE
WHERE cte.dr<4


Question
Classify facilities into equally sized groups of high, average, and low based on their revenue. Order by classification and facility name.




WITH CTE AS (SELECT f.name as name,NTILE(3) OVER(ORDER BY 
SUM(CASE WHEN b.memid=0 THEN (b.slots*f.guestcost) ELSE (b.slots*f.membercost) END) DESC) REVENUE
FROM cd.facilities f INNER JOIN cd.bookings b ON 
f.facid=b.facid
GROUP BY 1)

SELECT name,
CASE WHEN revenue=1 then 'high'
     when revenue=2 then 'average'
     when revenue=3 then 'low'
END 
FROM CTE 
ORDER BY revenue,name


Question:

Based on the 3 complete months of data so far, calculate the amount of time each facility will take to repay its cost of ownership. Remember to take into account ongoing monthly maintenance. Output facility name and payback time in months, order by facility name. Don't worry about differences in month lengths, we're only looking for a rough value here!


SELECT f.name,
f.initialoutlay/((SUM(CASE WHEN b.memid=0 THEN b.slots*f.guestcost ELSE b.slots*f.membercost end)/3)-f.monthlymaintenance)
FROM cd.facilities f INNER JOIN cd.bookings b ON
f.facid=b.facid
						GROUP BY f.facid
						ORDER BY 1


For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. Output should contain date and revenue columns, sorted by the date. Remember to account for the possibility of a day having zero revenue. This one's a bit tough, so don't be afraid to check out the hint!
		 