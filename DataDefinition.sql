-----Problem 4. Insert Records in Both Tables-----

CREATE DATABASE Minions

USE MInions

CREATE TABLE Minions(
	Id INT NOT NULL,
	[Name] NVARCHAR(50),
	Age INT,
	CONSTRAINT PK_Minions_Id PRIMARY KEY (Id)
)

CREATE TABLE Towns(
	Id INT NOT NULL,
	[Name] NVARCHAR(50),
	CONSTRAINT PK_Towns_Id PRIMARY KEY (Id)
)

ALTER TABLE Minions
ADD TownId INT NOT NULL

ALTER TABLE Minions
ADD CONSTRAINT FK_TownId
FOREIGN KEY (TownId) REFERENCES Towns(Id)

INSERT INTO Towns(Id, [Name]) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions(Id, [Name], Age, TownId) VALUES
(1, 'Kevin',22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

-----Problem 7. Create Table People-----

TRUNCATE TABLE Minions

DROP TABLE Minions

DROP TABLE Towns

CREATE TABLE People(
	Id INT IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(Max),
	Height DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	Gender CHAR(1) CHECK([Gender] IN ('m','f')) NOT NULL,
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX),
	CONSTRAINT PK_Id PRIMARY KEY(Id)
)

ALTER TABLE People
ADD CONSTRAINT CH_PictureSize
CHECK(DATALENGTH(Picture) <= 2 * 1024 * 1024)

INSERT INTO People([Name], Picture, Height, [Weight], Gender, Birthdate, Biography) VALUES
('Georgi', NULL, 1.80, 84.00, 'm', '04-04-1993',NULL),
('Daniel', NULL, 1.85, 73.00, 'm', '04-12-1993',NULL),
('Georgi', NULL, 1.75, 84.00, 'm', '04-04-1994',NULL),
('Ivaylo', NULL, 1.80, 90.00, 'm', '04-04-1986',NULL),
('Yavor', NULL, 1.90, 80.00, 'm', '05-05-1982',NULL)

-----Problem 8. Create Table Users-----

CREATE TABLE Users(
	Id INT IDENTITY NOT NULL,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(900),
	LastLoginTime TIME,
	IsDeleted BIT,
	CONSTRAINT PK_Id PRIMARY KEY(Id)
)

INSERT INTO Users(Username, [Password], ProfilePicture,LastLoginTime,IsDeleted) VALUES
('popov937', '12345', NULL, '2017-04-04', 'false'),
('daniel123', 'd12345', NULL, '2016-04-05', 'true'),
('chereshkata13', 'batkata234', NULL, '2012-07-14', 'false'),
('georgi777', '11111111', NULL, '2011-04-11', 'true'),
('Pesho09', 'MasterPesho', NULL, '2017-05-02', 'false')

-----Problem 13. Movies Database-----

ALTER TABLE Users
DROP CONSTRAINT PK_Id

ALTER TABLE Users
ADD CONSTRAINT PK_UsernameId
PRIMARY KEY(Id, Username)

ALTER TABLE Users
ADD CONSTRAINT CH_Password
CHECK(DATALENGTH(Password) >= 5)

ALTER TABLE Users
ADD DEFAULT GETDATE()
FOR LastLoginTime

ALTER TABLE Users
DROP CONSTRAINT PK_UsernameId

ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CH_Username
CHECK(DATALENGTH(Username) >= 3)

CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors(
	Id INT IDENTITY NOT NULL,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_DirectorId PRIMARY KEY(Id)
)

CREATE TABLE Genres(
	Id INT IDENTITY NOT NULL,
	GenreName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_GenreId PRIMARY KEY(Id)
)

CREATE TABLE Categories(
	Id INT IDENTITY NOT NULL,
	CategoryName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
	CONSTRAINT PK_CategoryId PRIMARY KEY(Id)
)

CREATE TABLE Movies(
	Id INT IDENTITY NOT NULL,
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT NOT NULL,
	CopyrightYear SMALLDATETIME,
	[Length] TIME NOT NULL,
	GenreId INT NOT NULL,
	CategoryId INT NOT NULL,
	Rating INT,
	Notes NVARCHAR(MAX)
	CONSTRAINT FK_Director FOREIGN KEY(DirectorId) REFERENCES Directors(Id),
	CONSTRAINT FK_Genre FOREIGN KEY(GenreId) REFERENCES Genres(Id),
	CONSTRAINT FK_Category FOREIGN KEY(CategoryId) REFERENCES Categories(Id) 
)

