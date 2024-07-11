create database session4;

select * from customer;
select * from products;
select * from purchase_history;
--
select * from customer;
update customer
set date_of_birth = str_to_date(date_of_birth,"%m/%d/%Y");

alter table customer
modify date_of_birth date;
--


--
select * from purchase_history;
update purchase_history
set purchase_date = str_to_date(purchase_date, "%m/%d/%Y %H:%i");

alter table purchase_history
modify purchase_date DATETIME;
--
select * from customer;
update customer
set signup_date = str_to_date(signup_date,"%m/%d/%Y");

alter table customer 
modify signup_date DATE;
--
ALTER TABLE customer
ADD primary key (customer_id);

--
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Table: purchase_history
ALTER TABLE purchase_history
ADD PRIMARY KEY (purchase_id);
--

alter table purchase_history
add constraint fk_customer_id
foreign key (customer_id)
References customer(customer_id);


/*
-- for removing foreign key
alter table purchase_history
drop Foreign key fk_customer_id;
*/

-- product_id in purchase_history refers to product_id in products:
ALTER TABLE purchase_history
ADD Constraint fk_product_id
Foreign Key (product_id)
References products(product_id);

--
select c.* , ph.*
from customer c
inner join purchase_history ph
on c.customer_id = ph.customer_id;
--
-- Exercise 2: Write a query to retrieve product details and their purchase history
select p.* , ph.purchase_date, ph.quantity, ph.total_amount
from products p
inner join purchase_history ph
On p.product_id = ph.product_id;

-- Exercise 3: How many purchases (purchase_id) were made by each customer (customer_id) in total? (only mention those who have made payments)
select c.customer_id, count(ph.purchase_id) "Total Purchases"
from customer c
inner join purchase_history ph
On c.customer_id = ph.customer_id
group by c.customer_id;

-- Exercise 4: Which customers (customer_id) have spent more than $1500 in total (SUM(ph.total_amount)) on purchases?
select c.customer_id, sum(ph.total_amount) "Total Spent"
from customer c
inner join purchase_history ph
On c.customer_id = ph.customer_id
group by c.customer_id
having sum(ph.total_amount) > 1500;

-- Exercise 5: How many purchases (purchase_id) were made for each product category (p.category) that has been purchased?
select p.category, count(ph.purchase_id) "total purchases"
from products p
inner join purchase_history ph
on p.product_id = ph.product_id
group by p.category;

-- Exercise 6: Which products (p.product_name) are most frequently purchased (COUNT(ph.purchase_id)) by Female customers (c.gender = 'Female')?
select p.product_name, COUNT(ph.purchase_id) as "total purchases"
from products p
inner join purchase_history ph
on p.product_id = ph.product_id
inner join customer c
on ph.customer_id = c.customer_id
where c.gender = "Female"
group by p.product_name
order by COUNT(ph.purchase_id) desc;

-- Left Join
-- Exercise 1: Which customers (customer_id) have not made any purchases (ph.purchase_id IS NULL)?
select c.*, ph.*
from customer c
left join purchase_history ph
on c.customer_id = ph.customer_id
where ph.purchase_id is NULL;

-- Exercise 2: Which products (product_id) have not been purchased (ph.purchase_id IS NULL)?
select p.*, ph.*
from products p
left join purchase_history ph
on p.product_id = ph.product_id
where ph.purchase_id is NULL;

-- Exercise 3: Analyze the sales (total_amount) for all products.
select p.product_name, sum(ph.total_amount) as "Total amount"
from products p
left join purchase_history ph
on p.product_id = ph.product_id
group by p.product_name;

-- Exercise 1: What is the total number of purchases (COUNT(ph.purchase_id)) and the total amount spent (SUM(ph.total_amount)) for each product brand (p.brand)?
select p.brand, count(ph.purchase_id) as Total_Purchases, SUM(ph.total_amount) as Total_Amount_Spent
from purchase_history ph
right join products p
on ph.product_id = p.product_id
group by p.brand;

-- Exercise 2: How many purchases (COUNT(ph.purchase_id)) has each customer (c.customer_id) made?
select c.customer_id ,count(ph.purchase_id) as TOtal_purchases
from purchase_history ph
right join customer c
on ph.customer_id = c.customer_id
group by c.customer_id;


















