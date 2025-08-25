create database homework21
go
use homework21


CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);
INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);



--1 Write a query to assign a row number to each sale based on the SaleDate.

select *,
row_number() over ( order by saledate) as rw
from ProductSales

--2 Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.
select productname,
sum(quantity) as total_quantity,
dense_rank() over (order by sum(quantity) desc) as dn 
from ProductSales
group by ProductName

--3 Write a query to identify the top sale for each customer based on the SaleAmount.
with cte as (
select *,
dense_rank() over (partition by customerid order by saleamount desc) as dn
from ProductSales
)
select * from cte where dn=1

--4 Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.
select *,
lead(SaleAmount) over (order by saledate) as nextamount
from ProductSales

--5 Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select *,
lag(SaleAmount) over (order by saledate) as olderamount
from ProductSales

--6 Write a query to identify sales amounts that are greater than the previous sale's amount
;with rt as (
select *,
	 lag(SaleAmount) over (order by saledate ) as lg
from ProductSales
)
select * from rt
where SaleAmount > lg

--7 Write a query to calculate the difference in sale amount from the previous sale for every product
select *,
		 lag(SaleAmount) over (partition by ProductName order by SaleDate) as PreviousSale,
         isnull(saleamount-lag(SaleAmount) over (partition by ProductName order by saledate), 0) as diffamount
from ProductSales

--8 Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select *,
lead(SaleAmount) over (order by saledate),
cast((lead(SaleAmount) over (order by saledate)-SaleAmount) * 100/SaleAmount as decimal(10,2) ) as percentagesale
from ProductSales

--9 Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select *,
lag(SaleAmount) over (partition by productname order by saledate) as lg,
cast( SaleAmount * 1.0 / isnull(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate), 0) as decimal(10,2) ) as ratio
from ProductSales

--10 Write a query to calculate the difference in sale amount from the very first sale of that product.
select *,
first_value(SaleAmount) over (partition by productname order by saledate) as firstamount,
saleamount - first_value(SaleAmount) over (partition by productname order by saledate) as diff

from ProductSales

--11 Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
;with tabe as (
select *,
lag (SaleAmount) over (partition by productname order by saledate)as lg
from ProductSales
)
select * from tabe
where SaleAmount> lg

--12 Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.
select *,
sum(SaleAmount) over (partition by productname order by saledate
rows between unbounded preceding and current row) as closingbalance
from ProductSales
order by ProductName, SaleDate

--13 Write a query to calculate the moving average of sales amounts over the last 3 sales.
select *,
avg(SaleAmount) over (partition by productname order by saledate
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_average
from ProductSales

--14 Write a query to show the difference between each sale amount and the average sale amount.
select *,
avg(SaleAmount) over () as avgg,
SaleAmount-avg(SaleAmount) over () as diff
from ProductSales

CREATE TABLE Employees1 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');

--15 Find Employees Who Have the Same Salary Rank
;with cte as (
select *,
rank() over (order by salary) as rnk
from Employees1
)
select * from cte 
where rnk in(select rnk from cte 
group by rnk
having COUNT(*)>1)

--16 Identify the Top 2 Highest Salaries in Each Department
;with highest as (
select *,
row_number () over (partition by department order by salary desc) as rw
from Employees1
)
select * from highest
where rw<=2

--17 Find the Lowest-Paid Employee in Each Department
;with lower as(
select *,
ROW_NUMBER() over (partition by department order by salary ) as rw
from Employees1
)
select * from lower
where rw=2

--18 Calculate the Running Total of Salaries in Each Department
select *,
sum(Salary) over (partition by department order by hiredate 
rows between unbounded preceding and current row) as running
from Employees1

--19 Find the Total Salary of Each Department Without GROUP BY
select *,
sum(Salary) over (partition by department ) as totalsalary
from Employees1

--20 Calculate the Average Salary in Each Department Without GROUP BY
select *,
avg(salary) over (partition by department) as average
from Employees1

--21 Find the Difference Between an Employee’s Salary and Their Department’s Average
select *,
salary-avg(Salary) over (partition by department) as dep_avg
from Employees1

--22 Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select *,
avg(Salary) over (partition by department order by hiredate 
ROWS BETWEEN 1 PRECEDING AND 1 following) as moving_avg
from Employees1

--23 Find the Sum of Salaries for the Last 3 Hired Employees
select sum(Salary) as last_3_sum from
( select top 3 Salary
  from Employees1
  order by hiredate desc
) AS last3;







