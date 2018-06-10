-----Problem 1-----
SELECT e.FirstName,
       e.LastName
  FROM Employees AS e
 WHERE e.FirstName LIKE 'SA%'

-----Problem 2-----
SELECT e.FirstName,
       e.LastName
  FROM Employees AS e
 WHERE e.LastName LIKE '%ei%'

-----Problem 3-----
SELECT e.FirstName
  FROM Employees AS e
 WHERE e.DepartmentID IN (3, 10)
   AND DATEPART(YEAR, e.HireDate) BETWEEN 1995 AND 2005

-----Problem 4-----
SELECT e.FirstName,
       e.LastName
  FROM Employees AS e
 WHERE e.JobTitle NOT LIKE '%engineer%'

-----Problem 5-----
SELECT t.[Name]
  FROM Towns AS t
 WHERE LEN(t.[Name]) IN (5, 6)
ORDER BY t.[Name]

-----Problem 6-----
SELECT *
  FROM Towns AS t
 WHERE t.[Name] LIKE '[MKBE]%'
ORDER BY t.[Name]

-----Problem 7-----
SELECT *
  FROM Towns AS t
 WHERE t.[Name] LIKE '[^RBD]%'
ORDER BY t.[Name]
GO

-----Problem 8-----
CREATE VIEW V_EmployeesHiredAfter2000 
AS
	SELECT e.FirstName,
	       e.LastName
	  FROM Employees AS e
	 WHERE DATEPART(YEAR, e.HireDate) > 2000
GO

-----Problem 9-----
SELECT e.FirstName,
       e.LastName
  FROM Employees AS e
 WHERE LEN(e.LastName) = 5

-----Problem 10-----
SELECT c.CountryName,
       c.IsoCode 
  FROM Countries AS c
 WHERE c.CountryName LIKE '%A%A%A%'
ORDER BY c.IsoCode

-----Problem 11-----
SELECT p.PeakName,
       r.RiverName, 
	   LOWER(CONCAT(p.PeakName,RIGHT(r.RiverName, LEN(r.RiverName) - 1))) AS Mix
  FROM Peaks AS p,
       Rivers AS r 
  WHERE RIGHT(p.PeakName,1) = LEFT(r.RiverName,1)
  ORDER BY Mix

-----Problem 12-----
SELECT TOP(50)
       g.[Name],
	   FORMAT(g.[Start],'yyyy-MM-dd') AS [Start]
  FROM Games AS g
 WHERE DATEPART(YEAR, g.[Start]) IN (2011, 2012)
ORDER BY g.[Start],
         g.[Name]

-----Problem 13-----
SELECT u.Username,
       SUBSTRING(u.Email, CHARINDEX('@', u.Email, 1) + 1, LEN(u.Email) - CHARINDEX('@', u.Email, 1) + 1) AS [Email]
  FROM Users AS u
ORDER BY Email,
         u.Username

-----Problem 14-----
SELECT u.Username,
       u.IpAddress
  FROM Users AS u
 WHERE u.IpAddress LIKE '___.1%.%.___'
ORDER BY u.Username


-----Problem 15-----
SELECT g.[Name],
       CASE
			WHEN DATEPART(HOUR, g.[Start]) >=0 AND DATEPART(HOUR, g.[Start]) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, g.[Start]) >=12 AND DATEPART(HOUR, g.[Start]) < 18 THEN 'Afternoon'
			WHEN DATEPART(HOUR, g.[Start]) >=18 AND DATEPART(HOUR, g.[Start]) < 24 THEN 'Evening'
	   END AS [Part of the Day],
	   CASE
			WHEN g.Duration <= 3 THEN 'Extra Short'
			WHEN g.Duration BETWEEN 4 AND 6 THEN 'Short'
			WHEN g.Duration > 6 THEN 'Long'
			WHEN g.Duration IS NULL THEN 'Extra Long'
	   END AS [Duration]
  FROM Games AS g
ORDER BY g.[Name],
         [Duration],
		 [Part of the Day]

-----Problem 16-----
SELECT o.ProductName,
       o.OrderDate,
	   DATEADD(DAY, 3, o.OrderDate) AS [Pay Due],
	   DATEADD(MONTH, 1, o.OrderDate) AS [Deliver Due]
  FROM Orders AS o
