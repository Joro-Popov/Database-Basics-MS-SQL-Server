-----Problem 1-----
SELECT COUNT(*) AS [Count] 
  FROM WizzardDeposits AS wd

-----Problem 2-----
SELECT MAX(WD.MagicWandSize) AS [LongestMagicWand] 
  FROM WizzardDeposits AS WD

-----Problem 3-----
SELECT WD.DepositGroup,
       MAX(WD.MagicWandSize) AS [LongestMagicWand]
  FROM WizzardDeposits AS WD
GROUP BY wd.DepositGroup

-----Problem 4-----
SELECT TOP(2)
       WD.DepositGroup
  FROM WizzardDeposits AS WD
GROUP BY WD.DepositGroup
ORDER BY AVG(WD.MagicWandSize)

-----Problem 5-----
SELECT WD.DepositGroup,
       SUM(WD.DepositAmount) AS [TotalSum] 
  FROM WizzardDeposits AS WD
GROUP BY WD.DepositGroup

------Problem 6-----
SELECT WD.DepositGroup,
       SUM(WD.DepositAmount) AS [TotalSum] 
  FROM WizzardDeposits AS WD
 WHERE WD.MagicWandCreator = 'Ollivander family'
GROUP BY WD.DepositGroup

-----Problem 7-----
SELECT WD.DepositGroup,
       SUM(WD.DepositAmount) AS [TotalSum] 
  FROM WizzardDeposits AS WD
 WHERE WD.MagicWandCreator = 'Ollivander family'
GROUP BY WD.DepositGroup
  HAVING SUM(WD.DepositAmount) < 150000
ORDER BY TotalSum DESC

-----Problem 8-----
SELECT WD.DepositGroup,
       WD.MagicWandCreator,
	   MIN(WD.DepositCharge) AS [MinDepositCharge] 
  FROM WizzardDeposits AS WD
GROUP BY WD.DepositGroup,
         WD.MagicWandCreator
ORDER BY WD.MagicWandCreator,
         WD.DepositGroup

-----Problem 9-----
SELECT AG.AgeGroup,
       COUNT(*) AS [WizzardCount]
  FROM
  (
	SELECT CASE
				WHEN WD.Age BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN WD.Age BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN WD.Age BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN WD.Age BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN WD.Age BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN WD.Age BETWEEN 51 AND 60 THEN '[51-60]'
				ELSE '[61+]'
		   END AS [AgeGroup]
	  FROM WizzardDeposits AS WD
) AS AG
GROUP BY AG.AgeGroup

-----Problem 10-----
SELECT SUBSTRING(WD.FirstName, 1, 1) AS [FirstLetter]
  FROM WizzardDeposits AS WD
 WHERE WD.DepositGroup = 'Troll Chest'
GROUP BY SUBSTRING(WD.FirstName, 1, 1)

-----Problem 11-----
SELECT WD.DepositGroup,
       WD.IsDepositExpired,
	   AVG(WD.DepositInterest)
  FROM WizzardDeposits AS WD
WHERE WD.DepositStartDate > '1985-01-01'
GROUP BY WD.DepositGroup,
         WD.IsDepositExpired
ORDER BY WD.DepositGroup DESC,
         WD.IsDepositExpired

-----Problem 12-----
SELECT SUM(D.[Difference]) AS [SumDifference]
  FROM
  (
	SELECT TOP((SELECT COUNT(*) - 1 FROM WizzardDeposits))
	       WD.FirstName AS [Host Wizard],
		   WD.DepositAmount AS [Host Wizard Deposit],
		   LEAD(WD.FirstName, 1, 0) OVER(ORDER BY WD.Id) AS [Guest Wizard],
		   LEAD(WD.DepositAmount, 1, 0) OVER(ORDER BY WD.Id) AS [Guest Wizard Deposit],
		   WD.DepositAmount - LEAD(WD.DepositAmount, 1, 0) OVER(ORDER BY WD.Id) AS [Difference]
	  FROM WizzardDeposits AS WD
  ) AS D

-----Problem 13-----
SELECT E.DepartmentID,
       SUM(E.Salary) AS [TotalSalary] 
  FROM Employees AS E
GROUP BY E.DepartmentID
ORDER BY E.DepartmentID

-----Problem 14-----
SELECT E.DepartmentID,
       MIN(E.Salary) AS [MinimumSalary]
  FROM Employees AS E
 WHERE E.DepartmentID IN (2, 5, 7)
   AND E.HireDate > '2000-01-01'
GROUP BY E.DepartmentID

-----Problem 15-----
SELECT *
  INTO EmployeesWithSalaryMoreThan30000 
  FROM Employees AS E
 WHERE E.Salary > 30000

DELETE 
  FROM EmployeesWithSalaryMoreThan30000 
 WHERE ManagerID = 42

UPDATE EmployeesWithSalaryMoreThan30000
   SET Salary += 5000
 WHERE DepartmentID = 1

SELECT ES.DepartmentID,
       AVG(ES.Salary) AS [AverageSalary]
  FROM EmployeesWithSalaryMoreThan30000 AS ES
GROUP BY ES.DepartmentID

-----Problem 16-----
SELECT E.DepartmentID,
       MAX(E.Salary) AS [maxSalary]
  FROM Employees AS E
GROUP BY E.DepartmentID
  HAVING MAX(E.Salary) < 30000 OR MAX(E.Salary) > 70000

-----Problem 17-----
SELECT COUNT(*) AS [Count]
  FROM Employees AS E
 WHERE E.ManagerID IS NULL

-----Problem 18-----
SELECT E.DepartmentID,
       (
			SELECT DISTINCT 
			       S.Salary
			  FROM Employees AS S
			 WHERE S.DepartmentID = E.DepartmentID
		  ORDER BY S.Salary DESC
		    OFFSET 2 ROWS
			FETCH NEXT 1 ROWS ONLY
	   ) AS [ThirdHighestSalary]
  FROM Employees AS E
 WHERE (
			
			SELECT DISTINCT
			       S.Salary
			  FROM Employees AS S
			 WHERE S.DepartmentID = E.DepartmentID
		  ORDER BY S.Salary DESC
		    OFFSET 2 ROWS
			FETCH NEXT 1 ROWS ONLY
       ) IS NOT NULL
GROUP BY E.DepartmentID

-----Problem 19-----
SELECT TOP(10)
       E.FirstName,
       E.LastName,
	   E.DepartmentID
  FROM Employees AS E
 WHERE E.Salary > (
						SELECT AVG(S.Salary) AS [AverageSalary]
						  FROM Employees AS S
						 WHERE S.DepartmentID = E.DepartmentID
					  GROUP BY S.DepartmentID
                  )
ORDER BY E.DepartmentID