WITH sales_cte AS (
SELECT
customer_id,
sales.product_id,
COUNT(sales.product_id) as total_ordered
FROM sales
GROUP BY sales.product_id, customer_id
), 
sales_ranked AS (
SELECT 
customer_id,
product_id,
total_ordered,
RANK() OVER (PARTITION BY customer_id ORDER BY total_ordered DESC) as rank_fav
FROM sales_cte
)

SELECT 
customer_id, 
product_name,
total_ordered
FROM 
sales_ranked
JOIN menu
ON sales_ranked.product_id = menu.product_id
WHERE rank_fav = 1;