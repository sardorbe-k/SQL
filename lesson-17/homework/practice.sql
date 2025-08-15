--1
DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

-- Get all regions and distributors
WITH Regions AS (
    SELECT DISTINCT Region
    FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor
    FROM #RegionSales
)
SELECT 
    r.Region,
    d.Distributor,
    ISNULL(s.Sales, 0) AS Sales
FROM Regions r
CROSS JOIN Distributors d
LEFT JOIN #RegionSales s
    ON s.Region = r.Region
   AND s.Distributor = d.Distributor
ORDER BY d.Distributor, r.Region;

--2
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT m.name
FROM Employee e
JOIN Employee m
  ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(*) >= 5;

--3
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);


SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
JOIN Orders o 
    ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01'
  AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

--4
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders2 (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders2 VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

WITH VendorOrderCounts AS (
    SELECT 
        CustomerID,
        Vendor,
        COUNT(*) AS OrderCount,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM Orders2
    GROUP BY CustomerID, Vendor
)
SELECT CustomerID, Vendor
FROM VendorOrderCounts
WHERE rn = 1;

--5
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1; -- Assume prime until proven otherwise

-- Numbers less than 2 are not prime
IF @Check_Prime < 2
BEGIN
    SET @IsPrime = 0;
END
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0; -- Not prime
            BREAK;
        END
        SET @i += 1;
    END
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

--6
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');


WITH LocationCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signal_count
    FROM Device
    GROUP BY Device_id, Locations
),
RankedLocations AS (
    SELECT 
        Device_id,
        Locations,
        signal_count,
        ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY signal_count DESC) AS rn
    FROM LocationCounts
),
DeviceSummary AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(signal_count) AS no_of_signals
    FROM LocationCounts
    GROUP BY Device_id
)
SELECT 
    ds.Device_id,
    ds.no_of_location,
    rl.Locations AS max_signal_location,
    ds.no_of_signals
FROM DeviceSummary ds
JOIN RankedLocations rl
    ON ds.Device_id = rl.Device_id
   AND rl.rn = 1;

--7
CREATE TABLE Employee1 (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee1 VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);


SELECT EmpID, EmpName, Salary
FROM Employee1 e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);

--8
-- Step 1: Create the table
CREATE TABLE Numbers (
    Number INT
);

-- Step 2: Insert values into the table
INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);


-- Step 1: Create the Tickets table
CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);

-- Step 2: Insert the data into the table
INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);
-- Calculate total winnings

SELECT SUM(CASE 
             WHEN match_count = total_numbers THEN 100
             WHEN match_count > 0 THEN 10
             ELSE 0
           END) AS Total_Winnings
FROM (
    SELECT 
        t.TicketID,
        COUNT(DISTINCT t.Number) AS ticket_numbers,
        SUM(CASE WHEN n.Number IS NOT NULL THEN 1 ELSE 0 END) AS match_count,
        (SELECT COUNT(*) FROM Numbers) AS total_numbers
    FROM Tickets t
    LEFT JOIN Numbers n
        ON t.Number = n.Number
    GROUP BY t.TicketID
) AS TicketResults;

--9
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);


WITH UserDailyPlatform AS (
    SELECT
        Spend_date,
        User_id,
        SUM(CASE WHEN Platform = 'Mobile' THEN Amount ELSE 0 END) AS MobileAmount,
        SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS DesktopAmount
    FROM Spending
    GROUP BY Spend_date, User_id
),
PlatformType AS (
    SELECT
        Spend_date,
        CASE 
            WHEN MobileAmount > 0 AND DesktopAmount > 0 THEN 'Both'
            WHEN MobileAmount > 0 THEN 'Mobile'
            WHEN DesktopAmount > 0 THEN 'Desktop'
        END AS Platform,
        (MobileAmount + DesktopAmount) AS TotalAmount,
        User_id
    FROM UserDailyPlatform
)
SELECT
    Spend_date,
    Platform,
    SUM(TotalAmount) AS Total_Amount,
    COUNT(DISTINCT User_id) AS Total_users
FROM PlatformType
GROUP BY Spend_date, Platform
ORDER BY Spend_date, 
         CASE Platform 
             WHEN 'Mobile' THEN 1
             WHEN 'Desktop' THEN 2
             WHEN 'Both' THEN 3
         END;

--10
DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

WITH RECURSIVE Expanded AS (
    -- Start with quantity = 1 for each product
    SELECT Product, 1 AS Quantity, Quantity AS MaxQty
    FROM Grouped
    
    UNION ALL
    
    -- Keep adding rows until we reach MaxQty
    SELECT Product, 1 AS Quantity, MaxQty
    FROM Expanded
    WHERE Quantity < MaxQty
)
SELECT Product, Quantity
FROM Expanded
ORDER BY Product
OPTION (MAXRECURSION 0); -- for SQL Server only, not needed in MySQL/PostgreSQL


