-----Problem 01-----
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT E.FirstName,
	       E.LastName
	  FROM Employees AS E
	 WHERE E.Salary > 35000
END
GO
-----Problem 02-----
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber
(
	@SalaryLevel DECIMAL(18,4)
)
AS
BEGIN
	SELECT E.FirstName,
	       E.LastName
	  FROM Employees AS E
	 WHERE E.Salary >= @SalaryLevel
END
GO
-----Problem 03-----
CREATE OR ALTER PROCEDURE usp_GetTownsStartingWith
(
	@TownPrefix VARCHAR(20)
)
AS
BEGIN
	SELECT T.[Name]
	  FROM Towns AS T
	 WHERE T.[Name] LIKE CONCAT(@TownPrefix, '%')
END
GO
-----Problem 04-----
CREATE PROCEDURE usp_GetEmployeesFromTown
(
	@TownName VARCHAR(20)
)
AS
BEGIN
	SELECT E.FirstName,
	       E.LastName 
	  FROM Employees AS E
	 INNER JOIN Addresses AS A
	         ON A.AddressID  = E.AddressID
	 INNER JOIN Towns AS T
	         ON T.TownID = A.TownID
	 WHERE T.[Name] = @TownName
END
GO
-----Problem 05-----
CREATE FUNCTION ufn_GetSalaryLevel
(
	@salary DECIMAL(18,4)
)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10) =

	CASE
		WHEN @salary < 30000 THEN 'Low'
		WHEN @salary BETWEEN 30000 AND 50000 THEN 'Average'
		ELSE 'High'
	END

	RETURN @salaryLevel
END
GO

-----Problem 06-----
CREATE PROCEDURE usp_EmployeesBySalaryLevel
(
	@salaryLevel VARCHAR(10)
)
AS
BEGIN
	SELECT E.FirstName,
	       E.LastName
	  FROM Employees AS E
	 WHERE dbo.ufn_GetSalaryLevel(E.Salary) = @salaryLevel
END
GO
-----Problem 07-----
CREATE FUNCTION ufn_IsWordComprised
(
	@setOfLetters VARCHAR(100),
	@word VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	DECLARE @start INT = 1;
	DECLARE @end INT = LEN(@word);

	WHILE(@start <= @end)
	BEGIN
		DECLARE @currentLetter VARCHAR = SUBSTRING(@word, @start, 1);
		DECLARE @searchedLetterIndex INT = CHARINDEX(@currentLetter, @setofLetters, 1)

		IF(@searchedLetterIndex = 0)
			RETURN 0
		
		SET @start += 1
	END

	RETURN 1
END
GO
-----Problem 08-----
CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment
(
	@departmentId INT
)
AS
BEGIN
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT

	ALTER TABLE Departments 
	NOCHECK CONSTRAINT ALL

	ALTER TABLE Employees
	NOCHECK CONSTRAINT ALL

	ALTER TABLE EmployeesProjects
	NOCHECK CONSTRAINT ALL

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	ALTER TABLE Departments CHECK CONSTRAINT ALL
	ALTER TABLE Employees CHECK CONSTRAINT ALL
	ALTER TABLE EmployeesProjects CHECK CONSTRAINT ALL

	SELECT COUNT(*)
	  FROM Employees AS E
	 WHERE E.DepartmentID = @departmentId
END
GO
-----Problem 09-----
CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(AH.FirstName, ' ', AH.LastName) AS [Full Name]
	  FROM AccountHolders AS AH
END
GO

-----Problem 10-----
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan
(
	@Balance DECIMAL(18,2)
)
AS
BEGIN
	SELECT ah.FirstName,
	       ah.LastName 
	  FROM Accounts AS a
INNER JOIN AccountHolders AS ah
        ON ah.Id = a.AccountHolderId
  GROUP BY ah.FirstName,
           ah.LastName
	HAVING SUM(a.Balance) > @Balance
END
GO
-----Problem 11-----
CREATE FUNCTION ufn_CalculateFutureValue
(
	@sum DECIMAL(15,2),
	@yearlyInterestRate FLOAT,
	@numberOfYears INT
)
RETURNS DECIMAL(15,4)
AS
BEGIN
	DECLARE @futureValue DECIMAL(15,4) = @sum * (POWER((1 + @yearlyInterestRate), @numberOfYears))
	RETURN @futureValue
END
GO

-----Problem 12-----
CREATE PROCEDURE usp_CalculateFutureValueForAccount
(
	@accountId INT,
	@interestRate FLOAT
)
AS
BEGIN
	SELECT A.Id AS [Account Id],
	       AH.FirstName AS [First Name],
		   AH.LastName AS [Last Name],
		   A.Balance AS [Current Balance],
		   dbo.ufn_CalculateFutureValue(A.Balance,0.1, 5) AS [Balance in 5 years] 
	  FROM Accounts AS A
	INNER JOIN AccountHolders AS AH
	        ON AH.Id = A.AccountHolderId
	 WHERE A.Id = @accountId
END
GO

-----Problem 13-----
CREATE FUNCTION ufn_CashInUsersGames
(
	@gameName VARCHAR(30)
)
RETURNS @ResultTable TABLE (SumCash DECIMAL(15,4))
AS
BEGIN
	WITH CTE_OddSums AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY UG.Cash DESC) AS [RowNum],
		       UG.Cash
		  FROM UsersGames AS UG
		INNER JOIN Games AS G
		        ON G.Id = UG.GameId
		 WHERE G.[Name] = @gameName
	)

	INSERT INTO @ResultTable
	SELECT SUM(OS.Cash) AS [SumCash]
	  FROM CTE_OddSums AS OS
	 WHERE OS.RowNum % 2 = 1
	ORDER BY SumCash DESC

	RETURN
