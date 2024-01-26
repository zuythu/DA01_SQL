--ex01
WITH ranking_order AS
(SELECT delivery_id, customer_id, order_date, customer_pref_delivery_date,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS ranking
FROM Delivery)
SELECT 
ROUND((SELECT COUNT(delivery_id)FROM ranking_order WHERE ranking = 1 AND order_date = customer_pref_delivery_date) / (SELECT COUNT(delivery_id) FROM ranking_order WHERE ranking = 1) * 100,2) AS immediate_percentage;

--ex
WITH overview AS
(SELECT player_id, device_id, event_date,
LAG(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS previous_date,
event_date - LAG(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS day_diff
FROM Activity)
SELECT ROUND((SELECT COUNT(DISTINCT player_id) FROM overview WHERE day_diff >=2) / (SELECT COUNT(DISTINCT player_id) FROM overview) ,2) AS fraction...

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