INSERT INTO Directors(DirectorName,Notes) VALUES
('Georgi','Not a big deal.'),
('Stamat', 'He has slept with every actress younger than 30.'),
('Pesho', 'He is the eternal student in SoftUni. Anyway, do not mess with Pesho. He is professional movie maker.'),
('Ivan', NULL),
('Mitko', 'Just a regulat student')

INSERT INTO Genres(GenreName,Notes) VALUES
('Action', NULL),
('Comedy','Something like trying to beat the Judge system in SoftUni.'),
('Horror', 'Solving software problems.'),
('Thriller', NULL),
('Fantasy', NULL)

INSERT INTO Categories(CategoryName, Notes) VALUES
('Races', NULL),
('Eduration', NULL),
('RPG', NULL),
('Some category', NULL),
('Classic', NULL)


INSERT INTO Movies(Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes) VALUES
('Learning SQL', 1, '2018', '06:59:59', 2, 2, 10, 'Best seller.'),
('Taking a OOP Advanced exam', 2, '2018', '06:00:00', 3, 2, 9, 'Taken as well.'),
('Hansel and Gretel - Witch hunters', 3, '2016', '02:13:45', 3, 3, 5, NULL),
('Riddick', 4, '2015', '02:30:12', 5, 5, 4, NULL),
('Some movie', 5, '2017', '01:45:00', 4, 4, 100, NULL)

-----Problem 14. Car Rental Database-----

CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories(
	Id INT IDENTITY NOT NULL,
	CategoryName NVARCHAR(50) NOT NULL,
	DailyRate DECIMAL(15,2),
	WeeklyRate DECIMAL(15,2),
	MonthlyRate DECIMAL(15,2),
	WeekendRate DECIMAL(15,2),

	CONSTRAINT PK_CategoryId PRIMARY KEY(Id)
);

ALTER TABLE Categories
ADD CONSTRAINT CH_AtleastOneRate
CHECK (DailyRate IS NOT NULL OR
	   WeeklyRate IS NOT NULL OR
	   MonthlyRate IS NOT NULL OR
	   WeekendRate IS NOT NULL);

CREATE TABLE Cars(
	Id INT IDENTITY NOT NULL,
	PlateNumber NVARCHAR(20) NOT NULL,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	CarYear SMALLDATETIME NOT NULL,
	CategoryId INT NOT NULL,
	Doors INT NOT NULL,
	Picture VARBINARY(MAX),
	Condition NVARCHAR(MAX) NOT NULL,
	Available BIT NOT NULL

	CONSTRAINT PK_CarId PRIMARY KEY(Id),
	CONSTRAINT FK_Category FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);

CREATE TABLE Employees(
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(50),
	Notes NVARCHAR(MAX),

	CONSTRAINT PK_EmployeeId PRIMARY KEY(Id)
 );

CREATE TABLE Customers(
	Id INT IDENTITY NOT NULL,
	DriverLicenceNumber INT NOT NULL,
	FullName NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(MAX) NOT NULL,
	City NVARCHAR(30) NOT NULL,
	ZIPCode INT,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_CustomerId PRIMARY KEY(Id)
 );

CREATE TABLE RentalOrders(
	Id INT IDENTITY NOT NULL,
	EmployeeId INT NOT NULL,
	CustomerId INT NOT NULL,
	CarId INT NOT NULL,
	TankLevel DECIMAL(15,2) NOT NULL,
	KilometrageStart DECIMAL(15,2) NOT NULL,
	KilometrageEnd DECIMAL(15,2) NOT NULL,
	TotalKilometrage DECIMAL(15,2) NOT NULL,
	StartDate SMALLDATETIME NOT NULL,
	EndDate SMALLDATETIME NOT NULL,
	TotalDays INT NOT NULL,
	RateApplied DECIMAL(15,2) NOT NULL,
	TaxRate DECIMAL(15,2) NOT NULL,
	OrderStatus NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
 )

 ALTER TABLE RentalOrders
 ADD CONSTRAINT PK_RentalOrderId PRIMARY KEY(Id)
 
 ALTER TABLE RentalOrders
 ADD CONSTRAINT FK_Employee FOREIGN KEY(EmployeeId) REFERENCES Employees(Id)

 ALTER TABLE RentalOrders
 ADD CONSTRAINT FK_CustomerId FOREIGN KEY(CustomerId) REFERENCES Customers(Id)

 ALTER TABLE RentalOrders
 ADD CONSTRAINT FK_Car FOREIGN KEY(CarId) REFERENCES Cars(Id)

 INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
 ('Sport', 5, 25, 140, 40),
 ('Casula', 4, 20, 130, 30),
 ('Retro', 10, 50, 200, 80)

 INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available) VALUES
 ('X4122BH', 'Opel', 'Astra', 2000, 2, 4, NULL, 'used', 'true'),
 ('CA2222AA', 'Mercedes', 'S 65 AMG', 2017, 1, 4, NULL, 'new', 'true'),
 ('PB5521MT', 'VW', 'Passat', 1993, 3, 4, NULL, 'used', 'true')

 INSERT INTO Employees(FirstName, LastName, Title, Notes) VALUES
 ('Georgi', 'Popov', NULL, NULL),
 ('Pesho', 'Peshev', NULL, NULL),
 ('Ivan', 'Ivanov', NULL, NULL)

 INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes) VALUES
 (111222, 'Bai Stavri', 'Orfei', 'Haskovo', 6300, NULL),
 (222333, 'Stamat Stamatov', 'Bolyarovo', 'Haskovo', 6300, NULL),
 (333444, 'Dimitar Mitev', 'Mladost', 'Sofia', 1000, NULL)

 INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage,
						  StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes) VALUES
