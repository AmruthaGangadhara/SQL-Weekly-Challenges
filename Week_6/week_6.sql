/*Question 1
The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.*/


Solution 1:

select memid,regexp_replace(telephone,'\D','','g') from cd.members --replaced any non numeric character with space

Solution 2: 
with t1 as (select memid, 
regexp_match(telephone, '\D*([0-9]{3})\D*([0-9]{3})\D*([0-9]{4})') regex     --used regex to match the digits which will result in a 
from cd.members)                                                                                                        --set of 3 matches. 
select t1.memid,concat(t1.regex[1],t1.regex[2],t1.regex[3]) telephone                                                    --concatenetaed the 3 matches of sets as telephone
from t1

/*Question 2

Output the names of all members, formatted as 'Surname, Firstname'

Solution: 
SELECT concat(surname,',',' ',firstname) as name
FROM cd.members
