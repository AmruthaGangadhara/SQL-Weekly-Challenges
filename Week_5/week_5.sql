/*Question 1
Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.*/

Solution:
SELECT f.facid facid,sum(b.slots) Total_Slots
FROM cd.facilities f INNER JOIN cd.bookings b on
f.facid=b.facid
GROUP BY 1
HAVING sum(b.slots)>1000   --used having as i had to filter on data once aggregations were done.
ORDER BY 1

/*Question 2

Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!.*/

--First lets generate a query to calculate revenue(slots*cost)
WITH T1 AS (SELECT b.memid,f.facid facid,f.name as name,
CASE WHEN b.memid=0 THEN b.slots*f.guestcost             --adding a case statement to check if its a guest and consider guestcost to calculate revenue, membercost otherwise.
else b.slots*f.membercost
END Revenue
FROM cd.facilities f INNER JOIN cd.bookings b on
f.facid=b.facid)
SELECT name,sum(T1.Revenue) Revenue --using this CTE, Lets select facility name and revenue
FROM T1
GROUP BY 1
ORDER BY 2