(1, 1, 2, 100, 1200, 1400, 1400, '01-01-2017', '01-10-2017', 10, 200, 1200, 'ACTIVE', NULL),
(2, 2, 1, 65, 230000, 231000, 231000, '03-03-2017', '03-23-2017', 20, 500, 400, 'ACTIVE', NULL),
(3, 3, 3, 80, 300000, 300001, 300001, '11-12-2017', '12-12-2017', 1, 10, 20, 'ACTIVE', NULL)

-----Problem 15. Hotel Database-----

CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees(
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Tite NVARCHAR(20),
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_EmployeeId PRIMARY KEY(Id)
);

INSERT INTO Employees(FirstName, LastName) VALUES
('Ivan', 'Ivanov'),
('Pesho', 'Peshev'),
('Stamat', 'Stamatov')

CREATE TABLE Customers(
	AccountNumber INT NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName NVARCHAR(20),
	EmergencyNumber INT,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_CustomerAccountNumber PRIMARY KEY(AccountNumber)
);

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber) VALUES
(11111,'Georgi', 'Popov', 0888888888),
(22222,'Dimitar', 'Mitev', 0999999999),
(33333,'Miroslav', 'Georgiev', 0777777777)

CREATE TABLE RoomStatus(
	RoomStatus NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_StatusOfRoom PRIMARY KEY(RoomStatus)
);

INSERT INTO RoomStatus(RoomStatus) VALUES
('Occupied'),
('Not Occupied'),
('Under Construction')

CREATE TABLE RoomTypes(
	RoomType NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_TypeOfRoom PRIMARY KEY(RoomType)
);

INSERT INTO RoomTypes(RoomType) VALUES
('single'),
('for couple'),
('president')

CREATE TABLE BedTypes(
	BedType NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_TypeOfBeds PRIMARY KEY(BedType)
);

INSERT INTO BedTypes(BedType) VALUES
('single bed'),
('couple bed'),
('president bed')

CREATE TABLE Rooms(
	RoomNumber INT IDENTITY NOT NULL,
	RoomType NVARCHAR(30) NOT NULL,
	BedType NVARCHAR(30) NOT NULL,
	Rate DECIMAL(15,2) NOT NULL,
	RoomStatus NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_RoomNum PRIMARY KEY(RoomNumber),
	CONSTRAINT FK_RType FOREIGN KEY(RoomType) REFERENCES RoomTypes(RoomType),
	CONSTRAINT FK_BType FOREIGN KEY(BedType) REFERENCES BedTypes(BedType)
);

INSERT INTO Rooms(RoomType, BedType, Rate, RoomStatus) VALUES
('single', 'single bed', 4.5, 'Occupied'),
('for couple', 'couple bed', 5.00, 'Under Construction'),
('president', 'president bed', 3.4, 'Not Occupied')

