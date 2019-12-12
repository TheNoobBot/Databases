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

INSERT INTO Tables VALUES ('Agents'), ('Properties'), ('AgentProperties')

INSERT INTO Tests VALUES ('select_view'), 
    ('insert_agents'), ('delete_agents'),
	('insert_properties'), ('delete_properties'),
	('insert_agentproperties'), ('delete_agentproperties') 


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
    DECLARE @startTime1 DATETIME;
    DECLARE @endTime1 DATETIME;
    DECLARE @startTime2 DATETIME;
    DECLARE @endTime2 DATETIME;
    DECLARE @startTime3 DATETIME;
    DECLARE @endTime3 DATETIME;
	exec insertAgents
    SET @startTime1 = GETDATE();
    EXEC ('select * from Agents');
    PRINT 'select * from Agents';
    SET @endTime1 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view', @startTime1, @endTime1)
    INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@IDENTITY, 1, @startTime1, @endTime1);

	exec insertProperties
    SET @startTime2 = GETDATE();
    EXEC ('select * from Properties');
    PRINT 'select * from Properties';
    SET @endTime2 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view2', @startTime2, @endTime2)
    INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@identity, 2, @startTime2, @endTime2);
	exec insertAgentProperties
    SET @startTime3 = GETDATE();
    EXEC ('select * from AgentProperties');
    PRINT 'select * from AgentProperties';
    SET @endTime3 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view3', @startTime3, @endTime3)
    INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@identity, 3, @startTime3, @endTime3);
	exec deleteAgentProperties
	exec deleteAgents
	exec deleteProperties
  end
GO

GO
CREATE OR ALTER PROC TestRunInsertRemove
  AS
    begin
      DECLARE @startTime1 DATETIME;
      DECLARE @endTime1 DATETIME;

      DECLARE @startTime2 DATETIME;
      DECLARE @endTime2 DATETIME;

      DECLARE @startTime3 DATETIME;
      DECLARE @endTime3 DATETIME;

      DECLARE @startTime4 DATETIME;
      DECLARE @endTime4 DATETIME;

	  DECLARE @startTime5 DATETIME;
      DECLARE @endTime5 DATETIME;

	  DECLARE @startTime6 DATETIME;
      DECLARE @endTime6 DATETIME;

      SET @startTime1 = GETDATE()
      EXEC insertAgents
      PRINT ('exec insertAgents')
      SET @endTime1 = GETDATE()
      INSERT INTO TestRuns VALUES ('test_insert_agents', @startTime1, @endTime1)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @startTime1, @endTime1)

      SET @startTime3 = GETDATE()
      exec insertProperties
      print ('exec insertProperties')
      SET @endTime3 = GETDATE()
      INSERT INTO TestRuns values ('test_insert_properties', @startTime3, @endTime3)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @startTime3, @endTime3)
	  
      SET @startTime5 = GETDATE()
      exec insertAgentProperties
      print ('exec insertAgentProperties')
      SET @endTime5 = GETDATE()
      INSERT INTO TestRuns values ('test_insert_agentproperties', @startTime5, @endTime5)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @startTime5, @endTime5)

      SET @startTime6 = GETDATE()
      exec deleteAgentProperties
      print ('exec deleteAgentProperties')
      SET @endTime6 = GETDATE()
      INSERT INTO TestRuns values ('test_delete_agentproperties', @startTime6, @endTime6)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 3, @startTime6, @endTime6)

	  SET @startTime2 = GETDATE()
      EXEC deleteAgents
      PRINT ('exec deleteAgents')
      SET @endTime2 = GETDATE()
      INSERT INTO TestRuns VALUES ('test_delete_agents', @startTime2, @endTime2)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @startTime1, @endTime1)

	  SET @startTime4 = GETDATE()
      exec deleteProperties
      print ('exec deleteProperties')
      SET @endTime4 = GETDATE()
      INSERT INTO TestRuns values ('test_delete_properties', @startTime4, @endTime4)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @startTime4, @endTime4)

    end
  GO
exec TestRunView
exec TestRunInsertRemove
select * from TestRuns