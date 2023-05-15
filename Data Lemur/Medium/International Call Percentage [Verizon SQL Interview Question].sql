/* Question :


A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.
phone_calls Table:
Column Name	Type
caller_id	integer
receiver_id	integer
call_time	timestamp
phone_calls Example Input:
caller_id	receiver_id	call_time
1	2	2022-07-04 10:13:49
1	5	2022-08-21 23:54:56
5	1	2022-05-13 17:24:06
5	6	2022-03-18 12:11:49 */

Solution:

with calls as (SELECT caller.country_id cid,receiver.country_id rid
FROM phone_calls AS calls LEFT JOIN phone_info AS caller ON calls.caller_id=caller.caller_id
LEFT JOIN phone_info AS receiver ON calls.receiver_id=receiver.caller_id),
intER_calls as (SELECT SUM(CASE WHEN cid!=rid THEN 1 ELSE 0 END) int_calls, count(*) total_calls
from calls)
SELECT ROUND(CAST (int_calls AS decimal)/CAST (total_calls AS DECIMAL)*100.0,1) international_calls_pct
FROM intER_calls 