END
GO

-----Problem 14-----
CREATE TABLE Logs(
	LogId INT IDENTITY NOT NULL,
	AccountId INT NOT NULL,
	OldSum DECIMAL(15,2) NOT NULL,
	NewSum DECIMAL(15,2) NOT NULL

	CONSTRAINT PK_LogId PRIMARY KEY(LogId),
	CONSTRAINT FK_Logs_Accounts
	FOREIGN KEY(AccountId)
	REFERENCES Accounts(Id)
)
GO

CREATE TRIGGER tr_InsertIntoLogs ON Accounts AFTER UPDATE
AS
BEGIN
	INSERT INTO Logs
	     SELECT I.Id,
	            D.Balance,
	       	    I.Balance
	       FROM inserted AS I
     INNER JOIN deleted AS D
	         ON D.Id = I.Id
END

-----Problem 15-----
CREATE TABLE NotificationEmails(
	Id INT IDENTITY NOT NULL,
	Recipient INT NOT NULL,
	[Subject] VARCHAR(100) NOT NULL,
	BODY VARCHAR(100) NOT NULL

	CONSTRAINT PK_Id PRIMARY KEY(Id)
)
GO
CREATE TRIGGER tr_CreateNewEmail ON Logs AFTER INSERT
AS
BEGIN
	INSERT INTO NotificationEmails
	SELECT I.AccountId,
	       CONCAT('Balance change for account: ', I.AccountId) AS [Subject],
		   CONCAT('On ',GETDATE(), ' your balance was changed from ',I.OldSum, ' to ',I.NewSum,'.') AS [Body]
	  FROM inserted AS I
END
GO

-----Problem 16-----
CREATE PROCEDURE usp_DepositMoney
(
	@AccountId INT, 
	@MoneyAmount DECIMAL(15,4)
)
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Accounts
		   SET Balance += @MoneyAmount
		 WHERE Id = @AccountId

		 IF(@MoneyAmount < 0)
		 BEGIN
			ROLLBACK
		 END
	COMMIT
END
GO

-----Problem 17-----
CREATE PROCEDURE usp_Withdrawmoney
(
	@accoundID INT,
	@moneyAmount DECIMAL(15,4)
)
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Accounts
		   SET Balance -= @moneyAmount
		 WHERE Id = @accoundID

		IF(@moneyAmount < 0)
		BEGIN
			ROLLBACK
		END
	COMMIT
END
GO

-----Problem 18-----
CREATE PROCEDURE usp_TransferMoney
(
	@senderId INT,
	@recieverId INT,
	@amount DECIMAL(15,4)
)
AS
BEGIN
	EXEC usp_Withdrawmoney @senderId, @amount
	EXEC usp_DepositMoney @recieverId, @amount
END
GO

-----Problem 19-----
CREATE TRIGGER tr_ItemLevelRestriction ON UserGameItems AFTER INSERT
AS
BEGIN
	DECLARE @userLevel INT = (
								 SELECT UG.[Level]
								   FROM inserted AS I
								 INNER JOIN UsersGames AS UG
								         ON UG.Id = I.UserGameId
	                         )
	DECLARE @itemLevel INT = (
								 SELECT I.MinLevel
								   FROM inserted AS INS
								INNER JOIN Items AS I
								        ON I.Id = INS.ItemId
	                         )
	IF(@itemLevel > @userLevel)
	BEGIN
		RAISERROR('Low level for this item', 16, 1)
		ROLLBACK
	END									 
END
GO

CREATE OR ALTER VIEW v_UsersInGameBali
AS
SELECT ROW_NUMBER() OVER(ORDER BY UG.UserId) AS [RowNum],
       UG.UserId,
       U.Username,
	   G.[Name],
       UG.Cash
  FROM UsersGames AS UG
INNER JOIN Users AS U
        ON U.Id = UG.UserId
