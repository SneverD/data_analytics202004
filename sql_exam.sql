#sql_exam by Xiaocen Shang

use classicmodels;


# Problem 1
select 
	o.city,
    count(DISTINCT e.employeeNumber) as employee_count
from employees e 
left join offices o on e.officeCode = o.officeCode
group by o.city
order by employee_count desc
limit 3;



# Problem 2
select
	productLine,
    sum(quantityInStock * (MSRP - buyPrice))/sum(quantityInStock * MSRP) as profit_margin
from products 
group by productLine;



# Problem 3A
select 
	e.employeeNumber,
    e.lastName,
    e.firstName,
    sum(od.priceEach * od.quantityOrdered) as total_revenue
from customers c
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber
left join orders o on c.customerNumber = o.customerNumber
left join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber
order by total_revenue desc
limit 3;



# Problem 3B
# update the employees table


# Problem 3C
delimiter $$
create procedure manage_employee(in emp_no INT)
begin
	delete from employees
    where employeeNumber = emp_no;
    
    # classicmodels database "order" table does not contain employee number
end $$
delimiter ;




# Problem 4
create table salary_change as (
select 
	e.employee_id,
    e.employee_name,
    count(DISTINCT salary) as salary_change_count
from Employees e
left join Employee_salary es on e.employee_id = es.employee_id
left join Department d on e.department_id = d.department_id
where d.department_id = 'certain department'
);
	


# Problem 5
select
	tb_rank.employee_name,
    d.department_name
from (
	select * ,
		rank() over(partition by department_id order by current_salary desc)
    from Employee 
    where term_date is not null) as tb_rank
left join Department d on tb_rank.department_id = d.department_id
where tb_rank<=3;




