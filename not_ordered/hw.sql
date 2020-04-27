USE master;
GO
USE PropertyRentalAgencyBeta;
GO

-- a with union
SELECT * FROM Tenants
WHERE last_name like 'Gr%'
UNION
SELECT * FROM Tenants
WHERE last_name like '%od';

SELECT * FROM Tenants
WHERE phone_number like '213%'
UNION
SELECT * FROM Tenants
WHERE phone_number like '%474%';

-- a with or
SELECT * FROM Tenants
WHERE last_name like 'Gr%' or last_name like '%od';

SELECT * FROM Tenants
WHERE phone_number like '213%' or phone_number like '%474%';

-- b intersect

SELECT * FROM Agents
WHERE birth_date < '1980-1-1'
INTERSECT
SELECT * FROM Agents
WHERE agent_id > 400

SELECT * FROM Agents
WHERE address like '%Way'
INTERSECT
SELECT * FROM Agents
WHERE address like '%American%'

-- b in

SELECT * FROM Agents
WHERE agent_id IN (SELECT agent_id FROM Agents WHERE (agent_id > 400 AND agent_id < 425) OR agent_id = 666)

SELECT * FROM Agents
WHERE address IN ( '4405 American Way','309 American Ash Parkway' )

-- c exept

SELECT * FROM TenantContracts
WHERE rent > 400 AND duration_in_months > 34
EXCEPT
SELECT * FROM TenantContracts
WHERE starting_date < '2019/1/1'

SELECT * FROM Properties
WHERE bought_for > 130000
EXCEPT
SELECT * FROM Properties
WHERE current_price > 135000 OR current_price < bought_for

-- c not in
SELECT * FROM TenantContracts
WHERE duration_in_months NOT IN (1,2,3,4,5,6,7,8,9,10,15,16,17,18,19,20)
ORDER BY duration_in_months

SELECT * FROM Properties
WHERE property_id NOT IN (1,2,3,4,5,6,7,8,9,10,15,16,17,18,19,20)
ORDER BY property_id

-- d

-- returns every property which has tenant 
SELECT * FROM Properties
INNER JOIN TenantContracts ON TenantContracts.property_id = Properties.property_id

-- all items for properties, repeated fot the ones which has multiple items
SELECT * FROM ItemsAtProperty
RIGHT JOIN Properties ON ItemsAtProperty.property_id = Properties.property_id

--all properties, repeated for the ones which has more tenants
SELECT * FROM Properties
LEFT JOIN TenantContracts ON TenantContracts.property_id = Properties.property_id

--all properties and tenantContracts, with every combination
SELECT * FROM Properties
FULL JOIN TenantContracts ON TenantContracts.property_id = Properties.property_id

-- e

-- list every tenant which has a rent greater than 499
SELECT * FROM Tenants
WHERE tenant_id in (SELECT tenant_id from TenantContracts where rent > 499)

-- list all the companies for which the property was bought by the agency for more than 145000
SELECT * FROM Companies
WHERE company_id in (
	SELECT company_id from CompanyContracts WHERE property_id in (
		SELECT property_id FROM Properties WHERE bought_for > 145000
	)
)

-- f

SELECT * FROM TenantContracts
WHERE EXISTS (SELECT * FROM Tenants WHERE TenantContracts.tenant_id = Tenants.tenant_id AND Tenants.first_name = 'Marlin')

SELECT * FROM AgentProperties
WHERE EXISTS (SELECT * FROM Properties WHERE AgentProperties.property_id = Properties.property_id AND Properties.bought_for > 145000)

-- g

SELECT * FROM (SELECT property_id, current_price - bought_for AS profit FROM Properties) AS ProfitTable ORDER BY profit DESC

SELECT * FROM (SELECT contract_id, rent*duration_in_months AS total_rent FROM TenantContracts) AS TotalRentTable ORDER BY total_Rent DESC

-- h

SELECT COUNT(property_id) AS number_of_items, property_id
FROM ItemsAtProperty
GROUP BY property_id
HAVING COUNT(property_id) > 5
ORDER BY COUNT(property_id) DESC

SELECT SUM(value) AS total_value_of_items, property_id
FROM ItemsAtProperty
GROUP BY property_id
HAVING SUM(value) > 500
ORDER BY SUM(value)DESC

SELECT COUNT(tenant_id) AS total_tenant_number, property_id
FROM TenantContracts
GROUP BY property_id
ORDER BY COUNT(tenant_id) DESC

SELECT MAX(tenant_id) AS max_tenant_rent, property_id
FROM TenantContracts
GROUP BY property_id
HAVING COUNT(property_id) > 1


-- i

--select all properties where id greater than any property 
-- id which contains American in address

SELECT TOP 10 * FROM Properties
WHERE property_id > ANY(
SELECT property_id FROM Properties
WHERE address like '%American%'
)
ORDER BY property_id

--with min

SELECT TOP 10 * FROM Properties
WHERE property_id > (SELECT MIN(property_id) FROM Properties
WHERE address like '%American%'
)
ORDER BY property_id

--check, the 3rd element contains American so every property with id>3 will be 
-- returned
SELECT * FROM Properties

-- select all items where the price is different than every price of Alarm clock or Magnet
SELECT * FROM ItemsAtProperty
WHERE value <> ALL(
SELECT value FROM ItemsAtProperty
WHERE name = 'Alarm clock' or name = 'Magnets'
GROUP BY value)
ORDER BY value

-- with not in

SELECT * FROM ItemsAtProperty
WHERE value NOT IN (SELECT value FROM ItemsAtProperty
WHERE name = 'Alarm clock' or name = 'Magnets'
GROUP BY value)
ORDER BY value

--select all properties where id greater than all property ids which contains American in nap

SELECT * FROM Properties
WHERE property_id > ALL(
SELECT property_id FROM Properties
WHERE address like '%American%'
)
ORDER BY property_id

-- with max

SELECT * FROM Properties
WHERE property_id > (
SELECT MAX(property_id) FROM Properties
WHERE address like '%American%'
)
ORDER BY property_id

-- select all items where the price is same with any price of an Alarm clock or Magnet
SELECT * FROM ItemsAtProperty
WHERE value = ANY(
SELECT value FROM ItemsAtProperty
WHERE name = 'Alarm clock' or name = 'Magnets'
GROUP BY value)
ORDER BY value

-- with in

SELECT * FROM ItemsAtProperty
WHERE value IN (
SELECT value FROM ItemsAtProperty
WHERE name = 'Alarm clock' or name = 'Magnets'
GROUP BY value)
ORDER BY value

