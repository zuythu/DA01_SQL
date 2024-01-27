--ex01
WITH ranking_order AS
(SELECT delivery_id, customer_id, order_date, customer_pref_delivery_date,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS ranking
FROM Delivery)
SELECT 
ROUND((SELECT COUNT(delivery_id)FROM ranking_order WHERE ranking = 1 AND order_date = customer_pref_delivery_date) / (SELECT COUNT(delivery_id) FROM ranking_order WHERE ranking = 1) * 100,2) AS immediate_percentage;

--ex02
SELECT 
ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) as fraction
FROM Activity
WHERE 
(player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN ( SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id);

--ex03
SELECT 
CASE 
WHEN id = (SELECT MAX(id) FROM seat) AND id % 2 = 1 THEN id
WHEN id % 2 = 1 THEN id + 1
ELSE id -1
END AS id,
student
FROM seat
ORDER BY id;

--ex04
SELECT DISTINCT
    visited_on,
    SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW) AS amount,
    ROUND(SUM(amount) OVER (ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW)/7, 2) AS average_amount
FROM Customer
LIMIT 1000000
OFFSET 6;

--ex05
WITH b AS 
(SELECT  lat, lon, COUNT(*)
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1),
c AS (SELECT tiv_2015, COUNT(*)
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1)
SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance AS a
JOIN b 
ON a.lat = b.lat AND a.lon = b.lon
JOIN c
ON c.tiv_2015 = a.tiv_2015;

--ex06
WITH c AS(SELECT salary, name, departmentId, 
DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC ) AS ranking
FROM Employee)
SELECT b.name AS Department, c.name AS Employee, c.salary
FROM c
JOIN Department AS b
ON c.departmentId = b.id
WHERE c.ranking <= 3;

--ex07
SELECT person_name
FROM 
(SELECT person_name, weight, turn,
SUM(weight) Over(ORDER BY turn) AS total_weight 
FROM Queue) AS total_weight
WHERE total_weight <= 1000
ORDER BY turn DESC
LIMIT 1;

--ex08
WITH b AS
(SELECT product_id, max(change_date) AS date
FROM Products
WHERE change_date <='2019-08-16' 
GROUP BY product_id)

SELECT a.product_id, a.new_price AS price
FROM products AS a
JOIN b
ON a.product_id = b.product_id
AND a.change_date = b.date

UNION 

SELECT DISTINCT product_id, 10 AS price
FROM Products
WHERE NOT product_id IN (select distinct product_id from Products where change_date <='2019-08-16');






