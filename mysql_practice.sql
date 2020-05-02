use classicmodels;

#single entity

#1
select * 
from offices
order by country, state, city;

#2
select count(employeeNumber) as 'total_employees'
from employees;

#3
select sum(amount) as 'total_payment'
from payments;

#4
select productLine
from productlines
where productLine like('%Cars%');

#5
select sum(amount) as 'payments_20041028'
from payments
where paymentDate = '2004-10-28';

#6
select * 
from payments
where amount > 100000;

#7
select productLine, productName
from products
order by productLine asc;

#8
select productLine, count(productCode) as 'product_count'
from products
group by productLine;

#9
select min(amount) as 'min_payment'
from payments;

#10
select *
from payments
having amount > (select 2*avg(amount) from payments);

#11
select avg((MSRP - buyPrice) /buyPrice) * 100 as avg_percentage_markup
from products;

#12
select count(distinct productName) as num_product
from products;

#13
select customerName, city
from customers
where salesRepEmployeeNumber is null;

#14
select concat(firstName, ' ', lastName) as executive_name, jobTitle
from employees
where jobTitle like ('%VP%') or jobTitle like('%Manager%');

#15
select * 
from orderdetails
group by orderNumber
HAVING sum(priceEach * quantityOrdered) > 5000;



#one to many relationship

#1
select customerName, concat(e.firstName, ' ',e.lastName) as rep_name
from customers c 
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber;

#2
select c.customerName, sum(p.amount) as total_payment
from customers c
join payments p on c.customerNumber = p.customerNumber
where c.customerName = 'Atelier graphique';

#3
select paymentDate, sum(amount) as total_payment
from payments
group by paymentDate
order by paymentDate asc;

#4
select *
from products
where quantityInStock > 0;

#5
select c.customerName, sum(p.amount) as amount_paid
from payments p
join customers c on p.customerNumber = c.customerNumber
group by p.customerNumber;

#6
select c.customerName, count(o.orderNumber) as order_count
from orders o 
join customers c on o.customerNumber = c.customerNumber
where c.customerName = 'Herkku Gifts';

#7
select concat(e.firstName, ' ', e.lastName) as emp_name, o.city as work_city
from employees e
join offices o on e.officeCode = o.officeCode
where o.city = 'Boston';

#8
select p.amount, c.customerName
from payments p
join customers c on p.customerNumber = c.customerNumber
where p.amount > 100000
order by p.amount desc;

#9
select o.orderNumber, sum(od.quantityOrdered * od.priceEach) as order_value, o.status
from orders o
join orderdetails od on o.orderNumber = od.orderNumber
where o.status = 'On Hold'
group by od.orderNumber;

#10
select c.customerName, count(o.orderNumber) as onhold_orders
from orders o 
join customers c on o.customerNumber = c.customerNumber
where o.status = 'On Hold'
group by o.customerNumber;


# Many to many relationship

#1
select p.productName, o.orderDate
from orders o
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
order by o.orderDate asc;

#2
select p.productName, o.orderDate
from orders o
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
where p.productName = '1940 Ford Pickup Truck'
order by o.orderDate desc;

#3
select c.customerName, o.orderNumber, sum(priceEach*quantityOrdered) as order_amount
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by od.orderNumber
having sum(priceEach*quantityOrdered) > 25000;

#4
select od.productCode, p.productName
from orderdetails od 
join orders o on od.orderNumber = o.orderNumber
join products p on od.productCode = p.productCode
group by od.productCode
having count(od.orderNumber) = (select count(distinct orderNumber) from orderdetails);

#5
select p.productName, (priceEach/MSRP)*100 as price_percentage_MSRP
from products p 
join orderdetails od on p.productCode = od.productCode
WHERE (priceEach/MSRP) < 0.8;

#6
select p.productCode, p.productName, od.orderNumber, 100*(od.priceEach - p.buyPrice)/p.buyPrice as mark_up_percentage
from products p 
join orderdetails od on p.productCode = od.productCode
where od.priceEach > 2 * p.buyPrice;

