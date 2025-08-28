create database homework22
 
use homework22


CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--1 Compute Running Total Sales per Customer
select *,
sum(total_amount) over (partition by customer_id order by order_date) as runningtotal
from sales_data

--2 Count the Number of Orders per Product Category
select *,
count(quantity_sold) over (partition by product_category) as cnt_order
from sales_data

--3 Find the Maximum Total Amount per Product Category
select *,
max(total_amount) over (partition by product_category) as max_total
from sales_data

--4 Find the Minimum Price of Products per Product Category
select *,
min(unit_price) over (partition by product_category) as min_total
from sales_data

--5 Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
select *,
cast (avg(total_amount) over (order by order_date rows between 1 preceding and 1 following ) as decimal(10,2)) as movingavage_threedays
from sales_data

--6 Find the Total Sales per Region
select *,
sum(total_amount) over (partition by region ) as total_perregion
from sales_data

--7 Compute the Rank of Customers Based on Their Total Purchase Amount
;with cte as (
select *,
sum(total_amount) over (partition by customer_id)  as total_sold
from sales_data
)
select *,
dense_rank () over (order by total_sold desc) as rnk
from cte

--8 Calculate the Difference Between Current and Previous Sale Amount per Customer
select *,
isnull(total_amount-lag(total_amount) over (partition by customer_id   order by order_date ) ,0)as diff
from sales_data

--9 Find the Top 3 Most Expensive Products in Each Category
;with cte as (
select *,
dense_rank() over (partition by product_category order by unit_price desc) as rnk
from sales_data
)
select * from cte
where rnk<=3

--10 Compute the Cumulative Sum of Sales Per Region by Order Date
select * ,
sum(total_amount) over (partition by region order by order_date) as order_per_region
from sales_data

--11 Compute Cumulative Revenue per Product Category	
select *,
sum(total_amount) over (partition by product_category order by order_date 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as per_category
from sales_data

--12 Here you need to find out the sum of previous values. Please go through the sample input and expected output.
/*
Sample Input

| ID |
|----|
|  1 |
|  2 |
|  3 |
|  4 |
|  5 |
Expected Output

| ID | SumPreValues |
|----|--------------|
|  1 |            1 |
|  2 |            3 |
|  3 |            6 |
|  4 |           10 |
|  5 |           15 |
*/

select sale_id,
sum(sale_id) over (order by sale_id rows between UNBOUNDED PRECEDING AND current ROW) as SumPreValues
from sales_data

--13 Sum of Previous Values to Current Value
CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);
--Sample Input
/*
| Value |
|-------|
|    10 |
|    20 |
|    30 |
|    40 |
|   100 |
Expected Output

| Value | Sum of Previous |
|-------|-----------------|
|    10 |              10 |
|    20 |              30 |
|    30 |              50 |
|    40 |              70 |
|   100 |             140 |
*/
select *,
sum(Value) over (order by value rows between 1 preceding and current row) as sum_of_previous
from OneColumn

--14 Find customers who have purchased items from more than one product_category
;with cte as (
select *,
rank() over (partition by product_category order by customer_id ) as more_purchase
from sales_data
)
select * from cte
where more_purchase=(select more_purchase from cte as cte2
where cte.customer_id=cte2.customer_id
group by more_purchase 
having count(distinct product_category)>1)

--15 Find Customers with Above-Average Spending in Their Region
;with cte as (
select customer_id, region ,
sum (total_amount) as total_spend,
cast(avg(sum(total_amount)) over (partition by region ) as decimal(10,2)) as avg_spend_region
from sales_data
group by customer_id, region
)
select * from cte
where total_spend>avg_spend_region

--16 Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.
select customer_id, region,
sum(total_amount)  as total,
rank() over (partition by region order by sum(total_amount ) desc) as spend_rank
from sales_data
group by customer_id, region

--17 Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
select customer_id, order_date,
sum(total_amount) over (partition by customer_id order by order_date 
rows between unbounded preceding and current row) as running_total
from sales_data
group by customer_id, order_date, total_amount

