/*with data_science_data as (

	select * from univeristy
    where department = "Data Science"

)
select grade, count(*) from data_science_data group by grade;
*/
--
-- Exercise: Idenitfy top three job roles among PHD holders.
with PHD_Holders as (
	select * from employee_dataset
    where Education = "PHD"
)
select JobRole,count(*) as Number_of_employees from PHD_holders
group by JobRole
order by Number_of_employees desc
limit 3;

--
select * from employee_dataset;

-- Exercise: Identify the average monthly income by job role for employees who have left the company.
with Previous_employees as
(
select * from employee_dataset
where Attrition = "yes" 
)
select jobrole, avg(MonthlyIncome) as AverageMonthlyIncome 
from Previous_employees
group by jobrole;

-- Exercise: Identify the percentage of employees who work overtime in each department.

with OverTimeCounts as
(
select 
	Department, count(*) as OverTimeCount
    from employee_dataset
    where OverTime ="Yes"
    Group by Department
),
TotalCounts as
(
select 
	Department, count(*) as TotalCount
    from employee_dataset
    Group by Department
)
select o.Department, o.OverTimeCount, t.TotalCount, 
(o.OverTimeCount / t.TotalCount) * 100 as OverTimePercentage
from OverTimeCounts o
Join TotalCounts t
on o.Department = t.Department;
-- task
-- 1. What are the top 3 jobRoles with highest average JobSatisfaction for employees who travel frequently.
-- (hint: check who travels frequently and then find out top three on the basis of average job satisfaction.)
WITH TravelsFrequently AS (
	SELECT *
	FROM Employee_dataset
	WHERE BusinessTravel = "Travel_Frequently"
)

SELECT JobRole, AVG(JobSatisfaction) AS "Average Job Satisfaction"
FROM TravelsFrequently
GROUP BY JobRole
ORDER BY AVG(JobSatisfaction) DESC
LIMIT 3;

--
-- window functions
select * from customer;
select customer_id,first_name,last_name,gender, count(*) 
from customer
group by customer_id,first_name,last_name,gender;

-- using window function
select customer_id,first_name,last_name,gender, 
count(*) over (partition by gender) as Gender_count
from customer;

-- Exercise: Find average salary of employees for each department and order employees within a department by age. 
select Employee_ID, Age,Department, MonthlyIncome, 
avg(MonthlyIncome) over ( partition by department order by age)
as AVg_Salary
from employee_dataset;

--
-- Exercise:  Find the average performance rating within each department.
select employee_ID,Age,Department,Education,
avg(PerformanceRating) over (partition by Department) 
from employee_dataset;

-- Exercise: What is the running total of sales (RunningTotal_Sales) 
-- for each product (product_id) ordered by the purchase date.
select * ,
sum(total_amount) over ( partition by product_id order by purchase_date) as RunningTotalSales
from purchase_history;


-- Exercise: Rank products by their price_per unit in each brand (Exepensive -> less)
select  * ,
RANK() over (partition by brand order by price_per_unit desc )as Price_rank,
DENSE_RANK() over (partition by brand  order by price_per_unit desc)as Price_Dense_rank
from products;


-- Exercise: In each department, who are the employees with the highest salaries, and how do they rank compared to others in their department?
select 
row_number() over ( partition by department order by MonthlyIncome desc) as row_number_column,
employee_id, department, MonthlyIncome,
rank() over ( partition by department order by MonthlyIncome desc) as rank_MonthlyIncome,
DENSE_rank() over ( partition by department order by MonthlyIncome desc) as Dense_rank_MonthlyIncome
from employee_dataset;

-- Exercise: Interval Between Purchases in terms of days
select * from purchase_history;
select customer_ID, purchase_date,
lead(purchase_date) over ( partition by customer_id order by purchase_date) as next_date,
datediff(lead(purchase_date) over ( partition by customer_id order by purchase_date), purchase_date) asdays_since_last_purchase
from purchase_history;

-- Exercise: calculate the monthly increase or decrease in quantity sold from the purchase_history table.

with monthlySales as
( select 
Year(purchase_date) as sales_year, Month(purchase_date), 
sum(quantity) as total_quantity_sold, 
lag( sum(quantity), 1) over (order by Year(purchase_date), Month(purchase_date) )  as previous_month_quantity
from purchase_history
group by Year(purchase_date), Month(purchase_date) 

)
select  *,
case 
when total_quantity_sold > previous_month_quantity Then "Increase"
when total_quantity_sold < previous_month_quantity Then "Decrease"
Else NULL
END as quantity_change
from monthlySales;
-- Union
-- Combine all members whether they are Students or Event organizers
select student_name, student_department
from students_data
union
select organizer_name, organizer_department
from event_organizers;

-- Intersect
-- Find the common participants between the Students_Data and Event_organizers tables based on their names.
select student_name, student_department
from students_data
intersect
select organizer_name, organizer_department
from event_organizers;
-- Except 
-- Create a query that identifies students from the Students_Data table who are not organizers in the Event_organizers table.

select student_name, student_department
from students_data
Except
select organizer_name, organizer_department
from event_organizers;


















