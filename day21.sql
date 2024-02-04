--ex01
select year||'-'||month as year_month,
total_user,
total_order
from (
select
sum(distinct user_id) as total_user,
sum(distinct order_id) as total_order,
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
with cte as (select last_name,first_name, age, gender,
FORMAT_TIMESTAMP('%Y-%m', created_at) AS year_month
from bigquery-public-data.thelook_ecommerce.users
where FORMAT_TIMESTAMP('%Y-%m', created_at) between '2019-01' and '2022-04'),
cte2 as (
SELECT
  last_name,
  first_name,
  age,
  gender,
  CASE
    WHEN age = (SELECT MAX(age) FROM cte WHERE gender = 'M') THEN 'oldest'
    WHEN age = (SELECT MAX(age) FROM cte WHERE gender = 'F') THEN 'oldest'
    WHEN age = (SELECT MIN(age) FROM cte WHERE gender = 'M') THEN 'youngest'
    WHEN age = (SELECT MIN(age) FROM cte WHERE gender = 'F') THEN 'youngest'
  END AS tag
FROM
  cte)

SELECT tag, COUNT(*) as number 
FROM cte2
GROUP BY tag;

--ex04
SELECT
  FORMAT_TIMESTAMP('%Y-%m', b.created_at) AS year_month,
  SUM(a.retail_price - a.cost) AS total_profit,
  a.id,
  a.name,
  DENSE_RANK() OVER (PARTITION BY EXTRACT(MONTH FROM b.created_at) ORDER BY SUM(a.retail_price - a.cost)) as ranking 
FROM
  bigquery-public-data.thelook_ecommerce.products AS a
INNER JOIN
  bigquery-public-data.thelook_ecommerce.order_items AS b
ON
  a.id = b.id
GROUP BY
  year_month, a.id, a.name
HAVING ranking <= 5
ORDER BY
  year_month;

--ex05
SELECT
  p.category,
  SUM(oi.quantity * p.price) AS total_revenue
FROM
  bigquery-public-data.thelook_ecommerce.orders AS o
JOIN
  bigquery-public-data.thelook_ecommerce.order_items AS oi ON o.order_id = oi.order_id
JOIN
  bigquery-public-data.thelook_ecommerce.products AS p ON oi.id = p.id
WHERE
   o.created_at <= TIMESTAMP(CURRENT_TIMESTAMP(), INTERVAL 3 MONTH)
GROUP BY
  p.category;
