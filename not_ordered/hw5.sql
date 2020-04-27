use PropertyRentalAgencyBeta
GO

DROP TABLE IF EXISTS Tc
DROP TABLE IF EXISTS Tb
DROP TABLE IF EXISTS Ta
CREATE TABLE Ta (
	aid INT PRIMARY KEY IDENTITY(1, 1),
	a2 INT UNIQUE,
	random_number INT
)
INSERT INTO Ta VALUES (1, 124), (2,932865), (3,82471), (199,12834), (177,1827), (12,1)


CREATE TABLE Tb (
	bid INT PRIMARY KEY IDENTITY(1, 1),
	b2 INT
)

INSERT INTO Tb VALUES (1), (-5), (-3), (2), (8), (199), (178)

CREATE TABLE Tc (
	cid INT PRIMARY KEY IDENTITY(1, 1),
	aid INT FOREIGN KEY REFERENCES Ta(aid),
	bid INT FOREIGN KEY REFERENCES Tb(bid),
)

INSERT INTO Tc VALUES (3, 2), (4, 7), (5, 7), (6, 5)

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_tb_b2')
 DROP INDEX N_tb_b2 ON TableB;
GO
-- Create a nonclustered index called N_tableB_b2 on the TableB table using the b2 column.
CREATE NONCLUSTERED INDEX N_tb_b2 ON Tb(b2); 
GO

-- clustered index scan
SELECT * FROM Ta ORDER BY aid

-- non clustered index scan && key lookup
SELECT * FROM Ta ORDER BY a2

-- clustered index seek
SELECT a.aid FROM Ta a
INNER JOIN Tb b ON a.aid = b.bid

-- non clustered index seek
SELECT *
FROM Ta a
WHERE a2 = 5

-- b
SELECT *
FROM Tb b
WHERE b2 = 2

-- c
drop view if exists testView
GO
CREATE VIEW testView
AS
	SELECT a.random_number
	FROM Ta a 
	INNER JOIN Tb b ON a.a2 = b.b2
	INNER JOIN Tc c on c.aid = a.aid
GO

-- uses N_tableB_2 
SELECT * FROM testView