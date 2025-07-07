WITH test AS (
SELECT
product_id, 
COUNT(*) as times_sold
FROM sales
GROUP BY product_id
ORDER BY times_sold DESC
LIMIT 1
)

SELECT
product_name,
times_sold
FROM
test
JOIN 
menu
USING(product_id);