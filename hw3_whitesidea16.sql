drop table CurrentLoan;
drop table History;
drop table Book;
drop table Member;
drop view member_book;

create table Book(
bookID int not null,
ISBN int not null,
title varchar(255),
author varchar(255),
publish_year int not null,
category varchar(255),
primary key (bookID)
);

create table Member(
memberID int not null,
lastname varchar(255),
firstname varchar(255),
address varchar(255),
phone_number varchar(255),
limit int not null,
primary key (memberID)
);

create table CurrentLoan(
memberID int not null,
bookID int not null,
loan_date date not null,
due_date date not null,
primary key (memberID, bookID),
foreign key(memberID) references Member,
foreign key(bookID) references Book
);

create table History(
memberID int not null,
bookID int not null,
loan_date date not null,
return_date date not null,
primary key (memberID, bookID),
foreign key(memberID) references Member,
foreign key(bookID) references Book
);


insert into Book values (11, 31, 'DaVinciCode', 'ArthurMiller', 1900, 'apple');
insert into Book values (12, 32, 'XML book XQuery', 'aaa', 1901, 'bear');
insert into Book values (13, 33, 'name XQuery', 'ArthurMiller', 1902, 'car');
insert into Book values (14, 34, 'XML title1', 'bbb', 1903, 'deer');
insert into Book values (15, 35, 'XQuery paper XML', 'ccc', 1900, 'ear');
insert into Book values (16, 36, 'words', 'ddd', 1905, 'fear');
insert into Book values (17, 37, 'BaBinciBode', 'ArthurMiller', 1906, 'gear');
insert into Book values (18, 38, 'XQuery reading XML', 'eee', 1907, 'hear');
insert into Book values (21, 38, 'XQuery reading XML', 'eee', 1907, 'hear');
insert into Book values (19, 39, 'two', 'fff', 1908, 'car');
insert into Book values (20, 39, 'two', 'fff', 1908, 'car');
insert into Member values (101, 'Miller', 'Arthur', '1123house', '919_111_1111', 1);
insert into Member values (102, 'Smith', 'John', '1124house', '919_111_1112', 7);
insert into Member values (103, 'Jones', 'David', '1125house', '919_111_1113', 8);
insert into Member values (104, 'Dowe', 'Don', '1126house', '919_111_1114', 9);
insert into Member values (105, 'Dou', 'Sean', '1127house', '919_111_1115', 10);
insert into CurrentLoan values (101, 12, TO_DATE('2003/07/09', 'yyyy/mm/dd'), TO_DATE('2003/07/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (102, 13, TO_DATE('2004/08/09', 'yyyy/mm/dd'), TO_DATE('2004/08/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (103, 11, TO_DATE('2005/09/09', 'yyyy/mm/dd'), TO_DATE('2005/09/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (101, 15, TO_DATE('2006/10/09', 'yyyy/mm/dd'), TO_DATE('2006/10/10', 'yyyy/mm/dd'));
insert into History values (103, 12, TO_DATE('2013/07/09', 'yyyy/mm/dd'), TO_DATE('2013/07/10', 'yyyy/mm/dd'));
insert into History values (105, 11, TO_DATE('2014/08/09', 'yyyy/mm/dd'), TO_DATE('2014/08/10', 'yyyy/mm/dd'));
insert into History values (102, 12, TO_DATE('2015/09/09', 'yyyy/mm/dd'), TO_DATE('2015/09/10', 'yyyy/mm/dd'));
insert into History values (101, 13, TO_DATE('2016/10/09', 'yyyy/mm/dd'), TO_DATE('2016/10/10', 'yyyy/mm/dd'));
insert into History values (103, 11, TO_DATE('2017/11/09', 'yyyy/mm/dd'), TO_DATE('2017/11/10', 'yyyy/mm/dd'));
commit;

--1
select Member.memberID, Member.firstname, Member.lastname, COUNT(CurrentLoan.bookID) AS Num FROM CurrentLoan
LEFT JOIN Member ON CurrentLoan.MemberID = Member.memberID
GROUP BY Member.memberID, firstname, lastname;

--2
select ISBN, title
FROM Book
GROUP BY ISBN, title
HAVING COUNT(title) > 1;

--3
CREATE VIEW member_book AS
SELECT CurrentLoan.MemberID, lastname, firstname, CurrentLoan.bookID, title 
FROM Book, CurrentLoan, Member 
WHERE CurrentLoan.memberID = Member.memberID 
AND CurrentLoan.bookID = Book.bookID
UNION
SELECT History.MemberID, lastname, firstname, History.bookID, title 
FROM Book, History, Member 
WHERE History.memberID = Member.memberID 
AND History.bookID = Book.bookID;

--4
SELECT bookID, title
FROM member_book
WHERE firstname = 'John'
AND lastname = 'Smith';

--5
DELETE FROM CurrentLoan 
WHERE memberID in (SELECT memberID 
FROM Member 
WHERE firstname = 'David'
AND lastname = 'Jones');
commit;

DELETE FROM History
WHERE memberID in (SELECT memberID 
FROM Member
WHERE firstname = 'David'
AND lastname = 'Jones');
commit;

DELETE FROM Member
WHERE firstname = 'David'
AND lastname = 'Jones';
commit;

--6
UPDATE Member
SET limit = CASE
WHEN limit > 7 THEN 10
ELSE limit + 2
END;
commit;