-----Problem 01-----
CREATE TABLE Passports(
	PassportID INT IDENTITY(101, 1) NOT NULL,
	PassportNumber VARCHAR(20) NOT NULL

	CONSTRAINT PK_ID PRIMARY KEY(PassportId)
)

CREATE TABLE Persons(
	PersonId INT IDENTITY NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	Salary DECIMAL(15,2) NOT NULL,
	PassportID INT  UNIQUE NOT NULL

	CONSTRAINT FK_Persons_PassportID 
	FOREIGN KEY(PassportID) 
	REFERENCES Passports(PassportID)
)

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons_ID PRIMARY KEY(PersonId)

INSERT INTO Passports(PassportNumber) VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons(FirstName, Salary, PassportID) VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)

-----Problem 02-----
CREATE TABLE Manufacturers(
	ManufacturerID INT IDENTITY NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	EstablishedOn DATE NOT NULL

	CONSTRAINT PK_Manufacturers PRIMARY KEY(ManufacturerID)
)

CREATE TABLE Models(
	ModelID INT IDENTITY(101,1) NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	ManufacturerID INT NOT NULL

	CONSTRAINT PK_Models PRIMARY KEY(ModelID)

	CONSTRAINT FK_Models_Manufacturers
	FOREIGN KEY(ManufacturerID)
	REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers([Name], EstablishedOn) VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/01/1966')

INSERT INTO Models([Name], ManufacturerID) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

-----Problem 03-----
CREATE TABLE Students(
	StudentID INT IDENTITY NOT NULL,
	[Name] VARCHAR(30) NOT NULL

	CONSTRAINT PK_Students PRIMARY KEY(StudentID)
)

CREATE TABLE Exams(
	ExamID INT IDENTITY(101,1) NOT NULL,
	[Name] VARCHAR(30) NOT NULL

	CONSTRAINT PK_Exams PRIMARY KEY(ExamID)
)

CREATE TABLE StudentsExams(
	StudentID INT NOT NULL,
	ExamID INT NOT NULL

	CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID)

	CONSTRAINT FK_StudentsExams_Students 
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_StudentsExams_Exams
	FOREIGN KEY(ExamID)
	REFERENCES Exams(ExamID)
)

INSERT INTO Students([Name]) VALUES
('Mila'),
('Toni'),
('Ron')

INSERT INTO Exams([Name]) VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID) VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

-----Problem 04-----
CREATE TABLE Teachers(
	TeacherID INT IDENTITY(101,1) NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	ManagerID INT

	CONSTRAINT PK_Teachers PRIMARY KEY(TeacherID)

	CONSTRAINT FK_Teachers
	FOREIGN KEY(ManagerID)
	REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers([Name], ManagerID)VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

-----Problem 05-----
CREATE TABLE Cities(
	CityID INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL

	CONSTRAINT PK_Cities PRIMARY KEY(CityID)
)

CREATE TABLE Customers(
	CustomerID INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Birthday DATE,
	CityID INT NOT NULL

	CONSTRAINT PK_Customers PRIMARY KEY(CustomerID)

	CONSTRAINT FK_Customers_Cities
	FOREIGN KEY(CityID)
	REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
	OrderID INT IDENTITY NOT NULL,
	CustomerID INT NOT NULL

	CONSTRAINT PK_Orders PRIMARY KEY(OrderID)

	CONSTRAINT FK_Orders_Customers
	FOREIGN KEY(CustomerID)
	REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
	ItemTypeID INT IDENTITY NOT NULL,
	[Name] VARCHAR(50)

	CONSTRAINT PK_ItemTypes PRIMARY KEY(ItemTypeID)
)

CREATE TABLE Items(
	ItemID INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT NOT NULL

	CONSTRAINT PK_Items PRIMARY KEY(ItemID)

	CONSTRAINT FK_Items_ItemTypes
	FOREIGN KEY(ItemTypeID)
	REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems(
	OrderID INT NOT NULL,
	ItemID INT NOT NULL

	CONSTRAINT PK_OrderItems PRIMARY KEY(OrderID,ItemID)

	CONSTRAINT FK_OrderItems_Orders
	FOREIGN KEY(OrderID)
	REFERENCES Orders(OrderID),

	
	CONSTRAINT FK_OrderItems_Items
	FOREIGN KEY(ItemID)
	REFERENCES Items(ItemID)
)

-----Problem 06-----
CREATE TABLE Majors(
	MajorID INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL

	CONSTRAINT PK_Majors PRIMARY KEY(MajorID)
)

CREATE TABLE Students(
	StudentID INT IDENTITY NOT NULL,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT NOT NULL

	CONSTRAINT PK_Students PRIMARY KEY(StudentID)

	CONSTRAINT FK_Students_Majors
	FOREIGN KEY(MajorID)
	REFERENCES Majors(MajorID)
)

CREATE TABLE Payments(
	PaymentID INT IDENTITY NOT NULL,
	PymentDate DATE NOT NULL,
	PaymentAmmount DECIMAL(15,2) NOT NULL,
	StudentID INT NOT NULL

	CONSTRAINT PK_Payments PRIMARY KEY(PaymentID)

	CONSTRAINT FK_Students_Payments
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
	SubjectID INT IDENTITY NOT NULL,
	SubjectName VARCHAR(50) NOT NULL

	CONSTRAINT PK_Subjects PRIMARY KEY(SubjectID)
)

CREATE TABLE Agenda(
	StudentID INT NOT NULL,
	SubjectID INT NOT NULL

	CONSTRAINT PK_Agenda PRIMARY KEY(StudentID, SubjectID)

	CONSTRAINT FK_Students_Agenda
	FOREIGN KEY(StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_Subjects_Agenda
	FOREIGN KEY(SubjectID)
	REFERENCES Subjects(SubjectID)
)

-----Problem 09-----
SELECT M.MountainRange,
       P.PeakName,
	   P.Elevation 
  FROM Peaks AS P
INNER JOIN Mountains AS M
        ON M.Id = P.MountainId
 WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC