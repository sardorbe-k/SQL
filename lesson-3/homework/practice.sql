--    1.
/*   BULK INSERT — bu SQL Server’da tashqi fayldan (masalan, .csv yoki .txt) katta hajmdagi ma’lumotlarni jadvalga tez yuklash uchun ishlatiladigan buyrug‘dir.
Maqsadi: Ma’lumotlarni tez, samarali va avtomatik tarzda import qilish. Odata, bu ETL jarayonlarida yoki tashqi tizimlardan ma’lumot yuklashda qo‘llaniladi.*/

--    2.
/*SQL Serverga import qilinadigan asosiy to‘rtta fayl formati quyidagilar:
CSV – Comma Separated Values (vergul bilan ajratilgan fayl)
TXT – Oddiy matn fayli (belgilar bilan ajratilgan)
XML – Extensible Markup Language (strukturaviy ma’lumotlar uchun)
JSON – JavaScript Object Notation (zamonaviy ma’lumotlar formati)*/

use Nik
create table products
(
productid int primary key,
productname varchar (50),
price decimal(10,2)
);

insert into products(productid, productname, price) values
(1,'laptop',120000),
(2,'phone',20000),
(3,'airpods',3000)

select * from products

--   5.
/*NULL — bu ma’lumot yo‘qligini bildiradi.
Bu ustunga hali hech qanday qiymat kiritilmagan degani. 
U “0” yoki bo‘sh string emas, balki noma’lum yoki mavjud emas degan ma’noni anglatadi.
Misol uchun: INSERT INTO Students (Name, Age) VALUES ('Ali', NULL); */

/*NOT NULL esa ustun bo‘sh qolmasligi kerakligini bildiradi. 
Ya’ni, bu ustunga majburiy qiymat kiritilishi shart.
CREATE TABLE Students (
    ID INT NOT NULL,
    Name VARCHAR(50) NOT NULL
); */

/* NULL                                                 NOT NULL                         
 Qiymat yo‘q                                       Qiymat kiritilishi shart            
 Bo‘sh qoldirish mumkin                            Bo‘sh qoldirish mumkin emas         
 Odatda noma’lum yoki hozircha yo‘q qiymat uchun   Har doim ma’lumot kiritilishi kerak */

 alter table products
 add constraint uq_productname unique (productname)

 -- bu bir qatorli izoh (comment) yozish uchun ishlatiladi.
/*
Izohlar kod bajarilishiga ta’sir qilmaydi, faqat tushuntirish uchun yoziladi.
Izoh yozish odatiy amaliyot bo‘lib, kodni o‘qish va tushunishni osonlashtiradi.
Agar ko‘p qatorli izoh kerak bo‘lsa, quyidagicha yoziladi:    */
/*
  Bu so‘rov barcha elektron mahsulotlarning
  narxini 10 foizga oshiradi.
*/


alter table products
add categoryid int

create table categories
(
   categoryid int primary key,
   categoryname varchar(50) unique,
)
select * from categories

--
/*IDENTITY ustuni SQL Server’da avtomatik raqam beruvchi ustun bo‘lib,
odatda asosiy kalit (Primary Key) sifatida ishlatiladi.
Har safar yangi satr qo‘shilganda, bu ustunga qiymat avtomatik tarzda belgilanadi.*/


bulk insert products
from 'C:\Data\products.txt'
with 
(
 fieldterminator=',',
 rowterminator='\n',
 firstrow=2
 )

alter table Products
add constraint FK_Products_Categories
foreign key (CategoryID)
references Categories(CategoryID);

select * from products

--
/*PRIMARY KEY – jadvalning asosiy identifikatori, takrorlanmaydi va NULL bo‘lmaydi.

UNIQUE KEY – ustundagi qiymatlar takrorlanmas bo‘lishi kerak, lekin NULL ruxsat etiladi.*/

alter table Products
add constraint CHK_Price_Positive
check (Price > 0);

alter table Products
add Stock int NOT NULL default 0;

select ProductName, isnull(Price, 0) as Price
from Products;

-- FOREIGN KEY constraint — bu ikki jadval orasidagi bog‘liqlikni o‘rnatadi. U boshqa jadvaldagi ustunga ishora qilib, ma’lumotlar to‘g‘riligini va yaxlitligini ta’minlaydi.
/*Jadvaldagi ustun qiymatlari boshqa jadvaldagi mavjud qiymatlarga mos bo‘lishini talab qiladi.
Noto‘g‘ri yoki mavjud bo‘lmagan ma’lumotlar kiritilishiga yo‘l qo‘ymaydi.*/

create table customers
(
   customerid int primary key,
   customername varchar (50),
   age int check (age>=18)
)
select * from customers

create table Orders (
    OrderID int identity(100, 10) primary key,
    CustomerName varchar(100) NOT NULL
);

create table OrderDetails (
    OrderID int,
    ProductID int,
    Quantity int,
    primary key (OrderID, ProductID)
);

select * from OrderDetails

--
/*       SQL Server’da ISNULL() va COALESCE() funksiyalari NULL qiymatlarni aniqlash va ularni boshqa qiymat bilan almashtirish uchun ishlatiladi.
ISNULL() funksiyasi
Maqsadi: NULL bo‘lgan qiymatni belgilangan boshqa qiymat bilan almashtiradi.
ISNULL() – NULL qiymatni bitta aniq qiymat bilan almashtirish uchun ishlatiladi.

COALESCE() funksiyasi
Maqsadi: Berilgan bir nechta qiymatdan birinchi NULL bo‘lmagan qiymatni qaytaradi.
COALESCE() – bir nechta ustun yoki qiymatdan birinchi mavjud qiymatni tanlash uchun ishlatiladi.
*/

create table Employee (
    EmpID int primary key,
    name varchar(100) NOT NULL,
    Email varchar(100) unique,
    Position varchar(50)
);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
ON DELETE CASCADE
ON UPDATE CASCADE;




