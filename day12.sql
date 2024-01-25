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
WITH cte AS
(SELECT *,
ROW_NUMBER () OVER(PARTITION BY card_name ORDER BY issued_amount, issue_month, issue_year) AS ranking
FROM monthly_cards_issued)
SELECT card_name, issued_amount
FROM cte
WHERE ranking = 1
ORDER BY issued_amount DESC;

