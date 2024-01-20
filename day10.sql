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

--ex06
SELECT 
DISTINCT p.product_name, 
SUM(o.unit) AS unit
FROM Products AS p
JOIN Orders AS o
ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING unit >=100;

--ex07
SELECT a.page_id
FROM pages AS a  
JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE liked_date IS NULL
ORDER BY a.page_id;

--question01
SELECT DISTINCT replacement_cost 
FROM film
ORDER BY replacement_cost;

--question02
SELECT 
COUNT(film_id),
CASE 
 WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
 WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
 WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEn 'high'
 ELSE NULL
END replacement_group
FROM film
GROUP BY replacement_group;

--question03
SELECT 
a.title,
a.length,
c.name AS category_name
FROM film AS a
LEFT JOIN film_category AS b
ON a.film_id = b.film_id
LEFT JOIN category AS c
ON b.category_id = c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY a.length DESC;

--question04
SELECT 
c.name,
COUNT(a.title)
FROM film AS a
LEFT JOIN film_category AS b
ON a.film_id = b.film_id
LEFT JOIN category AS c
ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY COUNT(a.title) DESC;

--question05
SELECT 
a.actor_id,
a.first_name,
a.last_name,
COUNT(b.film_id)
FROM actor AS a
JOIN film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY a.actor_id 
ORDER BY COUNT(b.film_id) DESC
LIMIT 1;

--question06
SELECT 
COUNT(*)
FROM address AS a
LEFT JOIN customer AS c
ON a.address_id = c.address_id
WHERE customer_id IS NULL;

--question07
SELECT 
a.city,
sum(e.amount) AS avg_amount
FROM city AS a
JOIN country AS b
ON a.country_id = b.country_id
JOIN address AS c
ON a.city_id = c.city_id
JOIN customer AS d
ON d.address_id = c.address_id
JOIN payment AS e
ON e.customer_id = d.customer_id
GROUP BY a.city
ORDER BY sum(e.amount) DESC;

--question 08
SELECT 
a.city ||', '|| b.country AS city_country,
sum(e.amount) AS avg_amount
FROM city AS a
JOIN country AS b
ON a.country_id = b.country_id
JOIN address AS c
ON a.city_id = c.city_id
JOIN customer AS d
ON d.address_id = c.address_id
JOIN payment AS e
ON e.customer_id = d.customer_id
GROUP BY b.country, a.city
ORDER BY sum(e.amount) DESC;

