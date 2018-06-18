-----Problem 01-----
SELECT TOP(5)
       E.EmployeeID,
	   E.JobTitle,
	   E.AddressID,
	   A.AddressText
  FROM Employees AS E
INNER JOIN Addresses AS A
        ON A.AddressID = E.AddressID
ORDER BY E.AddressID

-----Problem 02-----
SELECT TOP(50)
       E.FirstName,
       E.LastName,
	   T.[Name],
	   A.AddressText
  FROM Employees AS E
INNER JOIN Addresses AS A
        ON A.AddressID = E.AddressID
INNER JOIN Towns AS T
        ON T.TownID = A.TownID
ORDER BY E.FirstName,
         E.LastName

-----Problem 03-----
SELECT EMP.EmployeeID,
       EMP.FirstName,
	   EMP.LastName,
	   DEPT.[Name] 
  FROM Employees AS EMP
INNER JOIN Departments AS DEPT
        ON DEPT.DepartmentID = EMP.DepartmentID
		AND DEPT.[Name] = 'Sales'
ORDER BY EMP.EmployeeID 

-----Problem 04-----
SELECT TOP(5)
       EMP.EmployeeID,
       EMP.FirstName,
	   EMP.Salary,
	   DEPT.[Name]
  FROM Employees AS EMP
INNER JOIN Departments AS DEPT
        ON DEPT.DepartmentID = EMP.DepartmentID
 WHERE EMP.Salary > 15000
ORDER BY EMP.DepartmentID

-----Problem 05-----
SELECT TOP(3)
       EMP.EmployeeID,
       EMP.FirstName 
  FROM Employees AS EMP
 WHERE EMP.EmployeeID NOT IN (
								 SELECT EP.EmployeeID
								   FROM EmployeesProjects AS EP
                             )

-----Problem 06-----
SELECT EMP.FirstName,
       EMP.LastName,
	   EMP.HireDate,
	   DEPT.[Name]
  FROM Employees AS EMP
INNER JOIN Departments AS DEPT
        ON DEPT.DepartmentID = EMP.DepartmentID
 WHERE EMP.HireDate > '01-01-1999'
   AND DEPT.[Name] IN ('Sales', 'Finance')
ORDER BY EMP.HireDate

-----Problem 07-----
SELECT TOP(5)
       EP.EmployeeID,
	   EMP.FirstName,
	   PR.[Name] 
  FROM EmployeesProjects AS EP
INNER JOIN Employees AS EMP
        ON EMP.EmployeeID = EP.EmployeeID
INNER JOIN Projects AS PR
        ON PR.ProjectID = EP.ProjectID
 WHERE PR.StartDate > '08.13.2002'
   AND PR.EndDate IS NULL
ORDER BY EP.EmployeeID

-----Problem 08-----
SELECT EP.EmployeeID,
       E.FirstName,
	   IIF(DATEPART(YEAR,P.StartDate) >= 2005,NULL,P.[Name])
  FROM EmployeesProjects AS EP
INNER JOIN Employees AS E
        ON E.EmployeeID  = EP.EmployeeID
INNER JOIN Projects AS P
        ON P.ProjectID = EP.ProjectID 
 WHERE EP.EmployeeID = 24

-----Problem 09-----
SELECT E.EmployeeID,
       E.FirstName,
	   E.ManagerID,
	   MNG.FirstName
  FROM Employees AS E
LEFT OUTER JOIN Employees AS MNG
             ON MNG.EmployeeID = E.ManagerID
 WHERE E.ManagerID IN (3,7)
ORDER BY E.EmployeeID

-----Problem 10-----
SELECT TOP(50)
       E.EmployeeID,
       CONCAT(E.FirstName, ' ', E.LastName) AS [EmployeeName],
	   CONCAT(M.FirstName, ' ', M.LastName) AS [ManagerName],
	   d.[Name]
  FROM Employees AS E
INNER JOIN Employees AS M
        ON M.EmployeeID = E.ManagerID
INNER JOIN Departments AS D
        ON D.DepartmentID = E.DepartmentID
ORDER BY E.EmployeeID

