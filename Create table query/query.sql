USE master;
GO
USE PropertyRentalAgencyBeta
GO
/*DROP DATABASE if exists PropertyRentalAgencyBeta
go
CREATE DATABASE PropertyRentalAgencyBeta
GO
*/


DROP TABLE IF EXISTS TenantContracts;
DROP TABLE IF EXISTS CompanyContracts;
DROP TABLE IF EXISTS AgentProperties;
DROP TABLE IF EXISTS Agents;
DROP TABLE IF EXISTS Utilities;
DROP TABLE IF EXISTS Maintenance;
DROP TABLE IF EXISTS Companies;
DROP TABLE IF EXISTS Tenants;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS ItemsAtProperty;

CREATE TABLE Properties(
	property_id INT PRIMARY KEY,
	address VARCHAR(100),
	area_size INT,
	bought_for INT,
	current_price INT,
	status VARCHAR(50)
)



CREATE TABLE Tenants(
	tenant_id INT PRIMARY KEY,
	ssn VARCHAR(20),
	birth_date DATE,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	phone_number VARCHAR(15)	
)

CREATE TABLE Companies(
	company_id INT PRIMARY KEY,
	company_name VARCHAR(30),
	company_uid VARCHAR(15),
	contact_first_name VARCHAR(20),
	contact_last_name VARCHAR(20),
	contact_phone_number VARCHAR(15)
)

CREATE TABLE TenantContracts(
	contract_id INT PRIMARY KEY,
	property_id INT FOREIGN KEY REFERENCES Properties(property_id),
	rent INT NOT NULL,
	starting_date DATE NOT NULL,
	duration_in_months INT,
	tenant_id INT FOREIGN KEY REFERENCES Tenants(tenant_id)
)

CREATE TABLE CompanyContracts(
	contract_id INT PRIMARY KEY,
	property_id INT FOREIGN KEY REFERENCES Properties(property_id),
	rent INT NOT NULL,
	starting_date DATE NOT NULL,
	duration_in_months INT,
	company_id INT FOREIGN KEY REFERENCES Companies(company_id)
)


CREATE TABLE Agents(
	agent_id INT PRIMARY KEY,
	ssn VARCHAR(20),
	birth_date DATE,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	address VARCHAR(100),
	phone_number VARCHAR(15),
	work_phone_number VARCHAR(15)
)

CREATE TABLE AgentProperties(
	agent_id INT NOT NULL, 
	property_id INT NOT NULL, 
	FOREIGN KEY(agent_id) REFERENCES Agents(agent_id),
	FOREIGN KEY(property_id) REFERENCES Properties(property_id),
	UNIQUE (agent_id, property_id)
)

CREATE TABLE Utilities(
	utilities_id INT PRIMARY KEY,
	property_id INT FOREIGN KEY REFERENCES Properties(property_id),
	paytime DATE,
	water INT,
	heat INT,
	gas INT,
	electricity INT,
	misc INT,
	misc_description VARCHAR(100)
)

CREATE TABLE Maintenance(
	maintenance_id INT PRIMARY KEY,
	property_id INT FOREIGN KEY REFERENCES Properties(property_id),
	maintenance_description VARCHAR(200),
	total_price INT
)

CREATE TABLE ItemsAtProperty(
	item_id INT PRIMARY KEY,
	property_id INT FOREIGN KEY REFERENCES Properties(property_id),
	name VARCHAR(50),
	value INT,
	description VARCHAR(100)
)