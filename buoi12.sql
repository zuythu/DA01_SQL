--ex01
SELECT  
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id) AS prev_year_spend,
ROUND((spend - LAG(spend) OVER(PARTITION BY product_id) ) / LAG(spend) OVER(PARTITION BY product_id) *100,2) AS yoy_rate
FROM user_transactions
GROUP BY year, product_id, spend
ORDER BY product_id, year;

--ex02
