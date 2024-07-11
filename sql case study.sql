CREATE database dannys_diner;
--
use dannys_diner;
--
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);
--
INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
--
CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);
--
INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
--
CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);
--
INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  --
  -- 1. What is the total amount each customer spent at the restaurant?

select sales.customer_id,
sum(menu.price) as Total_sum_spend
from dannys_diner.sales
join dannys_diner.menu
      on sales.product_id = menu.product_id
group by customer_id
order by customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as days_visited
from dannys_diner.sales
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT
    sales.customer_id,
    menu.product_name,
    sales.order_date
FROM
    sales
JOIN
    menu
ON
    sales.product_id = menu.product_id
WHERE
    sales.order_date = (
        SELECT
            MIN(order_date)
        FROM
            sales AS s
        WHERE
            s.customer_id = sales.customer_id
    )
ORDER BY
    sales.customer_id, sales.order_date;
--
WITH cte_order AS(
SELECT 
  sales.customer_id,
  menu.product_name,
  
  ROW_NUMBER() OVER(
    PARTITION BY sales.customer_id
    ORDER BY sales.order_date,
    sales.product_id
    
    ) AS item_order 
FROM dannys_diner.sales 
  JOIN dannys_diner.menu
  
  ON sales.product_id = menu.product_id

)

SELECT * FROM cte_order
WHERE item_order=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    m.product_name, 
    COUNT(s.product_id) AS purchase_count
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
GROUP BY 
    s.product_id, m.product_name
ORDER BY 
    purchase_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH cte_order_count AS(
SELECT sales.customer_id,
  menu.Product_name,
  COUNT(*) AS order_count
  FROM dannys_diner.sales
  JOIN dannys_diner.menu
  
  ON sales.product_id = menu.product_id
  
  GROUP BY 
  customer_id,
  product_name

  ORDER BY 
  customer_id,
  order_count DESC
  
  ),
  cte_popular_rank AS(
SELECT *, RANK() OVER (PARTITION BY customer_id Order BY order_count DESC)
  AS ranks
  FROM cte_order_count
)

SELECT * FROM cte_popular_rank
WHERE ranks=1;


-- 6. Which item was purchased first by the customer after they became a member?
SELECT 
    s.customer_id, 
    s.order_date, 
    m.product_name
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
JOIN 
    members mb ON s.customer_id = mb.customer_id
WHERE 
    s.order_date >= mb.join_date
    AND s.order_date = (
        SELECT 
            MIN(s2.order_date)
        FROM 
            sales s2
        WHERE 
            s2.customer_id = s.customer_id
            AND s2.order_date >= mb.join_date
    )
ORDER BY 
    s.customer_id, s.order_date;

--

-- 7. Which item was purchased just before the customer became a member?
SELECT 
	s.customer_id,
    m.product_name,
        min(s.order_date) as first_order_date
FROM sales s
inner join	dannys_diner.menu m
ON s.product_id = m.product_id
inner join dannys_diner.members mbr
on mbr.customer_id = s.customer_id
where	mbr.customer_id in ('A','B')
and s.order_date < mbr.join_date
group by s.customer_id,m.product_name
order by s.customer_id,min(s.order_date) asc


-- 8. What is the total items and amount spent for each member before they became a member?
--
SELECT 
    s.customer_id,
    COUNT(s.product_id) AS total_items,
    SUM(m.price) AS total_amount_spent
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
JOIN 
    members mb ON s.customer_id = mb.customer_id
WHERE 
    s.order_date < mb.join_date
GROUP BY 
    s.customer_id
ORDER BY 
    s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM
    sales s
JOIN
    menu m ON s.product_id = m.product_id
GROUP BY
    s.customer_id
ORDER BY
    s.customer_id;



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  
  SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY) THEN m.price * 20
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM
    sales s
JOIN
    menu m ON s.product_id = m.product_id
JOIN
    members mb ON s.customer_id = mb.customer_id
WHERE
    s.customer_id IN ('A', 'B')
    AND s.order_date <= '2021-01-31'
GROUP BY
    s.customer_id
ORDER BY
    s.customer_id;

  
  
  
  