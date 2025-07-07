WITH orders_by_members AS (
SELECT
sales.customer_id,
members.join_date,
sales.product_id,
sales.order_date,
menu.product_name,
menu.product_price,
CASE
	WHEN DATEDIFF(order_date, join_date) BETWEEN 0 AND 7 THEN product_price * 20
    WHEN product_name = "Sushi" THEN product_price * 20
    ELSE product_price * 10
END AS points_earned 
FROM
sales
JOIN
members
USING(customer_id)
left JOIN
menu
USING(product_id)
)

SELECT
customer_id,
SUM(points_earned)
FROM
orders_by_members
GROUP BY customer_id;