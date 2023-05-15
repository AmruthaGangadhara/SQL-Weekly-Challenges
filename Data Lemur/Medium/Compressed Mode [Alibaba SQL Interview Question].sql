/* Question:

Given a table containing the item count for each order and the frequency of orders with that item count, write a query to determine the mode of the number of items purchased per order on Alibaba. If there are several item counts with the same frequency, you should sort them in ascending order.

Effective April 22nd, 2023, the problem statement and solution have been revised for enhanced clarity.

items_per_order Table:
Column Name	Type
item_count	integer
order_occurrences	integer
items_per_order Example Input:
item_count	order_occurrences
1	500
2	1000
3	800
4	1000
 
Solution: */

SELECT item_count FROM items_per_order
WHERE order_occurrences=(SELECT max(order_occurrences)
FROM items_per_order)