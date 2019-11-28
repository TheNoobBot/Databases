--{AND, OR, NOT},  {<,<=,=,>,>=,<> }, IS [NOT] NULL, IN, BETWEEN, LIKE.

USE MASTER
GO
USE PropertyRentalAgencyBeta
GO
INSERT Utilities(utilities_id, electricity) VALUES (241,1246)
INSERT Maintenance(maintenance_id, total_price) VALUES (918,6246)

DELETE FROM Utilities
WHERE utilities_id = 241

DELETE FROM Maintenance
WHERE
total_price > 241


UPDATE TenantContracts 
SET rent = 2017
WHERE rent = 216 OR rent = 218

UPDATE CompanyContracts
SET starting_date = '2019-10-10'
WHERE starting_date BETWEEN '2019-08-08' AND '2019-09-09'


UPDATE Agents 
SET work_phone_number = null
WHERE first_name = 'Kit'

UPDATE ItemsAtProperty
SET value = 93
WHERE value is not null and value = 90