CREATE TABLE Payments(
	Id INT IDENTITY NOT NULL,
	EmployeeId INT NOT NULL,
	PaymentDate SMALLDATETIME NOT NULL,
	AccountNumber INT NOT NULL,
	FirstDateOccupied SMALLDATETIME NOT NULL,
	LastDateOccupied SMALLDATETIME NOT NULL,
	TotalDays INT NOT NULL,
	AmmountCharged DECIMAL(15,2) NOT NULL,
	TaxRate DECIMAL(15,2) NOT NULL,
	TaxAmmount DECIMAL(15,2) NOT NULL,
	PaymentTotal DECIMAL(15,2) NOT NULL,
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_PaymentId PRIMARY KEY(Id),
	CONSTRAINT FK_Employee FOREIGN KEY(EmployeeId) REFERENCES Employees(Id),
	CONSTRAINT FK_AC_Number FOREIGN KEY(AccountNumber) REFERENCES Customers(AccountNumber)
);

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmmountCharged,
					 TaxRate, TaxAmmount, PaymentTotal) VALUES
(1, '01-01-2017', 11111, '01-01-2017', '03-01-2017', 2, 200, 50, 20, 270),
(2, '02-02-2017', 22222, '02-02-2017', '10-02-2017', 8, 1000, 100, 200, 1300),
(3, '03-03-2017', 33333, '03-03-2017', '12-03-2017', 10, 1200, 120, 400, 1720)

CREATE TABLE Occupancies(
	Id INT IDENTITY NOT NULL,
	EmployeeId INT NOT NULL,
	DateOccupied SMALLDATETIME NOT NULL,
	AccountNumber INT NOT NULL,
	RoomNumber INT NOT NULL,
	RateApplied DECIMAL(15,2) NOT NULL,
	PhoneCharge DECIMAL(15,2),
	Notes NVARCHAR(MAX)

	CONSTRAINT PK_OccId PRIMARY KEY(Id),
	CONSTRAINT FK_Empl FOREIGN KEY(EmployeeId) REFERENCES Employees(Id),
	CONSTRAINT FK_A_Number FOREIGN KEY(AccountNumber) REFERENCES Customers(AccountNumber),
	CONSTRAINT FK_RNumber FOREIGN KEY(RoomNumber) REFERENCES Rooms(RoomNumber)
);

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied) VALUES
(1, '08-12-2017', 11111, 1, 4.7),
(2, '01-03-2017', 22222, 2, 3.5),
(3, '04-04-2017', 33333, 3, 5.5)

-----Problem 16. Create SoftUni Database-----

CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns(
	Id INT IDENTITY NOT NULL,
	[Name] NVARCHAR(30) NOT NULL

	CONSTRAINT PK_TownId PRIMARY KEY(Id)
);

CREATE TABLE Addresses(
	Id INT IDENTITY NOT NULL,
	[Address] NVARCHAR(MAX) NOT NULL,
	TownId INT NOT NULL

	CONSTRAINT PK_AdressesId PRIMARY KEY(Id)
	CONSTRAINT FK_Town FOREIGN KEY(TownId) REFERENCES Towns(Id)
);

CREATE TABLE Departments(
	Id INT IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_DepartmentId PRIMARY KEY(Id),
);

CREATE TABLE Employees(
	Id INT IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(30),
	LastName NVARCHAR(30) NOT NULL,
	JobTitle NVARCHAR(30) NOT NULL,
	DepartmentId INT NOT NULL,
	HireDate SMALLDATETIME NOT NULL,
	Salary DECIMAL(15,2) NOT NULL,
	AddressId INT NOT NULL

	CONSTRAINT PK_EmployeeId PRIMARY KEY(Id),
	CONSTRAINT FK_Department FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
	CONSTRAINT FK_Address FOREIGN KEY(AddressId) REFERENCES Addresses(Id)
);

ALTER TABLE Employees
ALTER COLUMN AddressId INT

ALTER TABLE Employees
ALTER COLUMN HireDate DATE

INSERT INTO Towns([Name]) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments([Name]) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, CONVERT(DATE,'01/02/2013',103), 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, CONVERT(DATE,'02/03/2004',103), 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, CONVERT(DATE,'28/08/2016', 103), 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, CONVERT(DATE,'09/12/2007', 103), 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, CONVERT(DATE,'28/08/2016',103), 599.88)

SELECT * FROM Towns ORDER BY [Name]

SELECT * FROM Departments ORDER BY [Name]

SELECT * FROM Employees ORDER BY Salary DESC

SELECT Name FROM Towns ORDER BY [Name]

SELECT Name FROM Departments ORDER BY [Name]

SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

UPDATE Employees
SET Salary += (Salary * 0.10)

SELECT Salary FROM Employees

USE Hotel

UPDATE Payments
SET TaxRate -= (TaxRate * 0.03)

SELECT TaxRate FROM Payments

TRUNCATE TABLE Occupancies

