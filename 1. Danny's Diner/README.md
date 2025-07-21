## 8 Week SQL Challenge - Week 1 - Danny's Diner

I am attempted the 8 Week SQL challenge with the goal of improving my SQL skills and also improving my problem solving skills. I've often found it difficult to spend time using SQL on a daily basis as the day is often full of meetings, meaning that I'm often a little rusty when starting to code after a while.

The first weeks challenge sees you querying the data around Danny's Diner, a fictional resturant serving the most delicious Japanese food! (I too love Japanese food so often felt hungry after doing this challenge!)

The database schema is quite simple, consisting of; **sales**, **menu** and **members**. Danny provides an ERD and a preview of the data within the tables, just to give you an idea of the type of data that I would be working with. 

I originally chose to use MYSQL as the DB for this challenge as I was already familiar with it. I began by using the MySQL workbench, but later moved to VSCode so that I could use Git and execute queries against the DB from the same IDE. This was made possible by using the **SQLTools** VS Code plugin. 

The process began with creating the tables within MySQL and exploring the data within the tables. I quickly felt comfortable with the data, given the simple schema design and began answering the questions.

### Questions & Answers 

**1. What is the total amount each customer spent at the restaurant?**

```
SELECT
customer_id,
SUM(menu.product_price) as total_customer_spend
FROM sales
JOIN menu 
ON menu.product_id = sales.product_id
GROUP BY customer_id;
```