INNER JOIN GAMES AS G
        ON G.Id = UG.GameId
 WHERE G.[Name] = 'Bali'
GO


UPDATE v_UsersInGameBali
   SET Cash += 50000
GO

CREATE PROCEDURE usp_BuyItems
AS
BEGIN
    DECLARE @userCountStart INT = 1;
	DECLARE @userCountEnd INT = (SELECT COUNT(*) FROM v_UsersInGameBali);
	DECLARE @firstGroupStart INT = 251;
	DECLARE @firstGroupEnd INT = 299;
	DECLARE @secondGroupStart INT = 501;
	DECLARE @secondGroupEnd INT = 539;

	WHILE(@userCountStart <= @userCountEnd)
	BEGIN
	    DECLARE @currentUserId INT = (SELECT UserId FROM v_UsersInGameBali WHERE RowNum = @userCountStart);

		WHILE(@firstGroupStart <= @firstGroupEnd)
		BEGIN
			DECLARE @currentItemId INT = @firstGroupStart;
			DECLARE @currentItemPrice DECIMAL(15,2) = (SELECT I.Price FROM Items AS I WHERE I.Id = @currentItemId);

			BEGIN TRANSACTION
				UPDATE v_UsersInGameBali
				   SET Cash -= @currentItemPrice
				 WHERE UserId = @currentUserId

				 DECLARE @currentUserCash DECIMAL(15,2) = (SELECT Cash FROM v_UsersInGameBali WHERE UserId = @currentUserId);

				 IF(@currentUserCash < 0)
				 BEGIN
					RAISERROR('Not enough money', 16,1)
					ROLLBACK
					RETURN
				 END
				 ELSE
				     INSERT INTO UserGameItems VALUES
				     (@currentItemId, @currentUserId)

			COMMIT

			SET @firstGroupStart += 1;
		END

		SET @userCountStart += 1;
	END
END
GO
-----Problem 20-----
DECLARE @gameName nvarchar(50) = 'Safflower'
DECLARE @username nvarchar(50) = 'Stamat'

DECLARE @userGameId int = (
                           SELECT ug.Id 
                           FROM UsersGames AS ug
                           JOIN Users AS u ON ug.UserId = u.Id
                           JOIN Games AS g ON ug.GameId = g.Id
                           WHERE u.Username = @username AND g.Name = @gameName)

DECLARE @userGameLevel int = (SELECT Level FROM UsersGames WHERE Id = @userGameId)
DECLARE @itemsCost money, @availableCash money, @minLevel int, @maxLevel int

SET @minLevel = 11
SET @maxLevel = 12
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId)
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK
    RAISERROR('Could not make payment', 16, 1)
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; 
      RAISERROR('Could not buy items', 16, 1)
    END	
    ELSE COMMIT;
  END
END

SET @minLevel = 19
SET @maxLevel = 21
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId)
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId 

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK
    RAISERROR('Could not make payment', 16, 1)
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK
      RAISERROR('Could not buy items', 16, 1)
    END	
    ELSE COMMIT;
  END
END

SELECT i.Name AS [Item Name]
  FROM UserGameItems AS ugi
  JOIN Items AS i ON i.Id = ugi.ItemId
  JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
  JOIN Games AS g ON g.Id = ug.GameId
 WHERE g.Name = @gameName
 ORDER BY [Item Name]
-----Problem 21-----
CREATE PROCEDURE usp_AssignProject
(
	@emloyeeId INT, 
	@projectID INT
)
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @ProjectsCount INT = (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId);
	DECLARE @maxProjectCount INT = 3;

	IF(@ProjectsCount >= @maxProjectCount)
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1)
		ROLLBACK
		RETURN
	END

	INSERT INTO EmployeesProjects VALUES
	(@emloyeeId, @projectID)
	COMMIT
END

-----Problem 22-----
CREATE TABLE Deleted_Employees(
	EmployeeId INT IDENTITY NOT NULL, 
	FirstName VARCHAR(30) NOT NULL, 
	LastName VARCHAR(30) NOT NULL, 
	MiddleName VARCHAR(30), 
	JobTitle VARCHAR(200), 
	DepartmentId INT, 
	Salary DECIMAL(15,2)

	CONSTRAINT PK_EmployeeId PRIMARY KEY(EmployeeId),
	CONSTRAINT FK_DeletetEmployees_Departments
	FOREIGN KEY(DepartmentId)
	REFERENCES Departments(DepartmentId)
)

GO
CREATE TRIGGER tr_FireEmployee ON Employees AFTER DELETE
AS
BEGIN
	INSERT INTO Deleted_Employees
	SELECT D.FirstName,
		   D.LastName,
		   D.MiddleName,
		   D.JobTitle,
		   D.DepartmentID,
		   D.Salary
	  FROM deleted AS D
END
GO