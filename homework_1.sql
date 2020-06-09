#Homework 1 by Xiaocen Shang


#Q1
select tb_rank.name, 
	d.dept_name, 
    tb_rank.salary
from (
	select *,
		dense_rank() over(partition by dept_sk order by salary desc) as salary_rank
	from employee) as tb_rank
left join department d on tb_rank.dept_sk = d.dept_sk
left join location l on tb_rank.location_sk = l.location_sk
where tb_rank = 1 and l.country = 'US';


#Q2
select tb_rank.name, 
	d.dept_name, 
    tb_rank.salary
from (
	select *,
		dense_rank() over(partition by dept_sk order by salary desc) as salary_rank
	from employee) as tb_rank
left join department d on tb_rank.dept_sk = d.dept_sk
left join location l on tb_rank.location_sk = l.location_sk
where tb_rank <= 5 and l.country = 'US';


#Q3
CREATE TABLE dept_BizOps AS (SELECT * FROM
    employee e
        LEFT JOIN
    level l ON e.level_sk = l.level_sk
        LEFT JOIN
    department d ON e.dept_sk = d.dept_sk
        LEFT JOIN
    location l ON e.location_sk = l.location_sk
WHERE
    d.dept_name = 'BizOps');
        


#Q4
SELECT 
    e1.emloyee_id,
    e1.name,
    e2.employee_id AS manager_id,
    e2.name AS manager_name
FROM
    employee e1
        LEFT JOIN
    employee e2 ON e1.manager_id = e2.employee_id;



#Q5
SELECT 
    QUARTER(start_date) AS start_quarter,
    COUNT(DISTINCT employee_id) AS employee_count
FROM
    employee
GROUP BY QUARTER(start_date)
ORDER BY QUARTER(start_date) ASC;


#6
SELECT 
    level_sk, level_name, AVG(tenure) AS average_tenure
FROM
    (SELECT 
        employee_id,
            e.level_sk,
            l.level_name,
            (CASE
                WHEN term_date IS NULL THEN DATEDIFF(day, start_date, GETDATE())
                ELSE DATEDIFF(day, start_date, term_date)
            END) AS tenure
    FROM
        employee e
    LEFT JOIN level l ON e.level_sk = l.level_sk) AS tb1
GROUP BY level_sk;

