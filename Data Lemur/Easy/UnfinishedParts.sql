/* Question :

Tesla is investigating production bottlenecks and they need your help to extract the relevant data. Write a query that determines which parts with the assembly steps have initiated the assembly process but remain unfinished.

Assumptions:

parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
An unfinished part is one that lacks a finish_date.
This question is straightforward, so let's approach it with simplicity in both thinking and solution.

Effective April 11th 2023, the problem statement and assumptions were updated to enhance clarity.

parts_assembly Table
Column Name	Type
part	string
finish_date	datetime
assembly_step	integer

Solution: */

SELECT part ,assembly_step
FROM parts_assembly
WHERE finish_date IS NULL