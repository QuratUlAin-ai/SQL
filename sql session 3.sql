use users_record;
--
select * from university_students_dataset;
--

alter table university_students_dataset
modify column EnrollmentDate date;
--
select count(StudentID) as "Total number of students" from university_students_dataset;
--
select round(avg(age)) as "Average Age" from university_students_dataset;
--
select max(gpa) as "Highest GPA",min(gpa) as "Lowest GPA" from university_students_dataset;
--
select * from university_students_dataset;
select distinct major from university_students_dataset;

select count(distinct major) as Total_Majors from university_students_dataset;
--
select max(gpa) from university_students_dataset
where major = "mathematics";
--
select * from university_students_dataset
where major = "computer science"
order by gpa asc
limit 1;

--


select distinct major from university_students_dataset;
select * from university_students_dataset;

--
select count(distinct major) from university_students_dataset;

select major, count(*) from university_students_dataset
group by major;
--

select gender, count(*)
from university_students_dataset
group by gender;

--
select age, count(*) as Total_Students
from university_students_dataset
group by age
order by  Total_Students desc
limit 1;
--

select major, avg(age), avg(gpa)
from university_students_dataset
group by major;
--
select year(EnrollmentDate) from university_students_dataset;
select year(EnrollmentDate), count(*)
from university_students_dataset
group by year(EnrollmentDate);

--
select * from university_students_dataset
where gender = "Female" and EnrollmentDate > 2018-12-31;

select major, count(*)
from university_students_dataset
where gender = "Female" and EnrollmentDate > 2018-12-31
group by major
order by count(*)
limit 1;
--
select major, avg(gpa) as Average_GPA
from university_students_dataset
group by major
having avg(gpa) > 3.0;


--
select major, count(*), avg(gpa) as Average_GPA
from university_students_dataset
group by Major
having count(*) > 100;

--
select major, avg(gpa) as Average_GPA
from university_students_dataset
where age >= 25
group by major
order by Average_GPA desc
limit 3;
--

select * ,
 IF(GPA >= 3.5,
        'A+',
        IF(gpa >= 3,
            'A',
            IF(gpa >= 2.5,
                'B',
                IF(gpa >= 2, 'C', 'F')))) AS grades
from university_students_dataset;


--
SELECT 
    sum(IF(age > 25, 1, 0)) AS older_than_25,
    sum(IF(age <= 25, 1, 0)) AS younger_or_equal_than_25
FROM
    university_students_dataset;

--
SELECT 
    *,
    CASE
        WHEN gpa > 3.5 THEN 'A+'
        WHEN gpa > 3 THEN 'A'
        WHEN gpa > 2.5 THEN 'B'
        WHEN gpa > 2 THEN 'C'
        ELSE 'F'
    END AS 'Grades'
FROM
    university_students_dataset;
--
select * , 
case
 when gender="Male" and Age >=21 Then 'Adult Male' 
  when gender="Male" and Age <21 Then 'Young Male' 
 when gender="Female" and Age >=21 Then 'Adult Female'
 when gender="Female" and Age <21 Then 'Young Female'
 end as "Age_gender_Group"
 from university_students_dataset;
--
SELECT 
    major,
    COUNT(CASE
        WHEN gpa >= 3.5 THEN 1
    END) AS high,
COUNT(CASE
        WHEN gpa between 2.5 and 3.49 THEN 1
    END) AS Medium,
    COUNT(CASE
        WHEN gpa < 2.5 THEN 1
    END) AS Low
from university_students_dataset
group by major;

--

alter table university_students_dataset
add column student_category varchar(10);
--

