#7
select p.productCode, p.productName, o.orderDate
from orders o
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
where weekday(o.orderDate) = 0;

#8
select p.productCode, p.productName, p.quantityInStock
from orders o 
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
where o.status = 'On Hold';



# regular expression

#1
select *
from products
where  productName like ('%Ford%');

#2
select *
from products
where productName like ('%ship');

#3
select country, COUNT(customerNumber) as customer_count
from customers
where country in ('Denmark','Norway','Sweden')
group by country;

#4
SELECT productCode, productName
from products
where productCode between 'S700_1000' and 's700_1499';

#5
select customerName
from customers
where customerName REGEXP '[0-9]';

#6
select firstName,lastName
from employees
where firstName in ('Dianne','Diane') or lastName in ('Dianne','Diane');

#7
select productName
from products
where productName like '%ship%' or productName like '%boat%';

#8
select productCode
from products
where productCode like 'S700%';

#9
select firstName, lastName
from employees
where firstName in ('Larry','Barry') or lastName in ('Larry','Barry');

#10
select firstName,lastName
from employees
where not (firstName regexp '[a-z]') or not (lastName regexp '[a-z]');

#11
select distinct productVendor
from products
where productVendor like '%Diecast';






#General queries
#1
select employeeNumber, firstName, lastName
from employees
where reportsTo is null;

#2
select employeeNumber,firstName,lastName
from employees
where reportsTo = (select employeeNumber from employees where firstName = 'William' and lastName = 'Patterson');

#3
select DISTINCT p.productName
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
where c.customerName = 'Herkku Gifts';

#4
select e.firstName, e.lastName, sum(od.priceEach * od.quantityOrdered)*0.05 as comission
from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber
order by e.lastName, e.firstName;

#5
select datediff(max(orderDate), min(orderDate)) as days_diff
from orders;

#6
select c.customerName, avg(shippedDate - orderDate) as average_diff
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by c.customerNumber
order by avg(datediff(shippedDate,orderDate)) desc;

#7
select o.orderNumber, sum(od.priceEach * od.orderLineNumber) as order_value
from orders o 
join orderdetails od on o.orderNumber = od.orderNumber
where month(shippedDate) = 8 and year(shippedDate) =2004
group by o.orderNumber;

#8
select sum(od.quantityOrdered * od.priceEach) as value_ordered, sum(p.amount) as payment, sum(od.quantityOrdered * od.priceEach)-sum(p.amount) as diff_order_payment
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
join payments p on c.customerNumber = p.customerNumber
where year(o.orderDate) = 2004 and year(p.paymentDate) = 2004
group by c.customerNumber;

#9
select concat(e1.firstName, ' ', e1.lastName) as employee_name
from employees e1
join employees e2 on e1.reportsTo = e2.employeeNumber
join employees e3 on e2.reportsTo = e3.employeeNumber
where e3.firstName = 'Diane' and e3.lastName = 'Murphy';

#10
select productCode, productName, 100 * sum(quantityInStock * MSRP)/(SELECT sum(quantityInStock*MSRP) from products) as value_percentage
from products
group by productCode
order by sum(quantityInStock * MSRP) desc;

#11
delimiter $$
create function mpg_convert(v_mpg double) returns double
deterministic no sql reads sql data
begin
declare v_lpk double;
return 2.35215 * v_mpg;
end $$
delimiter ;

#12
delimiter $$
create procedure increase_price(in increase_percentage double, in category varchar(255))
begin
update products
set MSRP = (increase_percentage + 1)  * MSRP
where productLine = category;
end $$
delimiter ;


#13
select o.orderNumber, sum(od.priceEach * od.orderLineNumber) as order_value
from orders o 
join orderdetails od on o.orderNumber = od.orderNumber
where month(shippedDate) = 8 and year(shippedDate) =2004
group by o.orderNumber;

















