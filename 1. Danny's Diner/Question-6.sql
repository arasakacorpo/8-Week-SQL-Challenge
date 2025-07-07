WITH before_sales_by_members AS (
	SELECT
    customer_id,
    order_date,
    product_id,
    join_date,
    datediff(ORDER_DATE, JOIN_DATE) as days_after_joining,
    RANK() OVER (PARTITION BY customer_id ORDER BY  datediff(ORDER_DATE, JOIN_DATE) ASC) as order_seq
    FROM 
    sales
    JOIN
    members
    USING(customer_id)
	WHERE order_date >= join_date
)
SELECT 
customer_id,
order_date,
product_id,
product_name
FROM
sales_by_members
LEFT JOIN menu 
USING(product_id)
WHERE order_seq = 1;