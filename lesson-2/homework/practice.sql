create database homework2
use homework2
create table employees (Empid int,name varchar(50),salary decimal(10,2))

select * from employees

insert into employees values (1,'Amirbek',12.34),(2, 'Asadbek', 13.98),(3,'Bexruz', 23.356),(4,'Bekali', 45.78),(5, 'Sanjar', 234.45)

update employees 
set salary=7000
where Empid=1

delete employees
where empid =2

--  DELETE
/* Jadvaldagi aniq qatorlarni o‘chirish uchun ishlatiladi (WHERE bilan).
Bekor qilish (rollback) mumkin.
Jadval tuzilmasi va IDENTITY (avto raqamlanish) saqlanadi.

  TRUNCATE
Jadvaldagi barcha qatorlarni tozalaydi, lekin har bir o‘chirish loglanmaydi.
WHERE ishlatib bo‘lmaydi.
Odatda bekor qilib bo‘lmaydi.
IDENTITY (raqam) qayta boshlanadi (1 dan).

  DROP
Jadvalning o‘zini butunlay o‘chiradi (strukturasi va ma’lumotlari bilan birga).
Jadval, uning ustunlari, cheklovlari – barchasi yo‘q qilinadi.
Bekor qilib bo‘lmaydi.
*/

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

select * from employees

alter table Employees
add department varchar (50)

exec sp_rename 'employees.salary', 'float', 'column'

exec sp_rename 'employees.float', 'salary', 'column'

create table Departments (departmentid int primary key, departmentname varchar (50))

--truncate table employees
DELETE FROM Employees;

insert into Departments values (1, 'Bekzod'),(2,'Asiljan'),(3,'Samir'),(4,'Nozima'),(5,'Malika')
select * from departments


UPDATE Employees
SET  department = 'Management'
WHERE salary> 500;

select * from employees

delete from employees

ALTER TABLE Employees
DROP column  Department;

EXEC sp_rename 'Employees', 'StaffMembers' 

DROP TABLE Departments;

create table products (productid int primary key,productname varchar(50),category varchar (50), price decimal (10,2))

alter table products
add check (price>0)

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

select * from products

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price)
VALUES 
(3, 'Headphones', 'Accessories', 150.00),
(4, 'Mouse', 'Accessories', 30.00),
(5, 'Monitor', 'Electronics', 300.00);

SELECT *
INTO Products_Backup
FROM Products;

exec sp_rename 'products', 'inventory'
select * from inventory

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;




CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000,5) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    Description VARCHAR(255),
    StockQuantity INT
);

INSERT INTO Inventory_New (ProductID, ProductName, ProductCategory, Price,  StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, StockQuantity
FROM Inventory;

select * from Inventory_New

ALTER TABLE inventory_new
DROP COLUMN description;

DROP TABLE Inventory;

EXEC sp_rename 'Inventory_New', 'Inventory';

select * from inventory
