WITH customer_order_seq AS (
SELECT
s.customer_id,
s.product_id,
s.order_date,
RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date ASC) as order_seq
FROM sales as s
)

SELECT 
customer_id,
order_date,
product_name
FROM
customer_order_seq
INNER JOIN menu as m
ON customer_order_seq.product_id = m.product_id
WHERE order_seq = 1;