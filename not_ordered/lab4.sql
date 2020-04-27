use PropertyRentalAgencyBeta
go

DELETE FROM TestViews
delete from TestRunViews
delete from TestRuns
delete from TestRunTables
DELETE FROM Tests
DELETE FROM Tables
delete from Agents
delete from Properties
delete from AgentProperties
go
CREATE OR ALTER VIEW AgentsView
AS
	SELECT * FROM PropertyRentalAgencyBeta.dbo.Agents
GO

CREATE OR ALTER VIEW PropertiesView
AS
	SELECT * FROM PropertyRentalAgencyBeta.dbo.Properties
GO

CREATE OR ALTER VIEW AgentPropertiesView
AS
	SELECT * FROM PropertyRentalAgencyBeta.dbo.AgentProperties
GO

DELETE FROM Views
INSERT INTO Views VALUES ('AgentsView'), ('PropertiesView'), ('AgentPropertiesView')

INSERT INTO Tables VALUES ('Agents'), ('Properties'), ('AgentProperties'), ('ItemsAtProperties')

INSERT INTO Tests VALUES ('select_view'), 
    ('insert_agents'), ('delete_agents'),
	('insert_properties'), ('delete_properties'),
	('insert_agentproperties'), ('delete_agentproperties'),
	('insert_items'),('delete_items')


INSERT INTO TestViews VALUES (1, 1)
INSERT INTO TestViews VALUES (1, 2)
INSERT INTO TestViews VALUES (1, 3)

INSERT INTO TestTables (TestId, TableID, NoOfRows, Position) VALUES (1, 1, 1000, 1)
INSERT INTO TestTables (TestId, TableID, NoOfRows, Position) VALUES (2, 2, 1000, 2)
INSERT INTO TestTables (TestId, TableID, NoOfRows, Position) VALUES (3, 3, 1000, 3)

go
CREATE OR ALTER PROC deleteAgents
AS
  DELETE FROM Agents
GO

GO
CREATE OR ALTER PROC deleteProperties
AS
  DELETE FROM Properties
GO

GO
CREATE OR ALTER PROC deleteAgentProperties
AS
  DELETE FROM AgentProperties
GO

CREATE OR ALTER PROC deleteItems
AS
  DELETE FROM ItemsAtProperty
GO


GO
CREATE OR ALTER PROC insertAgentProperties
AS
	DECLARE @index INT = 0
	 DECLARE @NoOfRows INT
	 SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestId = 3
	 
	WHILE @index < @NoOfRows
    BEGIN
      INSERT INTO AgentProperties VALUES (@index + 1, @index + 1)
      SET @index = @index + 1
    END
GO


create or alter PROC TestRunView
as
  begin
    DECLARE @startTime DATETIME;
    DECLARE @endTime DATETIME;
	exec insertAgents
	SET @startTime = GETDATE();
    EXEC ('select * from AgentsView');
    --PRINT 'select * from Agents';
    SET @endTime = GETDATE();
    INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test agent view', @startTime, @endTime)
    INSERT INTO TestRunViews values (1, 1, @startTime, @endTime);

	exec insertProperties
    SET @startTime = GETDATE();
    EXEC ('select * from PropertiesView');
    --PRINT 'select * from Properties';
    SET @endTime = GETDATE();
    INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test properties view', @startTime, @endTime)
    INSERT INTO TestRunViews values (2, 2, @startTime, @endTime);
	exec insertAgentProperties
    SET @startTime = GETDATE();
    EXEC ('select * from AgentPropertiesView');
    --PRINT 'select * from AgentProperties';
    SET @endTime = GETDATE();
    INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test AgentProperties view', @startTime, @endTime)
    INSERT INTO TestRunViews values (3, 3, @startTime, @endTime);
	exec deleteAgentProperties
	exec deleteAgents
	exec deleteProperties
  end
GO

GO
CREATE OR ALTER PROC TestRunInsertRemove
  AS
    begin
      DECLARE @startTime DATETIME;
      DECLARE @endTime DATETIME;

      SET @startTime = GETDATE()
      EXEC insertAgents
      --PRINT ('exec insertAgents')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test for inserting agents', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (1, 1, @startTime, @endTime)

      SET @startTime = GETDATE()
      exec insertProperties
      --print ('exec insertProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for inserting Properties', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (2, 2, @startTime, @endTime)
	  
      SET @startTime = GETDATE()
      exec insertAgentProperties
      --print ('exec insertAgentProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for inserting AgentProperties', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (3, 3, @startTime, @endTime)

	  SET @startTime = GETDATE()
      exec insertItems
      --print ('exec deleteProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for inserting items', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (4, 4, @startTime, @endTime)

	  SET @startTime = GETDATE()
      exec deleteItems
      --print ('exec deleteProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for deleting items', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (5, 4, @startTime, @endTime)


      SET @startTime = GETDATE()
      exec deleteAgentProperties
      --print ('exec deleteAgentProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for deleting AgentProperties', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (6, 3, @startTime, @endTime)

	  SET @startTime = GETDATE()
      EXEC deleteAgents
      --PRINT ('exec deleteAgents')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test for deleting agents', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (7, 1, @startTime, @endTime)

	  SET @startTime = GETDATE()
      exec deleteProperties
      --print ('exec deleteProperties')
      SET @endTime = GETDATE()
      INSERT INTO TestRuns(Description, StartAt, EndAt) values ('Test for deleting properties', @startTime, @endTime)
      INSERT INTO TestRunTables VALUES (8, 2, @startTime, @endTime)

    end
  GO
exec TestRunView
exec TestRunInsertRemove
select * from TestRuns