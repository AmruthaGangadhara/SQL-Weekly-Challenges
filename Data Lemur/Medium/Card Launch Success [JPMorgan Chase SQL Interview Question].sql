/* Question :

Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.

monthly_cards_issued Table:
Column Name	Type
issue_month	integer
issue_year	integer
card_name	string
issued_amount	integer
monthly_cards_issued Example Input:
issue_month	issue_year	card_name	issued_amount
1	2021	Chase Sapphire Reserve	170000
2	2021	Chase Sapphire Reserve	175000
3	2021	Chase Sapphire Reserve	180000
3	2021	Chase Freedom Flex	65000
4	2021	Chase Freedom Flex	70000
*/

with cte as (SELECT *,DENSE_RANK() OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) r
FROM monthly_cards_issued)
SELECT card_name,issued_amount
FROM cte WHERE
r=1
ORDER BY 2 DESC