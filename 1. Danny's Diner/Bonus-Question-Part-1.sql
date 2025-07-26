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
    JOIN members
    USING(customer_id)
)

SELECT 
customer_id,
order_date,
product_name,
price, 
member
FROM all_things
ORDER BY customer_id, order_date, product_name ASC