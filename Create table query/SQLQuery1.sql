USE master;
GO
DROP DATABASE PropertyRentalAgencyBeta
go
CREATE DATABASE PropertyRentalAgencyBeta
GO
USE PropertyRentalAgencyBeta
GO


CREATE TABLE Addresses(
	address_id INT PRIMARY KEY,
	country VARCHAR(50),
	county VARCHAR(50),
	city VARCHAR(50),
	street VARCHAR(50),
	number VARCHAR(10),
	postal_code VARCHAR(10),
	optional VARCHAR(100)
)

CREATE TABLE PersonalInformation(
	personal_information_id INT PRIMARY KEY,
	ssn VARCHAR(20),
	birth_date DATE,
	first_name VARCHAR(20),
	middle_name VARCHAR(40),
	last_name VARCHAR(20),
	phone_number VARCHAR(15)
)

CREATE TABLE Properties(
	property_id INT PRIMARY KEY,
	address_id INT FOREIGN KEY REFERENCES Addresses(address_id),
	area_size INT,
	bought_for INT,
	current_price INT,
	status VARCHAR(50)
)

CREATE TABLE Agents(
	agent_id INT PRIMARY KEY,
	personal_information_id INT FOREIGN KEY REFERENCES PersonalInformation(personal_information_id),
	home_address_id INT FOREIGN KEY REFERENCES Addresses(address_id),
	work_phone_number VARCHAR(15)
)

CREATE TABLE AgentProperties(
	agent_id INT NOT NULL, 
	property_id INT NOT NULL, 
	FOREIGN KEY(agent_id) REFERENCES Agents(agent_id),
	FOREIGN KEY(property_id) REFERENCES Properties(property_id),
	UNIQUE (agent_id, property_id)
)


CREATE TABLE Tenants(
	tenant_id INT PRIMARY KEY,
	personal_information_id INT FOREIGN KEY REFERENCES PersonalInformation(personal_information_id),
	work_address_id INT FOREIGN KEY REFERENCES Addresses(address_id),
	work_phone_number VARCHAR(15)
)

CREATE TABLE Companies(
	company_id INT PRIMARY KEY,
	company_uid VARCHAR(15),
	main_corp_address_id INT FOREIGN KEY REFERENCES Addresses(Address_id),
	contact_information_id INT FOREIGN KEY REFERENCES PersonalInformation(personal_information_id)
)


CREATE TABLE Contracts(
	contract_id INT PRIMARY KEY,
	rent INT NOT NULL,
	starting_date DATE NOT NULL,
	duration_in_months INT,
	tenant_id INT FOREIGN KEY REFERENCES Tenants(tenant_id),
	company_id INT FOREIGN KEY REFERENCES Companies(company_id),
	property_id INT FOREIGN KEY REFERENCES Properties(porperty_id)
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