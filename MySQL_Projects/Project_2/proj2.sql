
-- Question Bank (Covers all topics you learned)

												-- 1. Basic SQL

									-- Q1. Create a database and import these CSVs as tables.

CREATE DATABASE SQLpractice;

									-- Q2. Show the first 20 employees hired.
SELECT hiredate FROM employees;
-- Modifying hiredate datatype
ALTER TABLE employees
MODIFY COLUMN hiredate DATE;

SELECT EmpID,`Name` , hiredate FROM employees
ORDER BY hiredate ASC 
LIMIT 20; 

								-- Q3. List unique departments.
SELECT DISTINCT Department FROM employees;                                
                                
								-- Q4. Find employees with salary > 100000
SELECT DISTINCT `Name`, Salary FROM employees
WHERE Salary > 100000;   
                             
                             
						-- 2. Filtering & Conditions
						-- Q5. Get employees in IT or Finance earning > 80000.

SELECT `Name`, Department ,Salary FROM Employees
WHERE Department IN('IT','finance') AND Salary > 80000;

						-- Q6. Find employees whose name starts with “A”.
SELECT `Name` FROM Employees
WHERE `Name` LIKE "A%";

						-- Q7. List employees hired between 2018-01-01 and 2020-12-31.

SELECT `Name` , hiredate FROM Employees
WHERE hiredate BETWEEN '2018-01-01' AND '2020-12-31';


								-- 3. Aggregations

								-- Q8. Find average salary per department.

SELECT Department,AVG(Salary) AS `Avg Department Salary`  FROM employees
GROUP BY Department;

								-- Q9. Count number of employees per manager.

SELECT ManagerID, COUNT(`Name`) AS `No of Employees `  FROM employees
GROUP BY ManagerID;

	
    
                            -- Q10. Find max, min, avg salary across all employees.
SELECT AVG(Salary), MIN(Salary), MAX(Salary) FROM Employees ;

							-- 4. GROUP BY & HAVING

							-- Q11. Find departments with more than 500 employees.
SELECT Department , COUNT(`EmpID`) AS Total_Emp  FROM employees
GROUP BY Department 
HAVING COUNT(`EmpID`) > 500 ;

							-- Q12. Show projects where total hours worked > 10000.


							-- 5. Joins

							-- Q13. Join employees with their projects (emp_projects).
CREATE VIEW join1 AS
  SELECT t1.empid, t1.name, t2.ProjID, t2.Hoursworked  FROM Employees t1
  JOIN emp_projects t2
  ON t1.empid = t2.empid
  ;
  
							-- Q14. Show employees working on more than 3 projects.
 
 SELECT empID , `name`, COUNT(ProjID) FROM join1
 GROUP BY empID, `name`
 HAVING COUNT(ProjID) > 3 ;                           
							-- Q15. Show project budgets alongside employee hours.
 
 SELECT t1.Budget, t2.HoursWorked FROM projects t1
 JOIN emp_projects t2 
 ON t1.ProjID = t2.ProjID ;

							-- 6. UNION
							-- Q16. Get a combined list of project names and employee names (just for practice with UNION).

SELECT `name` FROM employees
UNION 
SELECT projectname FROM projects;

						-- 7. Subqueries

						-- Q17. Find employees earning more than the average salary.
SELECT empID,`name`, Salary FROM employees
WHERE SALARY  >  ( SELECT AVG(salary) FROM employees);

						-- Q18. Get employees who are not assigned to any project.
SELECT empID,`name` FROM employees
WHERE empID NOT IN ( SELECT EmpID FROM emp_projects);

						-- 8. Constraints & Keys
						-- Q19. Identify orphan rows in emp_projects (EmpID/ProjID not existing in parent tables).


					-- 9. Data Cleaning
					-- Q20. Trim spaces from names.

UPDATE employees
SET `name` = TRIM(`name`);

					-- Q21. Standardize department names to uppercase.

UPDATE employees
SET department = UPPER(department);
				
                    -- Q22. Fix missing ManagerID by setting to NULL where invalid.
UPDATE employees
SET ManagerID =  NULL
WHERE ManagerID IN (NULL,'');

					-- Q23. Convert inconsistent project end dates to proper format.
SELECT startdate, enddate FROM projects;
ALTER TABLE  projects
MODIFY COLUMN startdate DATE; 

UPDATE projects
SET enddate = null
WHERE enddate IN( NULL, '');

ALTER TABLE  projects
MODIFY COLUMN enddate DATE;

					-- Q24. Remove duplicates if any exist.
SELECT * ,COUNT(*) FROM emp_projects
GROUP BY EmpID,ProjID,`Role`,HoursWorked
HAVING COUNT(*) > 1;

					-- 10. Window Functions
					-- Q25. Rank employees by salary within each department.
	SELECT EmpID , salary, department, RANK() OVER ( PARTITION BY department ORDER BY salary DESC ) AS Salary_rank FROM employees;  
    
					-- Q26. Find top 3 highest-paid employees in each department.
    WITH cte1 AS 
    (SELECT EmpID, `name`, salary, department, RANK() OVER ( PARTITION BY department ORDER BY salary DESC ) AS Salary_rank 
    FROM employees)
	SELECT Department, EmpID ,`name` , Salary_rank FROM cte1
    WHERE Salary_rank <=3;  
                    
					-- Q27. Use LAG() to find salary changes compared to previous hire.
CREATE TABLE q27 AS 
SELECT Department , empID ,hiredate, Salary , LAG(Salary,1,0) OVER ( ORDER BY  Department, (hiredate)) AS Previous_hire					
FROM employees ;                    

-- alter table to ad a new column 
ALTER TABLE q27
ADD COLUMN Salary_Diff INT ; 

-- update values in new column-- 
UPDATE q27
SET  Salary_Diff = (Salary - Previous_hire);

SELECT * FROM q27 ;

      
      -- Q28. Use NTILE(4) to bucket employees into salary quartiles.

SELECT EmpID , department,Salary , NTILE(4) OVER (PARTITION BY department ORDER BY Salary ) AS quartile 
FROM employees;

						-- 11. Case & Conditional
						-- Q29. Categorize employees into “Junior” (<30), “Mid” (30–45), “Senior” (>45) using CASE.
SELECT 
    empid,
    `name`,
    Age,
    CASE
        WHEN age < 30 THEN 'Junior'
        WHEN age BETWEEN 40 AND 45 THEN 'Mid'
        WHEN age > 30 THEN 'Senior'
    END AS `level`
FROM
    employees;
    
						-- Q30. Create a flag if project budget > 500000.
SELECT ProjectName , Budget , CASE
									WHEN Budget >500000 THEN 1
                                    ELSE 0 
                               END AS FLAG
FROM projects;                               
                               

					-- 12. Transactions
					-- Q31. Start a transaction to delete employees with salary < 35000, then rollback.
					-- Q32. Update department = “TECH” for IT, then commit.
START TRANSACTION ;
DELETE FROM employees
WHERE Salary < 35000;

ROLLBACK;

UPDATE employees
SET department = 'Tech' 
WHERE department = 'IT';

COMMIT;


