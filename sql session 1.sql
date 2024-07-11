-- Data Definition Language
-- Create Database

create database users_record;

-- use or select database

use users_record;

-- Let's create a table
create table users
(
ID int Primary Key,
user_name VARCHAR(100),
age int
);

-- Retrieve the data
select * from users;

-- Insert a single user entry or record
insert into users (id, user_name, age )
values(1, "Anne", 22);

select * from users;


-- insert multiple rows 
insert into users (id , user_name, age )
values 
(2, "Ahmad", 22 ),
(3, "Ali",23),
(4, "Usman",24),
(5, "Bilal", 22),
(6, "Basit",19),
(7, "Ariyana", 17),
(8, "Daniyal",19),
(9, "Zia", 20),
(10,"Aliyan",19);

select * from users;

-- Load data books_data using "table import wizard"

-- Fetch only two columns
select Book_name, type, on_promotion from books_data;

-- Fetch unique languages

select * from books_data;
select language from book_data;

select distint_language from books_data;

--

select * from books_data;
where product_real_price > 950;

