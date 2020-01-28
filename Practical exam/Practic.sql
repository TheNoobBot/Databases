use test
GO
drop table if exists SessionChildren
drop table if exists GameSession
drop table if exists Teacher 
drop table if exists Children
drop table if exists Kindergarten
drop table if exists Game

create table Game(
	name varchar(255) primary key,
	difficulty int default 1,
	recomended_age int
)

insert into Game values ('game1', 1, 5)
insert into Game values ('game2', 1, 4)
insert into Game values ('game3', 2, 6)
insert into Game values ('game4', 3, 3)
insert into Game values ('game5', 4, 4)
insert into Game values ('game6', 5, 5)

create table Kindergarten(
	id int primary key identity,
	name varchar(255),
	city varchar(255)
)
insert into Kindergarten values('Kindergarten1', 'City1')
insert into Kindergarten values('Kindergarten2', 'City1')
insert into Kindergarten values('Kindergarten3', 'City2')

create table Children(
	id int primary key identity,
	forename varchar(255),
	surname varchar(255),
	gender varchar(15),
	date_of_birth date,
	kindergarten int foreign key references Kindergarten(id)
);

insert into Children values ('F1', 'S1', 'female', '01/01/2015', 1)
insert into Children values ('F2', 'S2', 'male', '01/03/2015', 1)
insert into Children values ('F3', 'S3', 'female', '02/02/2016', 1)
insert into Children values ('F4', 'S4', 'male', '04/01/2015', 1)
insert into Children values ('F5', 'S5', 'female', '01/01/2018', 1)
insert into Children values ('F6', 'S6', 'male', '01/01/2017', 2)
insert into Children values ('F7', 'S7', 'female', '05/05/2015', 2)
insert into Children values ('F8', 'S8', 'male', '07/01/2015', 3)
insert into Children values ('F9', 'S9', 'female', '09/09/2015', 3)
insert into Children values ('F0', 'S0', 'male', '06/07/2016', 3)

create table Teacher(
	id int primary key identity,
	forename varchar(255),
	surname varchar(255),
	kindergarten int foreign key references Kindergarten(id)
);

insert into Teacher values ('TF1', 'TS1', 1)
insert into Teacher values ('TF2', 'TS2', 1)
insert into Teacher values ('TF3', 'TS3', 2)
insert into Teacher values ('TF4', 'TS4', 3)

create table GameSession(
	id int primary key identity,
	game varchar(255) foreign key references Game(name),
	playtime datetime
)
insert into GameSession values ('game1', '01/01/2020 12:00:00')
insert into GameSession values ('game2', '02/01/2020 12:00:00')
insert into GameSession values ('game3', '03/01/2020 12:00:00')
insert into GameSession values ('game4', '04/01/2020 12:00:00')
insert into GameSession values ('game3', '05/01/2020 12:00:00')
insert into GameSession values ('game2', '06/01/2020 12:00:00')
insert into GameSession values ('game3', '07/01/2020 12:00:00')
insert into GameSession values ('game6', '08/01/2020 12:00:00')

create table SessionChildren(
	child_id int foreign key references Children(id),
	session_id int foreign key references GameSession(id),
	unique(child_id, session_id)
)

insert into SessionChildren values (1, 1)
insert into SessionChildren values (2, 3)
insert into SessionChildren values (3, 4)
insert into SessionChildren values (4, 5)
insert into SessionChildren values (1, 8)
insert into SessionChildren values (2, 7)
insert into SessionChildren values (3, 7)
insert into SessionChildren values (4, 8)
insert into SessionChildren values (8, 8)
insert into SessionChildren values (5, 7)
insert into SessionChildren values (3, 6)
insert into SessionChildren values (1, 5)
insert into SessionChildren values (6, 1)
insert into SessionChildren values (8, 3)
insert into SessionChildren values (10, 4)
insert into SessionChildren values (9, 1)
insert into SessionChildren values (7, 5)
-- for ex 3
insert into SessionChildren values (1, 2)
insert into SessionChildren values (2, 2)
insert into SessionChildren values (3, 2)
insert into SessionChildren values (4, 2)
insert into SessionChildren values (5, 2)
insert into SessionChildren values (6, 2)
insert into SessionChildren values (7, 2)
insert into SessionChildren values (8, 2)
insert into SessionChildren values (9, 2)
insert into SessionChildren values (10, 2)

select * from SessionChildren

go

create or alter procedure deleteGame @game_name varchar(255)
as
	delete from SessionChildren where SessionChildren.session_id in (
	select GameSession.id from GameSession where GameSession.game = @game_name)
	delete from GameSession where GameSession.game = @game_name
	delete from Game where Game.name = @game_name
go
print '-----------------------------------------------------'
print 'Before deleting game 3'
select * from Game
exec deleteGame 'game3'
print 'After deleting game 3'
select * from Game
print '-----------------------------------------------------'
go

create or alter view EverybodyPlayedTheseGames 
as
	select Game.name from Game where 
	(select COUNT(*) from Children)
	=
	(select COUNT(*) from
	(select child_id from SessionChildren where SessionChildren.session_id in (
	select GameSession.id from GameSession where GameSession.game = Game.name) group by child_id) a)
go
print '-----------------------------------------------------'
print 'Everybody played these games:'
select * from EverybodyPlayedTheseGames
print '-----------------------------------------------------'
go

create or alter function atLeastNTeachers(@N int)
returns table 
as
	return
	
	select Kindergarten.name from Kindergarten 
	where ( select COUNT(*) from (select * from Teacher where Teacher.kindergarten = Kindergarten.id) a) >= @N
go
print '-----------------------------------------------------'
print 'At least 2 teachers:'
select * from atLeastNTeachers(2)
print '-----------------------------------------------------'