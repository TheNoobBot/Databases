use PropertyRentalAgencyBeta

drop procedure main

drop procedure upgrade1
drop procedure downgrade0

drop procedure upgrade2
drop procedure downgrade1

drop procedure upgrade3
drop procedure downgrade2

drop procedure upgrade4
drop procedure downgrade3

drop procedure upgrade5
drop procedure downgrade4

drop procedure upgrade6
drop procedure downgrade5

drop procedure upgrade7
drop procedure downgrade6

drop table Version
create table Version(
	number int primary key
)
insert into Version values (0) 

drop table Loans
create table Loans(
	loan_id int not null,
	property_id int not null,
	loan int not null,
	time_months int not null
)

exec upgrade1
exec upgrade2
exec upgrade3
exec upgrade4
exec upgrade5
exec upgrade6
exec upgrade7

exec downgrade6
exec downgrade5
exec downgrade4
exec downgrade3
exec downgrade2
exec downgrade1
exec downgrade0




-- a. modify the type of a column;

go
create proc upgrade1 as
	alter table Utilities alter column gas float
go

go
create proc downgrade0 as
	alter table Utilities alter column gas int
go

exec upgrade1

exec downgrade0

-- b. add / remove a column;
go
create proc upgrade2 as
	alter table Utilities add Internet int
go

go
create proc downgrade1 as
	alter table Utilities drop column Internet
go

exec upgrade2

exec downgrade1

-- c. add / remove a DEFAULT constraint;
go
create proc upgrade3 as
	alter table Utilities add constraint default_misc default 0 for misc
go

go
create proc downgrade2 as
	alter table Utilities drop constraint default_misc
go

exec upgrade3

exec downgrade2

-- d. add / remove a primary key;

go
create proc upgrade4 as
	alter table Loans add constraint PK_loan_id primary key (loan_id)
go

go
create proc downgrade3 as
	alter table Loans drop constraint PK_loan_id
go

exec upgrade4

exec downgrade3


-- e. add / remove a candidate key;
go
create proc upgrade5 as
	alter table Tenants add constraint uq_phone_number unique (phone_number)
go

go
create proc downgrade4 as
	alter table Tenants drop constraint uq_phone_number
go

exec upgrade5

exec downgrade4

-- f. add / remove a foreign key;

go 
create proc upgrade6 as
	alter table Loans add constraint fk_property_id foreign key(property_id) references Properties(property_id)
go 

create proc downgrade5 as 
	alter table Loans drop constraint fk_property_id
go

exec upgrade6

exec downgrade5

-- g. create / remove a table.
go 
create proc upgrade7 as
	create table Renovation(
		renovation_id int primary key,
		property_id int foreign key references Properties(property_id),
		start_time date not null,
		end_time date not null,
		full_price int default 0
	)
go

create proc downgrade6 as
	drop table Renovation
go

exec upgrade7

exec downgrade6


CREATE PROCEDURE main
@version int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @nextVersion varchar(50)
	DECLARE @currentVersion int
	SET @currentVersion = (SELECT number from Version)

	if @version < 0 or @version > 7
	BEGIN
		print('Version does not exists')
		return 2
	END

	WHILE @currentVersion < @version
	BEGIN
		SET @currentVersion = @currentVersion + 1
		SET @nextVersion = 'upgrade' + CONVERT(varchar(3), @currentVersion)
		EXECUTE @nextVersion
	END

	WHILE @currentVersion > @version
	BEGIN
		SET @currentVersion = @currentVersion - 1
		SET @nextVersion = 'downgrade' + CONVERT(varchar(3), @currentVersion)
		EXECUTE @nextVersion
	END

	TRUNCATE TABLE Version
	insert into Version values(@version)
END
	
exec main 8

