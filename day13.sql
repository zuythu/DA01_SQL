--ex01
WITH table_1 AS 
(SELECT 
company_id,
title,
description,
COUNT(job_id) 
FROM job_listings 
GROUP BY title, description, company_id
HAVING count(job_id) >= 2)
  SELECT COUNT(company_id) AS duplicate_companies
FROM table_1;

--ex02
WITH cte AS
(SELECT category,
product,
sum(spend) AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY sum(spend) DESC) AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product, category)
  SELECT category, product, total_spend
FROM cte 
WHERE ranking <= 2
ORDER BY category, total_spend DESC;

--ex03
/*Write a query to find how many UHG members made 3 or more calls.
case_id column uniquely identifies each call made.*/


WITH cte AS
(SELECT policy_holder_id,
COUNT(*)
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(*) >= 3)
SELECT COUNT(policy_holder_id) AS member_count
FROM cte;

--ex04
SELECT a.page_id
FROM pages AS a  
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE liked_date IS NULL
ORDER BY a.page_id;

--ex05
WITH user_of_month_6 AS
(SELECT user_id
FROM user_actions
WHERE
EXTRACT(MONTH FROM event_date) = 6
GROUP BY user_id),
user_of_month_7 AS
(SELECT user_id,
EXTRACT(MONTH FROM event_date) AS month
FROM user_actions
WHERE
EXTRACT(MONTH FROM event_date) = 7
GROUP BY user_id, EXTRACT(MONTH FROM event_date))
SELECT
user_of_month_7.month,
COUNT(user_of_month_7.user_id) AS monthly_active_users
FROM user_of_month_6
JOIN user_of_month_7
ON user_of_month_7.user_id = user_of_month_6.user_id
GROUP BY user_of_month_7.month;
