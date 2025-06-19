-- Names of sales representatives, accounts they manage, and regions

SELECT 
	region.name AS region,
	sales_reps.name AS sales_rep,
	accounts.name AS account
FROM accounts 
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
ORDER BY accounts.name ASC;

-- Unit price paid per order. Order, region, account name, and unit price
SELECT 
	orders.id AS order_id,
	region.name AS region,
	accounts.name AS account_name,
CASE
	WHEN (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)) > 0
	THEN ROUND(orders.total_amt_usd / (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)), 2)
	ELSE 0
 	END AS unit_price_usd
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
ORDER BY orders.id;

-- Channels with the most web traffic

SELECT channel,
	COUNT(*) AS Most_web_traffic 
FROM web_events
GROUP BY channel
ORDER BY Most_web_traffic DESC;

-- How web engagement channels are performing for each sales rep
SELECT sales_reps.name AS Sales_reps, web_events.channel,
		COUNT(*) AS event_count
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps, web_events.channel
ORDER BY event_count DESC;

-- High Volume Orders
SELECT 
	region.name AS region,
	accounts.name AS account_name,
	CASE
		WHEN (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)) > 0
		THEN ROUND(orders.total_amt_usd / (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)), 2)
	ELSE 0
	END AS unit_price_usd
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
WHERE orders.standard_qty > 100
ORDER BY unit_price_usd DESC;

-- Orders in 2015
SELECT 
	orders.occurred_at AS order_date,
	accounts.name AS account_name,
	(COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0))
	AS total_quantity, orders.total_amt_usd
FROM orders 
JOIN accounts ON orders.account_id = accounts.id
WHERE orders.occurred_at >= '2015-01-01'
AND orders.occurred_at < '2026-01-01' 
ORDER BY order_date;


-- High Volume Orders (Standard + Posters). Show region, account name, and poster items
SELECT 
	accounts.name AS Account_name,
	region.name AS region,
	CASE
		WHEN (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)) > 0
		THEN ROUND(orders.total_amt_usd / (COALESCE(orders.standard_qty, 0) + COALESCE(orders.poster_qty, 0) + COALESCE(orders.gloss_qty, 0)), 2)
		ELSE 0
END AS unit_price_usd
From orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id
WHERE orders.standard_qty > 100
  AND orders.poster_qty > 50
ORDER BY unit_price_usd DESC;
	

