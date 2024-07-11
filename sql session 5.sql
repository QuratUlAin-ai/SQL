-- Full Join
-- Include all data from customers and purchase history


select c.*, ph.*
from customer c
left join purchase_history ph
on c.customer_id =ph.customer_id

union

select c.*, ph.*
from customer c
right join purchase_history ph
on c.customer_id =ph.customer_id;


-- self join
select * from customer;
select c1.first_name as customer_1,
c2.first_name as customer_2,
c2.phone_number as customer_2_phone
from customer c1
join customer c2
on c1.phone_number = c2.phone_number
and c1.customer_id <> c2.customer_id;

select * from customer;
select c1.first_name as customer_1,
c2.first_name as customer_2,
c2.city as customer_2_city
from customer c1
join customer c2
on c1.city = c2.city
and c1.customer_id <> c2.customer_id;

-- Exercise 3: Which products have similar prices?
SELECT 
    p1.product_id AS p1_ID,
    p1.product_name AS p1_Name,
    p2.product_id AS p2_ID,
    p2.product_name AS p2_Name,
    ABS(p1.price_per_unit - p2.price_per_unit) AS price_difference
FROM
    products p1
        JOIN
    products p2 ON p1.product_id < p2.product_id
WHERE
    ABS(p1.price_per_unit - p2.price_per_unit) < 3;

-- Exercise: Pair each category with brand 
-- cross + self join
select * from products;
SELECT 
    p1.category, p2.brand
FROM
    products p1
        CROSS JOIN
    products p2;
--
SELECT 
   distinct p1.category, p2.brand
FROM
    products p1
        CROSS JOIN
    products p2
    order by p1.category, p2.brand;

--
SELECT avg(price_per_unit) FROM session_04.products;
-- '19.91466666666667'

-- list down products with price greater than average
select *
from products
where price_per_unit >  (SELECT avg(price_per_unit) FROM products);

-- subqueries

-- Exercise: Display details of product which has the highest price?

select * from products;
-- Method-1
select max(price_per_unit) from products;
SELECT 
    *
FROM
    products
WHERE
    price_per_unit = 30;

-- Method 2
SELECT 
    *
FROM
    products
ORDER BY price_per_unit DESC
LIMIT 1;
--

-- Using Subquery
SELECT 
    *
FROM
    products
WHERE
    price_per_unit = (SELECT MAX(price_per_unit) FROM products);
    
    
--
select *
 from products
 where product_id in ( select distinct product_id from purchase_history) ;
-- Exercise 1: Find the product details for products that have been purchased.

--
-- Exercise 2: List the names of customers who have made purchases of a product with a specific product_id (e.g., product_id = 1).
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT DISTINCT customer_id
    FROM purchase_history where product_id=1
);

-- Exercise: How many products are there in the database, and what is the total sales amount across all products?
select count(*) from products;
select sum(total_amount) from purchase_history;

SELECT 
    COUNT(*) as total_products,
    (select sum(total_amount) from purchase_history) as "Total sales"
FROM
    products;

-- Exercise: Label products as "Expensive" if price per unit is above the average , "Not Expensive" if below.

select avg(price_per_unit) from products;

SELECT 
    *,
    CASE
        WHEN price_per_unit > (select avg(price_per_unit) from products) THEN 'Expensive'
        ELSE 'Not expensive'
    END AS Price_Status
FROM
    products;



















