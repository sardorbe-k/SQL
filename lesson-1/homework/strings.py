use BMW_cars
create table Costs(id int, name varchar(15),)
 select * from Costs
  insert into Costs values (6, 'Amir'),(7, 'Javakhir'), (8, 'Furat'), (9, 'Asal'),(10, 'Malika')
-- bu yerda 5ta oldin qilib keyin yana yozib utirmaslik uchun raqam va ismlar uzgartirib chiqilgan

use Noone
create table lesson (id int, name varchar(15))
 select * from lesson
  insert into lesson values (6, 'Abduqodir')
  insert into lesson values (7, 'Kamol')
  insert into lesson values (8, 'Hikoyat')
  insert into lesson values (9, 'Alijon')
  insert into lesson values (10, 'Nusrat')
-- bu yerda huddi tepaday ishlangan faqat insert bilan into kuproq ishlatilgan esda qolishi uchun
   
use nik 
create table lesson_two(id int, name varchar (15))
 select* from lesson_two
  insert into lesson_two values (1,'Nasiba')

create table lesson_three (id int, name varchar (15))
 select * from lesson_three 
  insert into lesson_three values (1, 'noone')
--bitta bazada 2ta table ochilgan
create database Dataa
go 
use Dataa
create table lesson_five (id int,name varchar(10), age int,)
 select * from lesson_five
  insert into lesson_five values (1, 'Botir' , '12')
  insert into lesson_five values (2, 'Sardorbek', '17')
  insert into lesson_five values (3, 'Malika', '15')
  insert into lesson_five values (4, 'O''tkir', '34')
-- bu table ageni ham qushganman    
