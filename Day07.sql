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
