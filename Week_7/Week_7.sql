/*Question 1
Return a count of bookings for each month, sorted by month*/

Solution 1:

SELECT date_trunc('month',starttime),count(*)
FROM cd.bookings
GROUP BY date_trunc('month',starttime)
ORDER BY 1 



/*Question 2

Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
Solution: */

SELECT m.surname,m.firstname,m.memid,min(b.starttime)
FROM cd.bookings b INNER JOIN 
cd.members m on
b.memid=m.memid
where b.starttime>'2012-09-01 00:00:00'
group by m.memid,1,2
order by m.memid
