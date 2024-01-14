--ex01
SELECT Name
FROM STUDENTS
WHERE Marks > 75
Order by RIGHT(Name,3), ID;

--ex02
SELECT 
user_id, 
CONCAT(UPPER(LEFT(name,1)),'', LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM Users;

--ex03
SELECT 
manufacturer,
'$' || ROUND(SUM(total_sales)/ 1000000,0) || ' million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) desc, manufacturer;

--ex04
SELECT 
EXTRACT(MONTH FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY mth, product
ORDER BY mth, product;

--ex05
SELECT 
sender_id,
COUNT(content) AS message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY message_count desc
LIMIT 2;

--ex06
SELECT 
tweet_id
FROM Tweets
WHERE LENGTH(content) >15;

--ex07
SELECT 
activity_date AS day,
COUNT(DISTINCT(user_id)) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

--ex08
SELECT
COUNT(*) AS number_of_employee
FROM employees
WHERE 
EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(YEAR FROM joining_date) = 2022;

--ex09
select 
POSITION('a' IN first_name)
from worker
WHERE first_name = 'Amitah';

--ex10
SELECT 
SUBSTRING(title, length(winery)+2, 4) AS year_of_wine
FROM winemag_p2
WHERE country = 'Macedonia';

