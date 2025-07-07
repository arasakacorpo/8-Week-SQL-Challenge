SELECT
customer_id,
COUNT(order_date) as num_orders
FROM sales
GROUP BY customer_id;