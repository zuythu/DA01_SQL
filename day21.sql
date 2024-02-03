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
--> tổng đơn hàng và khách hàng theo từng tháng tăng từ 1/2019 đến 4/2022
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
