/* Question:

Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.

Assumptions:

The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.
transactions Table:
Column Name	Type
transaction_id	integer
merchant_id	integer
credit_card_id	integer
amount	integer
transaction_timestamp	datetime

transactions Example Input:
transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp
1	101	1	100	09/25/2022 12:00:00
2	101	1	100	09/25/2022 12:08:00
3	101	1	100	09/25/2022 12:28:00
4	102	2	300	09/25/2022 12:00:00
6	102	2	400	09/25/2022 14:00:00

Solution: */

WITH cards as (SELECT t1.credit_card_id cid,t1.merchant_id,t1.amount,
t1.transaction_timestamp time1,t2.transaction_timestamp time2
FROM transactions t1
JOIN transactions t2 ON
t1.credit_card_id=t2.credit_card_id AND 
t1.merchant_id=t2.merchant_id AND
t1.amount=t2.amount AND t2.transaction_timestamp>t1.transaction_timestamp),

time_diff as (SELECT cards.cid cid,
ROUND((extract(epoch from 
        cards.time2::timestamp - cards.time1::timestamp
    ) / 60),0) td
FROM cards)

SELECT count(*) payment_count
FROM time_diff
WHERE td<=10
