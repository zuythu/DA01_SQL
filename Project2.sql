--ex01
FORMAT_TIMESTAMP('%Y-%m', created_at) AS year_month,
total_user,
total_order
from (
select
count(distinct user_id) as total_user,
count(distinct order_id) as total_order,
extract(month from created_at) as month,
extract(year from created_at) as year
from bigquery-public-data.thelook_ecommerce.order_items
group by year, month
order by year, month)
limit 40

--ex02
SELECT 
FORMAT_TIMESTAMP('%Y-%m', created_at) AS year_month,
count(distinct user_id) as distinct_users,
avg(sale_price) as average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_TIMESTAMP('%Y-%m', created_at) between '2019-01' and '2022-04'
group by year_month
order by year_month

--ex03
SELECT first_name, last_name, gender, age, tag
FROM
(SELECT first_name, last_name, gender, age,
DENSE_RANK () OVER(PARTITION BY gender ORDER BY age ) AS ranking,
'youngest' AS tag,
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_TIMESTAMP('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
WHERE ranking = 1

UNION ALL

SELECT first_name, last_name, gender, age, tag
FROM
(SELECT first_name, last_name, gender, age,
DENSE_RANK () OVER(PARTITION BY gender ORDER BY age DESC ) AS ranking,
'oldest' AS tag,
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_TIMESTAMP('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
WHERE ranking = 1;


--ex04
SELECT 
year_month, product_id, product_name, sales, cost, profit, rank_per_month
FROM
(SELECT 
FORMAT_TIMESTAMP('%Y-%m', b.created_at) AS year_month,
b.product_id AS product_id,
a.name AS product_name,
a.retail_price AS sales,
a.cost,
(a.retail_price - a.cost) AS profit,
DENSE_RANK()OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at) ORDER BY (a.retail_price - a.cost) DESC ) AS rank_per_month
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id = b.product_id) 
WHERE rank_per_month <= 5
ORDER BY year_month, rank_per_month;


--ex05
SELECT 
DATE(b.created_at) AS dates,
a.category AS product_categories,
SUM(a.retail_price) AS revenue,
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id = b.product_id
WHERE DATE(b.created_at) BETWEEN '2022-01-15' AND '2022-04-15'
GROUP BY dates, product_categories  
ORDER BY dates ,product_categories;
---------------------------------------------------PART2-------------------------------------------------------------------
WITH cte1 AS 
(SELECT 
FORMAT_TIMESTAMP('%Y-%m', b.created_at) AS month,
EXTRACT(YEAR FROM b.created_at) AS year,
c.category AS product_category,
SUM(a.sale_price) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at), EXTRACT(YEAR FROM b.created_at)),
SUM(c.cost) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at), EXTRACT(YEAR FROM b.created_at)),
ROUND(SUM(a.sale_price) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at), EXTRACT(YEAR FROM b.created_at)) -
SUM(c.cost) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at), EXTRACT(YEAR FROM b.created_at)),2) AS TPV,
COUNT(a.id) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m', b.created_at), EXTRACT(YEAR FROM b.created_at)) AS TPO

FROM bigquery-public-data.thelook_ecommerce.order_items AS a 
JOIN bigquery-public-data.thelook_ecommerce.orders AS b
ON a.order_id = b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c
ON a.product_id = c.id)
