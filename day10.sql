--ex01
SELECT 
COUNTRY.CONTINENT,
FLOOR(AVG(CITY.POPULATION))
FROM CITY 
INNER JOIN COUNTRY
ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;

--ex02
SELECT
ROUND(CAST(SUM(CASE
 WHEN a.signup_action = 'Confirmed' THEN 1
 ELSE 0
END) AS DECIMAL)
/ COUNT(a.signup_action),2)
FROM texts AS a  
LEFT JOIN emails AS b  
ON a.email_id = b.email_id
WHERE NOT b.email_id IS NULL;

--ex03
SELECT 
age_bucket,
ROUND(SUM(CASE
 WHEN activity_type = 'send' THEN time_spent 
 ELSE 0
END) / SUM(time_spent) * 100.0, 2) AS send_perc ,
ROUND(SUM(CASE
 WHEN activity_type = 'open' THEN time_spent 
 ELSE 0
END) / SUM(time_spent) * 100.0, 2) AS open_perc
FROM activities AS a  
LEFT JOIN age_breakdown AS b 
ON a.user_id = b.user_id
WHERE NOT activity_type = 'chat'
GROUP BY age_bucket;

--ex04
SELECT 
customer_id
FROM customer_contracts AS c
LEFT JOIN products AS p  
ON c.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) >= 3;

-ex05
SELECT 
a.employee_id,
a.name,
COUNT(b.reports_to) AS reports_count,
ROUND(AVG(b.age),0) AS average_age
FROM Employees AS a
JOIN Employees AS b
ON a.employee_id = b.reports_to
WHERE NOT b.reports_to IS NULL
GROUP BY a.name, a.employee_id
HAVING COUNT(b.employee_id) >=1
ORDER BY a.employee_id;

