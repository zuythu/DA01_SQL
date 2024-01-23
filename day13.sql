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

--ex06
SELECT
date_format(trans_date, '%Y-%m') AS month,
country,
COUNT(*) AS trans_count,
SUM(CASE
WHEN state = 'approved' THEN 1
ELSE 0
END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE
WHEN state = 'approved' THEN amount
ELSE 0
END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--ex07
WITH cte AS
(SELECT product_id, min(year) AS first_year
FROM Sales
GROUP BY product_id)
SELECT 
s.product_id,
cte.first_year,
s.quantity,
s.price
FROM Sales AS s
JOIN Product AS p
ON s.product_id = p.product_id
JOIN cte
ON s.product_id = cte.product_id
AND s.year = cte.first_year;

--ex08
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT Customer.product_key) = (SELECT COUNT(product_key) FROM Product);

--ex09
SELECT e.employee_id
FROM Employees e
LEFT JOIN Employees m
ON e.manager_id = m.employee_id
WHERE e.salary < 30000 
AND m.employee_id IS NULL 
AND e.manager_id IS NOT NULL
ORDER BY employee_id;

--ex10
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

--ex11
WITH cte AS
(SELECT b.user_id,
b.name AS name,
COUNT(movie_id) AS rated_count
FROM Users AS b
JOIN MovieRating AS c
ON b.user_id = c.user_id
GROUP BY b.user_id, b.name),
cte2 AS (SELECT
a.title AS movie,
AVG(c.rating)
FROM Movies AS a
JOIN MovieRating AS c
ON a.movie_id = c.movie_id
WHERE c.created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY a.title
ORDER BY AVG(c.rating) DESC, a.title
LIMIT 1)

(SELECT name  AS results FROM cte
WHERE rated_count = (SELECT MAX(rated_count) FROM cte )
ORDER BY name 
LIMIT 1)

UNION

(SELECT movie  AS results FROM cte2)

--ex12
SELECT
id,
COUNT(id) AS num
FROM (SELECT requester_id AS id
FROM RequestAccepted
UNION ALL 
SELECT accepter_id AS id
FROM RequestAccepted) AS all_users
GROUP BY id
ORDER BY COUNT(id) DESC
LIMIT 1

