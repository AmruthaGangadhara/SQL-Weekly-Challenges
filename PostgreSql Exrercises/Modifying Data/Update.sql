Question
We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

UPDATE cd.facilities
SET initialoutlay=10000 WHERE name='Tennis Court 2';

Question
We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for members, and 30 for guests.

UPDATE cd.facilities
SET membercost=6 ,
    guestcost=30 
WHERE name LIKE '%Tennis Court%' 

Question
We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.


UPDATE cd.facilities
SET membercost=(SELECT membercost+(0.1*membercost) FROM cd.facilities
				WHERE facid=0),
    guestcost=(SELECT guestcost+(0.1*guestcost) FROM cd.facilities
				WHERE facid=0)
	WHERE facid=1