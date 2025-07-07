SELECT
customer_id,
SUM(menu.product_price) as total_customer_spend
FROM sales
JOIN menu 
ON menu.product_id = sales.product_id
GROUP BY customer_id;