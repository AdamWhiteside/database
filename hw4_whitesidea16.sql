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


insert into Book values (11, 31, 'DaVinciCode', 'ArthurMiller', 1900, 'fiction');
insert into Book values (12, 32, 'XML and XQuery: revenge of the search', 'aaa', 1901, 'fiction');
insert into Book values (13, 33, 'Harry Potter and the faulty compiler', 'ArthurMiller', 1902, 'fiction');
insert into Book values (14, 34, 'XQuery: The XML Query Language', 'bbb', 1903, 'fiction');
insert into Book values (15, 35, 'XML and XQuery', 'ccc', 1900, 'fiction');
insert into Book values (16, 36, 'Harry Potter and the quest for chegg', 'ddd', 1905, 'fiction');
insert into Book values (17, 37, 'BaBinciBode', 'ArthurMiller', 1906, 'fiction');
insert into Book values (18, 38, 'XQuery reading XML', 'eee', 1907, 'fiction');
insert into Book values (21, 38, 'XQuery reading XML', 'eee', 1907, 'fiction');
insert into Book values (19, 39, 'Harry Potter and the coding interview', 'fff', 1908, 'fiction');
insert into Book values (20, 39, 'Harry Potter and the coding interview', 'fff', 1908, 'fiction');
insert into Member values (101, 'Miller', 'Arthur', '1123house', '919_111_1111', 2);
insert into Member values (102, 'Smith', 'John', '1124house', '919_111_1112', 7);
insert into Member values (103, 'Jones', 'David', '1125house', '919_111_1113', 1);
insert into Member values (104, 'Dowe', 'Don', '1126house', '919_111_1114', 9);
insert into Member values (105, 'Dou', 'Sean', '1127house', '919_111_1115', 10);
insert into CurrentLoan values (101, 12, TO_DATE('2003/07/09', 'yyyy/mm/dd'), TO_DATE('2003/07/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (102, 13, TO_DATE('2004/08/09', 'yyyy/mm/dd'), TO_DATE('2004/08/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (103, 19, TO_DATE('2005/09/09', 'yyyy/mm/dd'), TO_DATE('2005/09/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (102, 16, TO_DATE('2006/10/09', 'yyyy/mm/dd'), TO_DATE('2006/10/10', 'yyyy/mm/dd'));
insert into CurrentLoan values (104, 14, TO_DATE('2006/10/09', 'yyyy/mm/dd'), TO_DATE('2006/10/10', 'yyyy/mm/dd'));
insert into History values (103, 12, TO_DATE('2013/07/09', 'yyyy/mm/dd'), TO_DATE('2013/07/10', 'yyyy/mm/dd'));
insert into History values (105, 15, TO_DATE('2014/08/09', 'yyyy/mm/dd'), TO_DATE('2014/08/10', 'yyyy/mm/dd'));
insert into History values (102, 19, TO_DATE('2015/09/09', 'yyyy/mm/dd'), TO_DATE('2015/09/10', 'yyyy/mm/dd'));
insert into History values (101, 13, TO_DATE('2016/10/09', 'yyyy/mm/dd'), TO_DATE('2016/10/10', 'yyyy/mm/dd'));
insert into History values (104, 15, TO_DATE('2016/10/09', 'yyyy/mm/dd'), TO_DATE('2016/10/10', 'yyyy/mm/dd'));
insert into History values (103, 15, TO_DATE('2017/11/09', 'yyyy/mm/dd'), TO_DATE('2017/11/10', 'yyyy/mm/dd'));
commit;


--1
SELECT Member.firstname, Member.lastname FROM CurrentLoan
LEFT JOIN Member ON CurrentLoan.MemberID = Member.memberID
GROUP BY Member.memberID, firstname, lastname, limit
HAVING COUNT(CurrentLoan.bookID) = limit;


--2
SELECT lastname, firstname FROM Member 
NATURAL JOIN (
((SELECT memberID, bookID FROM CurrentLoan) 
UNION 
(SELECT memberID, bookID FROM History))
NATURAL JOIN Book)
WHERE title LIKE 'XQuery: The XML Query Language'
AND memberID in (SELECT memberID FROM Member 
NATURAL JOIN (
((SELECT memberID, bookID FROM CurrentLoan) 
UNION 
(SELECT memberID, bookID FROM History))
NATURAL JOIN Book)
WHERE title = 'XML and XQuery');


--3
SELECT author
FROM (SELECT author, COUNT(DISTINCT Book.ISBN) AS Num FROM Book 
GROUP BY Book.author
HAVING COUNT(DISTINCT Book.ISBN) = (SELECT MAX(COUNT(DISTINCT Book.ISBN)) FROM Book GROUP BY Book.author));


--4
SELECT * FROM
((SELECT * FROM
	(
	SELECT COUNT(CurrentLoan.bookID), Member.memberID FROM Member 
	LEFT JOIN CurrentLoan ON Member.memberID = CurrentLoan.memberID
	GROUP BY Member.memberID
	))
NATURAL JOIN
(SELECT * FROM
	(
	SELECT COUNT(History.bookID), Member.memberID FROM Member 
	LEFT JOIN History ON Member.memberID = History.memberID
	GROUP BY Member.memberID
	)))
ORDER BY memberID ASC;


--5
SELECT memberID, firstname, lastname
FROM (
		(SELECT COUNT(title) AS Cou, memberID, firstname, lastname FROM Member 
			NATURAL JOIN
			(
				((SELECT distinct bookID, memberID FROM CurrentLoan) 
				UNION
				(SELECT distinct bookID, memberID FROM History)) 
				NATURAL JOIN Book
			)
			WHERE title LIKE '%Harry Potter%'
			GROUP BY memberID, firstname, lastname	
		)
)
WHERE Cou = (SELECT COUNT(DISTINCT Book.ISBN) FROM Book 
WHERE title LIKE '%Harry Potter%');