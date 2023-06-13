CREATE TABLE ExamResult
(StudentName VARCHAR(70), 
 Subject     VARCHAR(20), 
 Marks       INT
);
INSERT INTO ExamResult
VALUES
('Lily', 
 'Maths', 
 65
);
INSERT INTO ExamResult
VALUES
('Lily', 
 'Science', 
 80
);
INSERT INTO ExamResult
VALUES
('Lily', 
 'english', 
 70
);
INSERT INTO ExamResult
VALUES
('Isabella', 
 'Maths', 
 50
);
INSERT INTO ExamResult
VALUES
('Isabella', 
 'Science', 
 70
);
INSERT INTO ExamResult
VALUES
('Isabella', 
 'english', 
 90
);
INSERT INTO ExamResult
VALUES
('Olivia', 
 'Maths', 
 55
);
INSERT INTO ExamResult
VALUES
('Olivia', 
 'Science', 
 60
);
INSERT INTO ExamResult
VALUES
('Olivia', 
 'english', 
 89
);


select * from examresult
/*Rank each student by the subject in which they hve scored well*/

Row_number
SELECT studentname,
row_number() over(partition by studentname order by marks desc) rn,
subject,
marks
FROM examresult


SELECT
subject,studentname, marks,rank()over(partition by subject order by marks desc) rank_num
from examresult


SELECT *, NTILE(2) OVER(ORDER BY marks desc)
FROM examresult


SELECT subject,studentname,marks,NTILE(3) OVER(PARTITION BY subject ORDER BY marks DESC)
FROM examresult