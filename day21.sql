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
