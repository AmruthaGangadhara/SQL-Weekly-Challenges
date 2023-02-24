/* Question 1:
How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30?
Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), 
and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries.*/


solution:

SELECT concat(m.firstname,' ',m.surname) as member,                         --Selecting the name of the member by joining the firstname and surname
f.name facility,                                                            --Selecting Facility
CASE WHEN b.memid=0  then f.guestcost*b.slots                               --adding a condition to consider guest cost if the memberid=0(id=0-->guest) 
		  else f.membercost*b.slots END as cost                         --if memid is not equal to 0, then consider member cost to calculate the total cost of the booking
FROM cd.bookings b INNER JOIN cd.members m on                                --Joining the necessary tables
m.memid=b.memid
INNER JOIN cd.facilities f on 
f.facid=b.facid
where (b.starttime>'2012-09-14 00:00:00' and b.starttime<'2012-09-15 00:00:00') --adding the given conditions of date
AND ((m.memid=0 and f.guestcost*b.slots>30) or                                   --adding the second condition to check if the cost is greater than 30 for both members and guests
	 (m.memid!=0 and f.membercost*b.slots>30))
ORDER BY cost DESC                                                                --ordering the result



/*Question 2:
Produce a list of the total number of slots booked per facility in the month of September 2012.
Produce an output table consisting of facility id and slots, sorted by the number of slots.*/

Solution:
SELECT f.facid,sum(b.slots) slots                                               --selecting the facid and total number of slots by adding once it is aggregated
FROM cd.bookings b INNER JOIN cd.facilities f on                                --Joining the necessary tables
b.facid=f.facid
where b.starttime>='2012-09-01 00:00:00' and b.starttime<'2012-10-01 00:00:00'  --adding where as I need to filter the data before aggregation
GROUP BY f.facid                                                                --Grouping by facid and ordering by total num of slots in descending order.
order by  2


/*Question 3:
How can you produce a list of all members who have used a tennis court? 
Include in your output the name of the court, and the name of the member formatted as a single column.
Ensure no duplicate data, and order by the member name followed by the facility name.*/

Solution:
SELECT DISTINCT concat(m.firstname,' ',m.surname) member,f.name --selecting distinct as I have to ensure no duplicate data is present
FROM cd.bookings b INNER JOIN cd.members m on                    --Joining the necessary Tables
b.memid=m.memid
INNER JOIN cd.facilities f on 
f.facid=b.facid
where f.name like '%Tennis Court%'                               --Adding filter to match 'Tennis Court'
order by 1,2                                                     --Ordering the result by member name and facility name ascending order
                       