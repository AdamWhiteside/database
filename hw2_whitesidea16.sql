drop table CurrentLoan;
drop table History;
drop table Book;
drop table Member;

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
insert into Book values (19, 39, 'two', 'fff', 1908, 'car');
insert into Book values (20, 39, 'five', 'ggg', 1909, 'ear');
insert into Member values (101, 'Miller', 'Arthur', '1123house', '919_111_1111', 1);
insert into Member values (102, 'Smith', 'John', '1124house', '919_111_1112', 2);
insert into Member values (103, 'Dow', 'Ron', '1125house', '919_111_1113', 3);
insert into Member values (104, 'Dowe', 'Don', '1126house', '919_111_1114', 4);
insert into Member values (105, 'Dou', 'Sean', '1127house', '919_111_1115', 5);
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

--3
select bookID, title, author, publish_year from Book
where title like '%XML%'
and title like '%XQuery%'
order by publish_year DESC;


--4
select bookID, title, due_date from Member
NATURAL JOIN CurrentLoan
NATURAL JOIN Book
where firstname = 'John'
and lastname = 'Smith';


--5
(select memberID, lastname, firstname from Member)
MINUS
(select memberID, lastname, firstname from CurrentLoan NATURAL JOIN Member)
MINUS
(select memberID, lastname, firstname from History NATURAL JOIN Member);
