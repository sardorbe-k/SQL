CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');



--1
create table #mothly_sales (productid int, total_quantity int, total_revenue decimal (10,2))
insert into #mothly_sales (ProductID, total_quantity,total_revenue )
select Products.ProductID,
sum(Sales.Quantity) as total_quantity, 
sum(Products.Price * Sales.Quantity) as total_revenue from products
join Sales
on Products.ProductID=Sales.ProductID
where sales.SaleDate >='2025-04-01' and Sales.SaleDate < '2025-05-01'
group by Products.ProductID

select * from #mothly_sales

--2
create view vw_ProductSalesSummary as(
select p.ProductID, p.ProductName, p.Category, sum(s.Quantity) as totalquantitysold from products as p
join Sales as s 
on p.ProductID=s.ProductID
group by p.ProductID, p.ProductName, p.Category
)

select * from vw_ProductSalesSummary

--3
create function fn_GetTotalRevenueForProduct (@productid int)
returns decimal(10,2)
as
begin
	return (select sum (quantity * price) as totalRevenue from Products as p
      join Sales as s on s.ProductID = p.ProductID
      where p.ProductID = @ProductID)
end

select dbo.fn_GetTotalRevenueForProduct (1) as revenue


--4
go
drop function fn_salesbycategory
create function _salesbycategory (@category varchar(50))
returns table
as 
return (select p.productname, sum(s.Quantity) as total_quantity, sum(Quantity * Price) as total_revenue from Products as p
			join Sales as s on s.ProductID=p.ProductID
			where p.Category=@category
			group by p.ProductName)
go
select * from dbo.fn_salesbycategory ('electronics') 


--5
create function fn_isprime (@number int)
returns varchar (10)
as 
begin
	declare @result varchar(10)
		if @number<=1
			set @result='no'
		else
		begin
			declare @i int =2
			if @i=2
			set @result='yes'

			while @i<=@number / 2
			begin
				if @number % @i =0
				begin
				set @result='no'
				break
				end
				set  @i=@i+1
			end
		end
		return @result
end

select dbo.fn_isprime (3)
select dbo.fn_isprime (6)

--6
create function fn_GetNumbersBetween (@start int, @end int)
returns @number table (number int)
as 
begin
	declare @i int=@start
	while @i<= @end
	begin 
		insert into @number (number) values (@i)
		set @i=@i+1
	end
	return
end

select * from dbo.fn_GetNumbersBetween (1,5)

--7
create function getNthHighestSalary (@n int)
returns table 
as 
return
(
	select cast ((select distinct salary from employee
	order by salary desc 
	offset (@n-1) rows 
	fetch next 1 rows only )
	as int) as hihgtsalar)

select * from dbo.getNthHighestSalary (1)

--8
SELECT TOP 1 id, COUNT(*) AS num
FROM (
    -- requester_id ni do‘st deb hisoblaymiz
    SELECT requester_id AS id, accepter_id AS friend
    FROM RequestAccepted
    UNION ALL
    -- accepter_id ni ham do‘st deb hisoblaymiz
    SELECT accepter_id AS id, requester_id AS friend
    FROM RequestAccepted
) AS all_friends
GROUP BY id
ORDER BY COUNT(*) DESC;

--9
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
); 

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);


create view description as
(
select  c.customer_id, c.name, count(o.order_id) as total_orders, coalesce(sum(o.amount),0) as total_amount, max(o.order_date) as last_order_date from Customers	as c
left join Orders as o on c.customer_id=o.customer_id
group by c.customer_id, c.name 
)

select * from description


--10
SELECT 
    RowNumber,
    Workflow = MAX(TestCase) 
                  OVER (ORDER BY RowNumber 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM Gaps;



