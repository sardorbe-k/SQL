                                                 EASY
           1. Atamalar ta’rifi
Data — Bu raqamlar, matnlar yoki faktlardir. Masalan: ism, yosh, manzil – bularning barchasi ma’lumot bo‘ladi.
Masalan: 'Ali', 23, 'Toshkent'
Database — Bu ma’lumotlarni saqlash, boshqarish va ularga ishlov berish uchun yaratilgan tizimdir.
Bunda bir nechta jadval, so‘rovlar, foydalanuvchilar bo‘lishi mumkin.
Relational Database — Ma’lumotlar bir nechta jadvallarda saqlanadi va ular o‘zaro bog‘langan bo‘ladi.
➡ Masalan, Students va Courses jadvallari student_id orqali bog‘langan bo‘lishi mumkin.
Table-Bu ma’lumotlar saqlanadigan asosiy tuzilma bo‘lib, ustunlar (column) va satrlardan (row) tashkil topgan.
➡ Har bir ustun ma’lumot turi, har bir satr esa bitta yozuvni ifodalaydi.
            2. SQL Server’ning 5 ta asosiy xususiyati (features):
Relational Database Management – Nisbiy ma’lumotlar bazasini boshqaradi.
Security – Ma’lumotlarni xavfsiz saqlash uchun foydalanuvchi huquqlari va autentifikatsiya tizimi bor.
Data Analysis Tools – BI (Business Intelligence) imkoniyatlari va reporting tools (hisobot vositalari) mavjud.
High Performance – Katta hajmdagi ma’lumotlar bilan tez ishlay oladi.
Backup and Recovery – Ma’lumotlarni zaxiralash va tiklash imkoniyati mavjud.
            3. SQL Server'da mavjud autentifikatsiya (authentication) rejimlari:
1. Windows Authentication
Foydalanuvchi kompyuterga Windows login orqali kirgan bo‘lsa, qo‘shimcha parol kiritmasdan SQL Serverga ulanishi mumkin.
2. SQL Server Authentication
Bu rejimda login va parol alohida SQL Server uchun yaratiladi. Windows hisobidan mustaqil ishlaydi.

                                                MEDIUM
4.create database SchoolDB
5.create table Students (id int primary key,name varchar (50), age int)
6.SQL Server, SSMS va SQL o‘rtasidagi farq:
SQL Server-Bu ma’lumotlar omborini boshqarish tizimi (DBMS) bo‘lib, ma’lumotlarni saqlash va ishlov berishga xizmat qiladi.
SSMS-Bu grafik interfeysli dastur (GUI) bo‘lib, SQL Server bilan ishlashni osonlashtiradi. U orqali query yoziladi, ma’lumotlar ko‘riladi.
SQL-Bu Structured Query Language (Tuzilgan so‘rov tili) bo‘lib, ma’lumotlar bilan ishlash uchun buyruqlar (so‘rovlar) yoziladi.
                                                Hard
7.
DQL(Data Query Language)-Ma’lumotni so‘rash (query),SELECT * FROM Students;
DML(Data Manipulation Language)-Jadvaldagi ma’lumotni qo‘shish, o‘zgartirish, o‘chirish	INSERT, UPDATE, DELETE
INSERT INTO Students VALUES (1, 'Ali', 20);
DDL(Data Definition Language)-Jadval va strukturani yaratish yoki o‘zgartirish	CREATE, ALTER, DROP
CREATE TABLE Students (...);
DCL(Data Control Language)-Foydalanuvchi huquqlarini boshqarish	GRANT, REVOKE
GRANT SELECT ON Students TO user1;
TCL(Transaction Control Language)-Bir nechta buyruqlarni bitta blok sifatida boshqarish	COMMIT, ROLLBACK, SAVEPOINT
BEGIN TRANSACTION ... COMMIT;
8.
select * from Students
insert into Students values (1, 'Alijan', 19), (2, 'Amirbek', 20), (3, 'Bobur', 32)
9. faylni yukalab oldim downloads papkasiga tushdi, faylni SQL Server ning default backup papkasiga ko'chirdim
SSMS ni ochib restore database qildim so'ngra ketma ketlik bilan oxirida ok ni bosib faylni tikladim.


                                                         
                                                         











                     
