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

--ex03
WITH cte AS
(SELECT 
user_id, spend, transaction_date,
ROW_NUMBER () OVER(PARTITION BY user_id ORDER BY transaction_date ) AS ranking
FROM transactions)
SELECT user_id, spend, transaction_date
FROM cte 
WHERE ranking = 3;

--ex04
WITH cte AS
(SELECT transaction_date, user_id,
COUNT(*) AS purchase_count,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS ranking
FROM user_transactions
GROUP BY transaction_date, user_id
ORDER BY transaction_date)
SELECT transaction_date, user_id, purchase_count
FROM cte  
WHERE ranking = 1
ORDER BY transaction_date;

--ex05
SELECT user_id, tweet_date, 
ROUND(AVG(tweet_count) OVER(
                       PARTITION BY user_id
                       ORDER BY tweet_date
                       ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;

--ex06
WITH cte AS


WITH cte AS
(SELECT merchant_id,
LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_id) AS previous_transaction,
EXTRACT(EPOCH FROM transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp))/60 AS minute_diff
FROM transactions)

SELECT COUNT( merchant_id) AS payment_count
FROM cte 
WHERE minute_diff <= 10;

--ex07
WITH cte AS
(SELECT category,
product,
sum(spend) AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY sum(spend) DESC) AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product, category)

SELECT category, product, total_spend
FROM cte 
WHERE ranking <= 2
ORDER BY category, total_spend DESC;

--ex08
WITH cte AS
(SELECT a.artist_name AS artist_name , 
DENSE_RANK() OVER(ORDER BY  COUNT(b.song_id) DESC ) AS artist_rank
FROM artists AS a  
JOIN songs AS b 
ON a.artist_id = b.artist_id
JOIN global_song_rank AS c 
ON b.song_id = c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name)
SELECT artist_name, artist_rank 
FROM cte 
WHERE artist_rank <= 5;

