
Question
How can you produce a list of the start times for bookings by members named 'David Farrell'?

Solution:

SELECT b.starttime
FROM cd.members m INNER JOIN cd.bookings b on
m.memid=b.memid
WHERE m.firstname='David' and m.surname='Farrell'

Question:

How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT b.starttime,f.name
FROM cd.facilities f INNER JOIN cd.bookings b ON f.facid=b.facid
WHERE f.name like '%Tennis Court%' AND DATE_TRUNC('day',b.starttime)='2012-09-21'
ORDER BY 1

Question: #Self Join

How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

WITH recommenders as (SELECT m.memid,m.firstname,m.surname,m.recommendedby  
FROM cd.members m)
SELECT DISTINCT m.firstname,m.surname
FROM cd.members m INNER JOIN recommenders r ON
r.recommendedby=m.memid
ORDER BY 2,1

the approach was to select fname,surname,recommendeby and then join it with the original table on matching recommenderid and memid

Question

How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

WITH rec as (SELECT memid,firstname,surname,recommendedby
FROM cd.members)

SELECT r.firstname,r.surname,m.firstname,m.surname
FROM rec r LEFT JOIN cd.members m ON r.recommendedby=m.memid
ORDER BY 2,1


#The Approach was to select everuthging from the members table and name it as rec ( temp table) and then join it with itself on matching recommenderid =memid as second table.
so from the first table, selected firtname and surname and second table selecting matching recommendersname


Question

How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.

SELECT DISTINCT CONCAT(m.firstname,' ',m.surname),f.name
FROM cd.members m INNER JOIN cd.bookings b ON
m.memid=b.memid
INNER JOIN cd.facilities f ON f.facid=b.facid
WHERE f.name like '%Tennis Court%'
ORDER BY 1,2


Question

How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.


WITH members as (SELECT CONCAT(m.firstname,' ',m.surname) member,
f.name facility,
CASE WHEN m.memid=0 THEN f.guestcost ELSE f.membercost   END AS cost,b.slots slots
FROM cd.members m INNER JOIN cd.bookings b ON m.memid=b.memid
INNER JOIN cd.facilities f ON f.facid=b.facid
WHERE DATE_TRUNC('day',b.starttime)='2012-09-14')
SELECT member,facility,cost * slots
FROM members
WHERE cost * slots>30


Question:

How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.


SELECT DISTINCT CONCAT(m.firstname,' ',m.surname) member, (select concat(firstname,' ',surname) rec from cd.members r where r.memid=m.recommendedby) r
from cd.members m

#The approach was to first select distinct names from members table and then by selecting the names from members table in a subquery where the memid matched the recommendedby in the main query