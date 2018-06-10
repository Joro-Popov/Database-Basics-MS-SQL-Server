-----Problem 2-----
SELECT *
  FROM Departments AS d

-----Problem 3-----
SELECT d.[Name]
  FROM Departments AS d

-----Problem 4-----
SELECT e.FirstName,
       e.LastName,
	   e.Salary
  FROM Employees AS e

-----Problem 5-----
SELECT e.FirstName,
       e.MiddleName,
       e.LastName
  FROM Employees AS e

-----Problem 6-----
SELECT CONCAT(e.FirstName, '.', e.LastName, '@softuni.bg') AS [Full Email Address]
  FROM Employees AS e

-----Problem 7-----
SELECT DISTINCT e.Salary
  FROM Employees AS e

-----Problem 8-----
SELECT *
  FROM Employees AS e
 WHERE e.JobTitle = 'Sales Representative'

-----Problem 9-----
SELECT e.FirstName,
       e.LastName,
	   e.JobTitle
  FROM Employees AS e 
 WHERE e.Salary BETWEEN 20000 AND 30000 

-----Problem 10-----
SELECT CONCAT(e.FirstName, ' ', e.MiddleName, ' ', e.LastName) AS [Full Name]
  FROM Employees AS e
 WHERE e.Salary IN (25000, 14000, 12500, 23600)

-----Problem 11-----
SELECT e.FirstName,
       e.LastName 
  FROM Employees AS e
 WHERE e.ManagerID IS NULL

-----Problem 12-----
SELECT e.FirstName,
       e.LastName,
	   e.Salary
  FROM Employees AS e
 WHERE e.Salary > 50000
ORDER BY e.Salary DESC

-----Problem 13-----
SELECT TOP (5) 
       e.FirstName,
       e.LastName
  FROM Employees AS e
ORDER BY e.Salary DESC

-----Problem 14-----
SELECT e.FirstName,
       e.LastName
  FROM Employees AS e
 WHERE e.DepartmentID <> 4

-----Problem 15-----
SELECT *
  FROM Employees AS e
ORDER BY e.Salary DESC,
         e.FirstName,
		 e.LastName DESC,
		 e.MiddleName

-----Problem 16-----
GO
CREATE VIEW v_EmployeesSalaries 
AS
	SELECT e.FirstName,
		   e.LastName,
		   e.Salary
	  FROM Employees AS e

-----Problem 17-----
GO
CREATE VIEW V_EmployeeNameJobTitle 
AS
	SELECT CONCAT(e.FirstName, ' ', ISNULL(e.MiddleName,''), ' ', e.LastName) AS [Full Name],
		   e.JobTitle AS [Job Title]
	  FROM Employees AS e
GO
-----Problem 18-----
SELECT DISTINCT e.JobTitle
  FROM Employees AS e

-----Problem 19-----
SELECT TOP (10) *
  FROM Projects AS p
ORDER BY p.StartDate,
         p.[Name]

-----Problem 20-----
SELECT TOP(7) 
       e.FirstName,
       e.LastName,
	   e.HireDate
  FROM Employees AS e
ORDER BY e.HireDate DESC

-----Problem 21-----
UPDATE Employees
   SET Salary *= 1.12
FROM Employees AS e
INNER JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
WHERE d.[Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')

SELECT e.Salary
  FROM Employees AS e

-----Problem 22-----
SELECT p.PeakName
  FROM Peaks AS p
ORDER BY p.PeakName

-----Problem 23-----
SELECT TOP (30)
       c.CountryName,
	   c.[Population] 
  FROM Countries AS c
 WHERE c.ContinentCode = 'EU'
ORDER BY c.[Population] DESC,
         c.CountryName

-----Problem 24-----
SELECT c.CountryName,
       c.CountryCode,
	   CASE
			WHEN c.CurrencyCode = 'EUR' THEN 'Euro'
			ELSE 'Not Euro'
	   END
  FROM Countries AS c
ORDER BY c.CountryName

-----Problem 25-----
SELECT c.[Name] 
  FROM Characters AS c
ORDER BY c.[Name]