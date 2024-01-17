--ex01
SELECT 
SUM(CASE
 WHEN device_type = 'laptop' THEN 1
 ELSE 0
END) AS laptop_views,
SUM(CASE
 WHEN device_type IN ('phone', 'tablet') THEN 1
 ELSE 0
 END) AS mobile_views
FROM viewership;

--ex02
SELECT
x,y,z,
CASE
 WHEN x < y + z and y < x + z and z < x + y THEN 'Yes'
 ELSE 'No'
END AS triangle
FROM Triangle;

--ex03
SELECT 
ROUND(100.0 * COUNT(case_id)/ (SELECT COUNT(*) FROM callers),1) AS call_percentage
FROM callers
WHERE call_category IS NULL 
OR call_category = 'n/a';

--ex04
# Write your MySQL query statement below
SELECT name FROM Customer
WHERE NOT referee_id = 2
OR referee_id IS NULL;

--ex05
SELECT
survived,
SUM(CASE 
 WHEN pclass=1 THEN 1
 ELSE 0
END) AS first_class,
SUM(CASE 
 WHEN pclass=2 THEN 1
 ELSE 0
END) AS second_class,
SUM(CASE
 WHEN pclass=3 THEN 1
 ELSE 0
END) AS third_class
FROM titanic
GROUP BY survived;
