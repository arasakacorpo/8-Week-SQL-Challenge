WITH sales_points AS (
SELECT
*,
CASE
WHEN product_name = "sushi" THEN product_price * 20 ELSE product_price * 10 END AS points_earned
FROM
sales
JOIN
menu
USING(product_id)
)

SELECT 
customer_id,
SUM(points_earned)
FROM
sales_points
GROUP BY customer_id;