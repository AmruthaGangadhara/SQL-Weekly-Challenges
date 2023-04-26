/* Question:

Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition:

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.
Effective April 15th, 2023, the question and solution for this question have been revised.

measurements Table:
Column Name	Type
measurement_id	integer
measurement_value	decimal
measurement_time	datetime
measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	1109.51	07/10/2022 09:00:00
135211	1662.74	07/10/2022 11:00:00
523542	1246.24	07/10/2022 13:15:00
143562	1124.50	07/11/2022 15:00:00
346462	1234.14	07/11/2022 16:45:00


Solution : */

WITH row_num as (SELECT *, ROW_NUMBER() OVER(partition by cast(measurement_time as date) ORDER BY  measurement_time )  --included row number by ordering the daat wrt time.
FROM measurements)
SELECT date_trunc('day',row_num.measurement_time) measurement_day,         --using cte, selected the required data using case when and group by
SUM(CASE WHEN row_number%2!=0 THEN measurement_value END) odd_sum,
SUM(CASE WHEN row_number%2=0 THEN measurement_value END) even_sum
FROM row_num
GROUP BY 1
order by 1