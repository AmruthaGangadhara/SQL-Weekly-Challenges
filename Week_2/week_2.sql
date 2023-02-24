/*Question 1
Find the result of subtracting the timestamp '2012-07-30 01:00:00' from the timestamp '2012-08-31 01:00:00'*/

Solution:
SELECT timestamp '2012-08-31 01:00:00'- timestamp '2012-07-30 01:00:00' as  interval


/*Question 2
Return a count of bookings for each month, sorted by month*/

SELECT date_trunc('month',starttime),count(*) --selecting the month part of the timestamp
FROM cd.bookings
GROUP BY date_trunc('month',starttime)        --Grouping by the month and sorting the result by date
ORDER BY 1 
