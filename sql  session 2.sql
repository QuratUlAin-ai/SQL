
-- select database
use users_record;

-- show all the data

select * from books_data;

--
select * from books_data
where Book_name = "alchemist";
--

select * from books_data
where product_real_price> 900;

--
select * from books_data
where language = "hindi";

--
select * from books_data
where discount_offered_prcnt >= 30 and discount_offered_prcnt <= 40;
--

select * from books_data
where language in ("English", "Hindi", "Bengali");

--
select * from books_data
where language not in ("English", "Hindi", "Bengali");

--
select * from books_data
where author like "A%";
--

select * from books_data
where type like "%back";
--
select * from books_data
where type = "other";
--
select * from books_data
where type <> "paperback";
--
select * from books_data
order by author;
--
select * from books_data
order by product_rating desc
limit 5;

--
ALTER TABLE books_data
add record_date date;
--


set sql_safe_updates = 0;
--
select * from books_data;
update books_data
set record_date = "2024-07-02";

select * from books_data;

--
select * from books_data
order by author;
--
update books_data
set author = "a.c. bhaktivedanta swami prabhupada"
where author = "his divine grace a.c. bhaktivedanta swami prabhupada";

select * from books_data
order by author;

--
ALTER TABLE books_data
rename column Book_name to Book_Title;

--
alter table books_data
modify record_date datetime;

--
select * from books_data
where Book_Title = "atomic habits";
 
 update books_data
 set record_date = "2020-06-30 12:59:25"
 where Book_Title = "atomic habits";
--
Delete from books_data
where sr_no = 0;
--
alter table books_data
add primary key (sr_no);
--
select * from books_data;
insert into books_data (Book_Title, author, language, type, product_real_price, product_disc_price, product_rating, product_raters, discount_offered_prcnt, on_promotion, record_date)
values
('abc', 'def', 'English', 'Paperback', '175', '97', '4.3', '7786', '44', 'yes', '2024-07-02 00:00:00');
select * from books_data;

--
update books_data
set author = upper(author);

select * from books_data;
--
update books_data
set author = trim(author);
--

select product_real_price as real_price
from books_data;

--
alter table books_data
drop column record_date;


















