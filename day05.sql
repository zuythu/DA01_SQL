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
