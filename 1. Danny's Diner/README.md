## 8 Week SQL Challenge - Week 1 - Danny's Diner

I am attempted the 8 Week SQL challenge with the goal of improving my SQL skills and also improving my problem solving skills. I've often found it difficult to spend time using SQL on a daily basis as the day is often full of meetings, meaning that I'm often a little rusty when starting to code after a while.

The first weeks challenge sees you querying the data around Danny's Diner, a fictional resturant serving the most delicious Japanese food! (I too love Japanese food so often felt hungry after doing this challenge!)

The database schema is quite simple, consisting of; **sales**, **menu** and **members**. Danny provides an ERD and a preview of the data within the tables, just to give you an idea of the type of data that I would be working with. 

I originally chose to use MYSQL as the DB for this challenge as I was already familiar with it. I began by using the MySQL workbench, but later moved to VSCode so that I could use Git and execute queries against the DB from the same IDE. This was made possible by using the **SQLTools** VS Code plugin. 

The process began with creating the tables within MySQL and exploring the data within the tables. I quickly felt comfortable with the data, given the simple schema design and began answering the questions.

### Questions & Answers 

**1. What is the total amount each customer spent at the restaurant?**

```sql
SELECT
customer_id,
SUM(menu.product_price) as total_customer_spend
FROM sales
JOIN menu 
ON menu.product_id = sales.product_id
GROUP BY customer_id;
```
#### Results:
| customer_id | total_customer_spend
| --- | --- |
| A | 76 |
| B | 74 |
| C | 36 |

---

**2. How many days has each customer visited the restaurant?**

```sql
SELECT
customer_id,
COUNT(order_date) as num_orders
FROM sales
GROUP BY customer_id;
```

#### Results:
| customer_id | num_orders |
| --- | --- |
| A | 6 |
| B | 6 |
| C | 3 |

---

**3. What was the first item from the menu purchased by each customer?**
```sql
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
```

#### Results:
| customer_id | order_date | product_name |
| --- | --- | --- |
| A | 2021-01-01 | sushi |
| A | 2021-01-01 | curry |
| B | 2021-01-01 | curry |
| C | 2021-01-01 | ramen |
| C | 2021-01-01 | ramen |

---

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```sql
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
```

#### Results:
| product_name | times_sold |
| --- | --- |
| ramen | 8 |

---

**5. Which item was the most popular for each customer?**

```sql
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
```

#### Results:
| customer_id | product_name | total_ordered |
| --- | --- | --- |
| B | sushi | 2 |
| B | curry | 2 |
| A | ramen | 3 |
| B | ramen | 2 |
| C | ramen | 3 |

---

**6. Which item was purchased first by the customer after they became a member?**

```sql
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
```

#### Results:
| customer_id | order_date | product_id | product_name |
| --- | --- | --- | --- |
| A | 2021-01-07 | 2 | curry |
| B | 2021-01-11 | 1 | sushi |

---

## 7.Which item was purchased just before the customer became a member? ##

```sql
WITH prior_sales_by_members AS (
	SELECT
    customer_id,
    order_date,
    product_id,
    join_date,
    datediff(JOIN_DATE, ORDER_DATE) as days_after_joining,
    RANK() OVER (PARTITION BY customer_id ORDER BY datediff(ORDER_DATE, JOIN_DATE) ASC) as order_seq
    FROM 
    sales
    JOIN
    members
    USING(customer_id)
	WHERE order_date <= join_date
)
SELECT 
customer_id,
order_date,
product_id,
product_name
FROM
prior_sales_by_members
JOIN menu
USING(product_id)
WHERE order_seq = 1;
```

#### Results:
| customer_id | order_date | product_id | product_name |
| --- | --- | --- | --- |
| A | 2021-01-01 | 1 | sushi |
| A | 2021-01-01 | 2 | curry |
| B | 2021-01-01 | 2 | curry |

---

## 8.What is the total items and amount spent for each member before they became a member?##



```sql
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
```


#### Results:
| customer_id | COUNT(product_id) | SUM(product_price) |
| --- | --- | --- |
| B | 3 | 40 |
| A | 2 | 25 |


---

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?



```sql
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
```


#### Results:
| customer_id | SUM(points_earned) |
| --- | --- |
| A | 860 |
| B | 940 |
| C | 360 |


---

## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
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
```

#### Results:
| customer_id | SUM(points_earned) |
| --- | --- |
| A | 860 |
| B | 940 |
| C | 360 |


## Bonus Question - Part 1 - Join all things

```sql
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
member
FROM all_things
ORDER BY customer_id, order_date, product_name ASC
```

### Results
| customer_id | order_date | product_name | price | member |
| --- | --- | --- | --- | --- | 
| A | 2021-01-01 | curry | 15 | N |
| A | 2021-01-01 | sushi | 10 | N |
| A | 2021-01-07 | curry | 15 | Y |
| A | 2021-01-10 | ramen | 12 | Y |
| A | 2021-01-11 | ramen | 12 | Y |
| A | 2021-01-11 | ramen | 12 | Y |
| B | 2021-01-01 | curry | 15 | N |
| B | 2021-01-02 | curry | 15 | N |
| B | 2021-01-04 | sushi | 10 | N |
| B | 2021-01-11 | sushi | 10 | Y |
| B | 2021-01-16 | ramen | 12 | Y |
| B | 2021-02-01 | ramen | 12 | Y |
| C | 2021-01-01 | ramen | 12 | N |
| C | 2021-01-01 | ramen | 12 | N |
| C | 2021-01-07 | ramen | 12 | N |

## Bonus Question - Part 2 - Join All Things

```sql
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
```

### Results
| customer_id | order_date | product_name | price | member | ranking |
|-------------|------------|--------------|-------|--------|---------|
| A           | 2021-01-01 | sushi        | 10    | N      |         |
| A           | 2021-01-01 | curry        | 15    | N      |         |
| A           | 2021-01-07 | curry        | 15    | Y      | 1       |
| A           | 2021-01-10 | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01 | curry        | 15    | N      |         |
| B           | 2021-01-02 | curry        | 15    | N      |         |
| B           | 2021-01-04 | sushi        | 10    | N      |         |
| B           | 2021-01-11 | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16 | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01 | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01 | ramen        | 12    | N      |         |
| C           | 2021-01-01 | ramen        | 12    | N      |         |
| C           | 2021-01-07 | ramen        | 12    | N      |         |


