WITH sales_before_member AS (
SELECT 
customer_id,
order_date,
product_id,
join_date,
product_price
FROM
sales
JOIN members
USING(customer_id)
JOIN menu
USING (product_id)
WHERE order_date < join_date
)

SELECT 
customer_id,
COUNT(product_id),
SUM(product_price)
FROM
sales_before_member
GROUP BY customer_id;