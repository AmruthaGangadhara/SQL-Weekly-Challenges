Question
As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?

DELETE FROM cd.bookings

Question:

We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

DELETE FROM cd.members
WHERE memid=37;

Question
In our previous exercises, we deleted a specific member who had never made a booking. How can we make that more general, to delete all members who have never made a booking?

DELETE FROM cd.members 
WHERE memid IN (SELECT m.memid
FROM cd.members m LEFT JOIN cd.bookings b ON
m.memid=b.memid
WHERE b.facid IS NULL)