-----Problem 11-----
SELECT MIN(AVGS.AverageSalary)
  FROM
  (
	  SELECT AVG(E.Salary) AS [AverageSalary]
        FROM Departments AS D
LEFT OUTER JOIN Employees AS E
             ON E.DepartmentID = D.DepartmentID
    GROUP BY D.[Name]
  ) AS AVGS

-----Problem 12-----
SELECT C.CountryCode,
       M.MountainRange,
	   P.PeakName,
	   P.Elevation
  FROM MountainsCountries AS MC
INNER JOIN Countries AS C
        ON C.CountryCode = MC.CountryCode
INNER JOIN Mountains AS M
        ON M.Id = MC.MountainId
INNER JOIN Peaks AS P
        ON P.MountainId = MC.MountainId
 WHERE MC.CountryCode = 'BG'
   AND P.Elevation > 2835
ORDER BY P.Elevation DESC

-----Problem 13-----
SELECT MC.CountryCode,
       COUNT(MC.MountainId) AS [MountainRanges] 
  FROM MountainsCountries AS MC
GROUP BY MC.CountryCode
 HAVING MC.CountryCode IN ('US', 'BG', 'RU')

-----Problem 14-----
SELECT TOP(5)
       C.CountryName,
	   R.RiverName
  FROM Countries AS C
LEFT OUTER JOIN CountriesRivers AS CR
             ON CR.CountryCode = C.CountryCode
LEFT OUTER JOIN Rivers AS R
             ON R.Id = CR.RiverId
 WHERE C.ContinentCode = 'AF'
ORDER BY C.CountryName

-----Problem 15-----
WITH CTE_MostUserCurrencies AS
(
	SELECT CON.ContinentCode,
		   CTR.CurrencyCode,
		   COUNT(*) AS [CurrencyUsage],
		   DENSE_RANK() OVER(PARTITION BY CON.ContinentCode ORDER BY COUNT(*) DESC) AS [Rank]
	  FROM Continents CON
	LEFT OUTER JOIN Countries AS CTR
				 ON CTR.ContinentCode = CON.ContinentCode
	GROUP BY CON.ContinentCode,
			 CTR.CurrencyCode
	 HAVING COUNT(*) > 1
 )

SELECT C.ContinentCode,
       C.CurrencyCode,
	   C.CurrencyUsage
  FROM CTE_MostUserCurrencies AS C
 WHERE C.[Rank] = 1

-----Problem 16-----
SELECT COUNT(*) AS [CountryCode] 
  FROM Countries AS C
LEFT OUTER JOIN MountainsCountries AS MC
             ON MC.CountryCode = C.CountryCode
 WHERE MC.MountainId IS NULL

-----Problem 17-----
SELECT TOP(5) 
       C.CountryName,
       MAX(P.Elevation) AS [HighestPeakElevation],
	   MAX(R.[Length]) AS [LongestRiverlength]
  FROM Countries AS C
LEFT OUTER JOIN MountainsCountries AS MC
             ON MC.CountryCode = C.CountryCode
LEFT OUTER JOIN Peaks AS P
             ON P.MountainId = MC.MountainId
LEFT OUTER JOIN CountriesRivers AS CR
             ON CR.CountryCode = C.CountryCode
LEFT OUTER JOIN Rivers AS R
             ON R.Id = CR.RiverId
GROUP BY C.CountryName
ORDER BY HighestPeakElevation DESC,
         LongestRiverlength DESC,
		 C.CountryName

-----Problem 18-----
SELECT TOP(5)
       C.CountryName AS [Country],
       ISNULL(P.PeakName, '(no highest peak)') AS [Highest Peak Name],
	   ISNULL(MAX(p.Elevation), 0) AS [Highest Peak Elevation],
	   ISNULL(M.MountainRange, '(no mountain)') AS [Mountain]
  FROM Countries AS C
LEFT OUTER JOIN MountainsCountries AS MC
             ON MC.CountryCode = C.CountryCode
LEFT OUTER JOIN Mountains AS M
             ON M.Id = MC.MountainId
LEFT OUTER JOIN Peaks AS P
             ON P.MountainId = M.Id
GROUP BY C.CountryName,
         P.PeakName,
		 m.MountainRange
ORDER BY C.CountryName,
         [Highest Peak Name]
