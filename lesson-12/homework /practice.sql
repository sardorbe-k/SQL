
--1
SELECT  p.firstName,  p.lastName,  a.city,  a.state FROM Person p
LEFT JOIN  Address a
ON p.personId = a.personId

--2
SELECT e.name AS Employee FROM Employee e
JOIN Employee m
ON e.managerId = m.id
WHERE e.salary > m.salary;


--3
SELECT  email AS Email
FROM Person
GROUP BY email
HAVING  COUNT(*) > 1;

--4
DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email)

--5
SELECT DISTINCT g.ParentName AS ParentName
FROM girls g
WHERE g.ParentName NOT IN (
    SELECT DISTINCT b.ParentName FROM boys b
);

--6
SELECT 
    o.custid,
    SUM(o.qty * o.unitprice) AS TotalSales,
    (SELECT MIN(weight) 
     FROM Sales.Orders 
     WHERE custid = o.custid) AS LeastWeight
FROM 
    Sales.Orders o
WHERE 
    o.weight > 50
GROUP BY 
    o.custid;

--7
SELECT 
    c1.Item AS [Item Cart 1],
    c2.Item AS [Item Cart 2]
FROM 
    Cart1 c1
FULL OUTER JOIN 
    Cart2 c2
ON 
    c1.Item = c2.Item;

--8
SELECT 
    name AS Customers
FROM 
    Customers
WHERE 
    id NOT IN (
        SELECT customerId FROM Orders
    );


--9
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN 
    Examinations e
    ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY 
    s.student_id, s.student_name, sub.subject_name
ORDER BY 
    s.student_id, sub.subject_name;




