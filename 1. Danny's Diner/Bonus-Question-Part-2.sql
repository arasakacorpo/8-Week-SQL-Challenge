WITH all_things AS (
    SELECT
    customer_id,
    order_date,
    product_name,
    product_price as price,
    join_date,
    CASE
        WHEN order_date >= join_date THEN 'Y' else 'N' 
    END as member
    FROM
    sales
    JOIN menu
    USING(product_id)
    LEFT JOIN members
    USING(customer_id)
)

SELECT 
customer_id,
order_date,
product_name,
price,
member,
CASE WHEN member = 'Y' THEN RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date ASC)ELSE NULL END AS ranking
FROM all_things;
