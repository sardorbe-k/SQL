create database homework19
go 
use homework19

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);


--1
go
create proc usp_emp
as
	begin
		create table #employeebonus (employeeid int, fullname varchar(30), department varchar (30), salary decimal(10,2), bonusamount decimal (10,2))
		insert into #employeebonus (employeeid, fullname, department, salary, bonusamount)
		select e.EmployeeID,e.FirstName+''+e.LastName as fullname, d.Department, e.Salary, Salary * BonusPercentage/100 as bonusamount  from Employees as e
		join DepartmentBonus as d on e.Department=d.Department

		select e.EmployeeID,e.FirstName+''+e.LastName as fullname, d.Department, e.Salary, Salary * BonusPercentage/100 as bonusamount  from Employees as e
		join DepartmentBonus as d on e.Department=d.Department
	end

exec usp_emp


--2
go
alter proc usp_dep 
@department varchar(100),
@increasepercantegee decimal(5,2)
as 
begin
	update Employees
	set Salary= Salary*@increasepercantegee/100+Salary
	where Department=@department

	select * from Employees
	where Department=@department

end

exec usp_dep 'it', 20

--3
CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);


MERGE INTO products_current as Target
USING products_new As Source
ON Target.productid=source.productid

WHEN MATCHED AND Target.price<>Source.price then
UPDATE SET Target.price=SOURCE.price

when NOT MATCHED by Target then
INSERT (productid, productName, price) values 
(source.productid, source.productname,source.price)

WHEN NOT MATCHED by Source then
delete;

select * from [Products_Current]

--4
CREATE TABLE Tree (id INT, p_id INT);
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

select t.id, case
			when t.p_id is null  then 'robot'
			when t.p_id in (select p_id from Tree where p_id is not null) then 'inner'
			else 'leaf' end as type
from tree as t

--5
CREATE TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE  Confirmations (user_id INT, time_stamp DATETIME, action varchar (30) check  (action in ('confirmed','timeout')))

INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

INSERT INTO Confirmations (user_id, time_stamp, action ) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');


select s.user_id,
   round(coalesce(sum(case when c.action = 'confirmed' then 1 else 0 end) * 1.0 / nullif(count(c.action), 0), 0), 2)
   as confirmation_rate
from Signups s
left join Confirmations c
ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;


--6
CREATE TABLE employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees1 (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

select *from employees1
where salary=(select min(salary) from employees1)


--7


-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');
go
create proc usp_getproductsalesummery
@productid int
as 
begin
	select p.ProductName, sum(s.Quantity) as total_quantity_sold, 
		sum(s.Quantity*p.Price) as total_sales_amount, 
		min (SaleDate) as firtsaledate ,
		max(SaleDate) as lastsaledate from products as p
		left join  Sales as s on p.ProductID=s.ProductID
		where p.ProductID=@productid
		group by p.ProductName, p.Price
end

EXEC usp_getproductsalesummery 1;





