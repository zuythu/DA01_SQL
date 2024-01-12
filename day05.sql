--ex01
SELECT DISTINCT CITY FROM STATION
WHERE ID % 2 = 0;

--ex02
SELECT COUNT(CITY) - COUNT(DISTINCT(CITY))
FROM STATION;

--ex03
SELECT 
CEILING(AVG(Salary) - AVG(REPLACE(Salary,'0','')))
FROM EMPLOYEES;

--ex04
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences)/ SUM(order_occurrences) AS DECIMAL),1) AS mean
FROM items_per_order;

--ex05
SELECT candidate_id
FROM candidates
Where skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3;

--ex06
SELECT user_id,
DATE(MAX(post_date)) - DATE(MIN(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' and '2021-12-31'
GROUP BY user_id
HAVING COUNT(post_id) > 1 ;

--ex07
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC;

--ex08
SELECT 
manufacturer,
Count(drug) as drug_count,
ABS(SUM(cogs - total_sales)) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;

--ex09
SELECT *
FROM Cinema
WHERE id % 2 = 1
AND NOT decription = 'boring'
ORDER BY rating DESC;

--ex10
SELECT 
teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt
FROM Teacher
GROUP BY teacher_id;

--ex11
SELECT user_id, 
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ;

--ex 12
SELECT class
FROM Courses
Group by class
HAVING COUNT(student) >= 5;