--18 Calculate the sales growth rate (growth_rate) for each month compared to the previous month.
;with MonthlySales as (
select
year(order_date) as SaleYear,
month(order_date) as SaleMonth,
sum(total_amount) as TotalAmount
from sales_data
group by year(order_date), month(order_date)
)

select SaleYear,SaleMonth,TotalAmount,
lag(TotalAmount) over (order by SaleYear, SaleMonth) as PrevMonthAmount,
    case
        when lag(TotalAmount) over (order by SaleYear, SaleMonth) is null then null
        else ((TotalAmount - lag(TotalAmount) over (order by SaleYear, SaleMonth)) 
              / lag(TotalAmount) over (order by SaleYear, SaleMonth)) * 100
    end as Growth_Rate
from MonthlySales
order by SaleYear, SaleMonth;

--19 Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
;with cte as (
select *,
lag(total_amount) over (partition by customer_id order by order_date ) as prevorderamount
from sales_data
)
select * from cte
where total_amount> prevorderamount

--20 Identify Products that prices are above the average product price
select * from sales_data
where unit_price>(select avg(unit_price) from sales_data)

--21 In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. 
--The challenge here is to do this in a single select. For more details please see the sample input and expected output.

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);


--Sample Input
/*
| Id  | Grp | Val1 | Val2 |  
|-----|-----|------|------|  
|  1  |  1  |   30 |   29 |  
|  2  |  1  |   19 |    0 |  
|  3  |  1  |   11 |   45 |  
|  4  |  2  |    0 |    0 |  
|  5  |  2  |  100 |   17 |
Expected Output

| Id | Grp | Val1 | Val2 | Tot  |
|----|-----|------|------|------|
| 1  | 1   | 30   | 29   | 134  |
| 2  | 1   | 19   | 0    | NULL |
| 3  | 1   | 11   | 45   | NULL |
| 4  | 2   | 0    | 0    | 117  |
| 5  | 2   | 100  | 17   | NULL |
*/


select *,
	case when row_number() over (partition by grp order by id)=1
	then sum(Val1+Val2) over (partition by grp)
	else null
	end as total
from MyData



--22 Here you have to sum up the value of the cost column based on the values of Id.
--For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

--Sample Input
/*
| Id   | Cost | Quantity |  
|------|------|----------|  
| 1234 |   12 |      164 |  
| 1234 |   13 |      164 |  
| 1235 |  100 |      130 |  
| 1235 |  100 |      135 |  
| 1236 |   12 |      136 | 
Expected Output

| Id   | Cost | Quantity |
|------|------|----------|
| 1234 | 25   | 164      |
| 1235 | 200  | 265      |
| 1236 | 12   | 136      |
*/

select ID,
    sum(Cost) AS Cost,
    case
        WHEN COUNT(DISTINCT Quantity) = 1 THEN MAX(Quantity)
        ELSE SUM(Quantity)
    END AS Quantity
FROM TheSumPuzzle
GROUP BY ID
ORDER BY ID;

--23 From following set of integers, write an SQL statement to determine the expected outputs
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54);
-- Output:
/*
---------------------
|Gap Start	|Gap End|
---------------------
|     1     |	6	|
|     8     |	12	|
|     16    |	26	|
|     36    |	51	|
---------------------
*/

select * from Seats
/* 22. Here you have to sum up the value of the cost column based on the values of Id. 
For Quantity if values are different then we have to add those values.
Please go through the sample input and expected output for details. */

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

;with cte as (
    select 
        Id,
        sum(Cost) over (partition by Id) as Cost,
        sum(Quantity) over (partition by Id) as Quantity,
        row_number() over (partition by Id order by (select null)) as rn
    from TheSumPuzzle
)
select Id, Cost, Quantity
from cte
where rn = 1;

select 
    Id,
    sum(Cost) as Cost,
    sum(distinct Quantity) as Quantity
from TheSumPuzzle
group by Id;

/* 23.From following set of integers, write an SQL statement to determine the expected outputs */

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

;with cte as (
select *,
        LAG(SeatNumber, 1, 0) OVER (ORDER BY SeatNumber) AS PreviousSeat
from Seats
)
select
PreviousSeat + 1 as GapStart,
SeatNumber - 1 as GapEnd
from cte
where SeatNumber - PreviousSeat > 1


