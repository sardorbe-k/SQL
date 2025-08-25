CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

--1. Find customers who purchased at least one item in March 2024 using EXISTS
select distinct s.CustomerName from #Sales as s
where  exists (select 1 from #Sales  s2 where s.CustomerName=s2.CustomerName and SaleDate between '2024-03-01' and '2024-03-31',
)

--2. Find the product with the highest total sales revenue using a subquery.
with ProductTotals as (
    select Product, SUM(Quantity * Price) as TotalRevenue
    from #Sales
    group by Product
)
select Product, TotalRevenue
from ProductTotals
where TotalRevenue = (
    select MAX(TotalRevenue) 
    from ProductTotals
)

--3. Find the second highest sale amount using a subquery
select top 1 PRODUCT, max(Price*Quantity) as amount from #Sales
where Price*Quantity<(select MAX(price * Quantity) from #Sales )
group by Product
order by amount desc

--4. Find the total quantity of products sold per month using a subquery
select  YearMonth, TotalQuantity from (
select  concat(year(SaleDate), '-', RIGHT('0' + cast(month(SaleDate) as varchar), 2)) as YearMonth,
    sum(Quantity) as TotalQuantity
    from #Sales
    group by year(SaleDate), month(SaleDate)
) as MonthlySales
order by YearMonth;

--5  Find customers who bought same products as another customer using EXISTS
select distinct s1.CustomerName, s1.product from #Sales as s1
where exists (select 1 from #Sales as s2 where  s1.Product=s2.Product and s1.CustomerName<>s2.CustomerName)

--6 Return how many fruits does each person have in individual fruit level
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')
select name,
	sum(case when Fruit='apple' then 1 else 0 end) as Apple,
	sum(case when Fruit='Banana' then 1 else 0 end) as Banana,
	sum(case when Fruit='Orange' then 1 else 0 end) as Orange
from Fruits
group by name
order by name 

--7 Return older people in the family with younger ones
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

with FamilyTree as (
    select ParentId, ChildID
    from Family
    union all
    select ft.ParentId, f.ChildID
    from FamilyTree ft
    join Family f
    on ft.ChildID = f.ParentId
)
select ParentId as PID, ChildID as CHID
from FamilyTree
order by PID, CHID;


--8 Write an SQL statement given the following requirements. For every customer that had a delivery to California,
--provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

select o1.customerid, o1.orderid, o1.deliverystate, o1.amount from #Orders as o1
where o1.DeliveryState ='tx' and exists
(select 1 from #Orders as o2
where o1.CustomerID=o2.CustomerID and o2.DeliveryState='ca')

--9 Insert the names of residents if they are missing
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

Select *, 
case when charindex('name=',address) = 0 then
stuff(address, charindex('age=', address), 0, concat('name=',fullname,' '))
else address end as updated_address

from #residents


--10  Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select * from #Routes
;WITH RoutePaths AS
(
    SELECT 
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        rp.DepartureCity,
        r.ArrivalCity,
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        rp.Cost + r.Cost
    FROM RoutePaths rp
    JOIN #Routes r
        ON rp.ArrivalCity = r.DepartureCity
)
, FinalRoutes AS
(
    SELECT Route, Cost
    FROM RoutePaths
    WHERE ArrivalCity = 'Khorezm'
)
SELECT Route, Cost
FROM FinalRoutes
WHERE Cost = (SELECT MIN(Cost) FROM FinalRoutes)

UNION ALL

SELECT Route, Cost
FROM FinalRoutes
WHERE Cost = (SELECT MAX(Cost) FROM FinalRoutes);

-- 11 Rank products based on their order of insertion.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')


select t.ID, t.Vals,
	  (select COUNT(*) from #RankingPuzzle as x where x.ID<=t.id and x.Vals='product' )as produckrank
	  from #RankingPuzzle as t

--12 Find employees whose sales were higher than the average sales in their department
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);


select e.EmployeeName, e.Department,  e.SalesAmount from #EmployeeSales as e
where SalesAmount>(select avg(SalesAmount) from #EmployeeSales as e1 where e.Department=e1.Department)

select * from #EmployeeSales

-- 13 Find employees who had the highest sales in any given month using EXISTS
SELECT e.EmployeeName, e.Department, e.SalesAmount, e.SalesMonth, e.SalesYear
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales x
    WHERE x.SalesMonth = e.SalesMonth
      AND x.SalesYear  = e.SalesYear
    GROUP BY x.SalesMonth, x.SalesYear
    HAVING e.SalesAmount = MAX(x.SalesAmount)
);


--14 Find employees who made sales in every month using NOT EXISTS
SELECT e.EmployeeID, e.EmployeeName, e.Department
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT DISTINCT s.SalesMonth, s.SalesYear
    FROM #EmployeeSales s
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales x
        WHERE x.EmployeeID = e.EmployeeID
          AND x.SalesMonth = s.SalesMonth
          AND x.SalesYear = s.SalesYear
    )
)
GROUP BY e.EmployeeID, e.EmployeeName, e.Department;

--15  Retrieve the names of products that are more expensive than the average price of all products.
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

select Name, Price from Products
where Price> (select avg(Price)from Products)

--16 Find the products that have a stock count lower than the highest stock count.
SELECT ProductID, Name, Category, Price, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock) 
    FROM Products
);

--17  Get the names of products that belong to the same category as 'Laptop'.
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category 
    FROM Products 
    WHERE Name = 'Laptop'
);


--18 Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT ProductID, Name, Category, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

--19 Find the products that have a higher price than the average price of their respective category.

SELECT ProductID, Name, Category, Price
FROM Products p
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);


--20 Find the products that have been ordered at least once.

SELECT DISTINCT p.ProductID, p.Name, p.Category, p.Price, p.Stock
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

--21  Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity) 
    FROM Orders
);

--22  Find the products that have never been ordered.
SELECT p.Name
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL

--23. Retrieve the product with the highest total quantity ordered.

SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalOrdered DESC;












CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');





