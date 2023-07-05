Question
Find all facilities whose name begins with 'Tennis'. Retrieve all columns.

SELECT *
FROM cd.facilities 
WHERE name LIKE 'Tennis%'

Question
Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. Retrieve all columns.

SELECT *
FROM cd.facilities 
WHERE UPPER(name) like 'TENNIS%'

Question
You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.


SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'

Question

The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a numeric type. Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with leading zeroes. Order by the new zip code.

select lpad(cast(zipcode as char(5)),5,'0') zip
from cd.members

Question

You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.

SELECT LEFT(surname,1) letter, count(*)
from cd.members
GROUP BY 1
ORDER BY 1


Question
The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.

with t1 as (select memid, 
regexp_match(telephone, '\D*([0-9]{3})\D*([0-9]{3})\D*([0-9]{4})') regex
from cd.members)
select t1.memid,concat(t1.regex[1],t1.regex[2],t1.regex[3]) telephone
from t1
order by 1