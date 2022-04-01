--DDL ::

--CREATE
CREATE TABLE Student (
    StudentId INTEGER,
    FName VARCHAR2(10), 
    Gender CHAR(1), 
    DOJ DATE);
--Not NULL Constraint
CREATE TABLE Student (
    StudentId INTEGER CONSTRAINT Stud_SId_nn NOT NULL,
    FName VARCHAR2(10) NOT NULL,
    LName VARCHAR2(10));

CREATE TABLE Student (
    Email VARCHAR2(50) PRIMARY KEY,
    IP VARCHAR2(50) NOT NULL);
--DEFAULT Constraint
CREATE TABLE Student (
    StudentId INTEGER, 
    FName VARCHAR2(10), 
    DOJ DATE DEFAULT SYSDATE);
--PRIMARY KEY Constraint
CREATE TABLE Student ( 
    StudentId INTEGER CONSTRAINT stud_sid_pk PRIMARY KEY,
    FName VARCHAR2(10), 
    ContactNo NUMBER(10));
--CHECK Constraint
CREATE TABLE Student ( 
    StudentId INTEGER, 
    FName VARCHAR2(10), 
    Gender CHAR(1) CONSTRAINT Stud_gender_ck1 CHECK(Gender IN('M', 'F'))); 
--UNIQUE
CREATE TABLE Student ( 
    StudentId INTEGER, 
    FName VARCHAR2(10), 
    ContactNo NUMBER(10) CONSTRAINT Stud_cno_uk UNIQUE);
--FOREIGN KEY Constraint
CREATE TABLE Marks(
    CourseId INTEGER, 
    StudentId INTEGER CONSTRAINT marks_sid_fk REFERENCES Student(StudentId), 
    MarksScored DECIMAL(5,2));
--Composite PRIMARY KEY
CREATE TABLE Marks( 
    CourseId INTEGER, 
    StudentId INTEGER CONSTRAINT marks_sid_fk REFERENCES Student(StudentId), 
    MarksScored DECIMAL(5,2), 
    CONSTRAINT marks_cid_pk PRIMARY KEY(CourseId, StudentId));

--DROP
 DROP TABLE Student;

/*Exercise 3: 
https://infytq.onwingspan.com/en/viewer/rdbms-hands-on/lex_auth_01273327794078515226_shared?collectionId=lex_auth_01275806667282022456_shared&collectionType=Course

Constraint name always should be unique.
*/
CREATE TABLE Match(
    MId INTEGER,
    TId INTEGER,
    Player1 INTEGER CONSTRAINT match_plyr_fk REFERENCES Player(PId),
    Player2 INTEGER CONSTRAINT matc_plyr_fk REFERENCES Player(PId),
    MatchDt DATE NOT NULL,
    Winner INTEGER CONSTRAINT match_pid_fk REFERENCES Player(PId),
    Score VARCHAR2(30) NOT NULL,
    CONSTRAINT match_mid_pk PRIMARY KEY(MId, TId),
    CONSTRAINT mtc_plyr_fk CHECK(Player1 <> Player2),
    CONSTRAINT match_tid_fk FOREIGN KEY(TId) REFERENCES Tournament(TId)
    );

--ALTER
--Drop one/two column:
ALTER TABLE Student DROP (DOB);
ALTER TABLE Player DROP (ContactNo);
ALTER TABLE Student DROP (GNDR, MobNo);

--ADD one/two Column
ALTER TABLE Student ADD Address VARCHAR2 (20);
ALTER TABLE Student ADD (Course VARCHAR2 (20), Marks NUMBER (10));
ALTER TABLE Player ADD (MatchesPlayed NUMBER, MatchesWon NUMBER);

--MODIFY : The size of the data type can be increased or decreased. The column should be empty for decreasing the size or for changing the data type from one type to another
ALTER TABLE Student MODIFY Name VARCHAR2(50);
ALTER TABLE Player MODIFY PName VARCHAR2(50);

ALTER TABLE QuickTrack MODIFY IP VARCHAR2(50) NOT NULL;

--DEFAULT : The data type of the column and default expression must be same.
ALTER TABLE Student MODIFY DOJ DEFAULT SYSDATE;

--RENAME
ALTER TABLE Student RENAME COLUMN Id TO SID;
ALTER TABLE Player RENAME COLUMN PId TO PlayerId;


--DML
--INSERT
--Without column name
INSERT INTO Employee VALUES (6, 'James Potter', '01-Jun-2014', 75000.00, 1000.00, 'ETA', 'PM', NULL, 1004);
--With column name
INSERT INTO Employee (Id, Ename, DOJ, Salary, Bonus, Dept, Designation, Manager, Compid) VALUES (7, 'Ethan McCarty', '01-Feb-2014', 90000.00, 1200.00, 'ETA', 'PM', NULL, NULL); 

--We can omitt NULL entries
INSERT INTO Employee (Id, Ename, DOJ, Salary, Dept, Designation) VALUES (10, 'Jack Abraham', '01-Jul-2014', 30000.00 , 'ETA', 'SSE');

--SELECT
SELECT * FROM Employee

SELECT Id, EName, Salary FROM Employee

--Aliase :: Aliases are used to change column names in result.
--Here, EmpId and EmpName are Aliase
SELECT Id EmpId, EName EmpName, Salary FROM Employee
SELECT Id AS EmpId, EName AS EmpName, Salary FROM Employee

--Expression with SELECT
SELECT EName, Salary * 2 AS Double_Salary FROM Employee

--Constant with SELECT :: A hardcoded value in select clause will appear as an additional column in the result with the same value on all records.
--30 is a constant value result in value column
SELECT EName, 30 AS Value FROM Employee

--DISTINCT
SELECT DISTINCT Dept FROM Employee

SELECT DISTINCT Dept, Manager FROM EMPLOYEE

--WHERE
SELECT ID, ENAME FROM Employee WHERE SALARY > 40000
SELECT ID, ENAME FROM Employee WHERE ENAME = 'James Potter'
SELECT ID, ENAME FROM Employee WHERE SALARY >= 30000 AND DEPT = 'ETA'
SELECT ID, ENAME FROM Employee WHERE SALARY > 75000 OR DEPT = 'ICP'
--BETWEEN
SELECT ID, ENAME FROM Employee WHERE SALARY BETWEEN 30000 and 50000 --Include 3000 and 5000
--IN : IN operator is used to check for multiple values of an attribute.
SELECT ID, ENAME FROM Employee WHERE ID IN (2,3)
--If IN clause contains duplicate values then the database server will remove duplicates before executing the query.
SELECT ID, ENAME FROM Employee WHERE DEPT IN ('ETA', 'ETA')
-- NOT : NOT operator is used to negate the condition.
SELECT ID, ENAME FROM Employee WHERE ID NOT IN (2,3)
--NULL
SELECT ID, EName FROM Employee WHERE BONUS IS NULL
SELECT Prodid, Pdesc, Category, Discount FROM Product WHERE Pdesc IS NULL

SELECT ID, EName FROM Employee WHERE BONUS IS NOT NULL
-- QUERY ERROR ::
SELECT ID, EName FROM Employee WHERE BONUS = NULL
SELECT ID, ENAME FROM Employee WHERE BONUS IN (NULL)

--CHAR ::
--Trailing spaces are ignored for CHAR data type. :: 'PM    '
SELECT Id, EName, Designation FROM Employee WHERE Designation = 'PM  '
--Leading spaces are NOT ignored for CHAR data type. :: '   PM'
SELECT Id, EName, Designation FROM Employee WHERE Designation = ' PM'

--VARCHAR ::
--Trailing spaces as well as Leading spaces are NOT ignored for CHAR data type. :: 'James Potter ', '  James Potter'
SELECT Id, EName, Designation FROM Employee WHERE EName = 'James Potter  '
SELECT Id, EName, Designation FROM Employee WHERE EName = '  James Potter'

--LIKE :: LIKE operator is used to match a character pattern.
--Start name :: with E
SELECT ID, ENAME FROM Employee WHERE ENAME LIKE 'E%'
--End name :: with r
SELECT ID, ENAME FROM Employee WHERE ENAME LIKE '%r'
SELECT ID, ENAME, DOJ FROM Employee WHERE DOJ LIKE '%14' -- Date end with 14 like 1914,2014
--Anywhere pattern :: rows where name contains character 'm' anywhere.
SELECT ID, ENAME FROM Employee WHERE ENAME LIKE '%m%'
--Fixed Pattern :: Result only those rows where date contains any 2 characters followed by '-' and then any 3 characters followed by '-' and then any 2 characters.  22-Jan-2002
SELECT ID, ENAME, DOJ FROM Employee WHERE DOJ LIKE '__-___-__'
--Mixed Pattern :: rows where name contains second character as 'a' followed by any number of characters.
SELECT ID, ENAME FROM Employee WHERE ENAME LIKE '_a%'

/*ORDER of QUERY EXECUTION: (TOP -> DOWN)
F FROM
J JOIN
W WHERE
G GROUP BY
H HAVING
S SELECT
D DISTINCT
O ORDER BY

*/

--UPDATE
UPDATE Employee SET SALARY = SALARY * 1.10 --update in all values of column
UPDATE Employee SET SALARY = SALARY * 1.20 WHERE ID = 2 --update only those rows which satisfies the criterion
UPDATE Employee SET SALARY = SALARY * 1.3, BONUS = SALARY * 0.30 WHERE ID = 1 --multiple column update
UPDATE Employee SET SALARY = SALARY * 1.40 WHERE DESIGNATION = 'SE' OR DEPT = 'ETA'

UPDATE Employee SET ENAME = NULL WHERE ID = 1 -- Value of a column with a NOT NULL constraint cannot be updated to NULL.
UPDATE Employee SET ID = 6 WHERE ID = 5 -- Primary key can not be changed

--DELETE
DELETE FROM Employee WHERE Id = 5;
DELETE FROM Employee WHERE Dept ='ETA' and Manager = 2;
DELETE FROM Employee; --All rows deleted

-- NUMERIC FUNCTIONS ::
-- ABS :: ABS(value)	Returns absolute value of a number :: -10 -> 10
-- ROUND ::	ROUND(value, digits)	Rounds the value to specified decimal digits :: 10.55 -> 11, 10.2 -> 10
-- CEIL	:: CEIL(value)	Rounds up the fractional value to next integer :: 10.27 -> 11
-- FLOOR :: FLOOR(value)	Rounds down the fractional value to the lower integer :: 10.87 -> 10
SELECT City, MinTemp, CEIL(MinTemp) AS "Ceiling", FLOOR(MinTemp) AS "Floor", ABS(MinTemp) as "Absolute"  FROM Weather;
SELECT City, MinTemp, ROUND(MinTemp) as "Round", ROUND(MinTemp,1) as "RoundTo1Digit" FROM Weather;

-- CHARACTER  FUNCTIONS ::
-- UPPER	UPPER(value)	Converts value to upper case
-- LOWER	LOWER(value)	Converts value in lower case
-- CONCAT	CONCAT(value1, value2)	Concatenates value1 and value2
-- LENGTH	LENGTH(value)	Returns the number of characters in value.
SELECT City, LENGTH(City) "LENGTH",  LOWER(City) "LOWERCASE", UPPER(City) "UPPERCASE" FROM Weather;
SELECT City, Country, CONCAT(City, Country) "CONCAT", --LondonUK
 City || Country "ConcatByOperator", --LondonUK using operator 
 CONCAT(CONCAT(City, ', '), Country) "NestedConcat" --London,UK
  FROM Weather;

--SUBSTRING FUNCTIONS ::
--SUBSTR
SELECT City, SUBSTR(City,1,4) FIRST4, SUBSTR(City,2,10) TEN_FROM_2, SUBSTR(City,3) ALL_FROM_3, SUBSTR(City,7, 2) TWO_FROM_7 FROM Weather;
SELECT RecordDate, SUBSTR(RecordDate,1,2) "DAY", SUBSTR(RecordDate,4,3) "MONTH", SUBSTR(RecordDate,8) "YEAR" FROM Weather; -- 22-Jan-22

--CONVERSION FUNCTIONS ::
-- TO_CHAR :: TO_CHAR(value,format)	Converts a number or a date to a string. Use this function for formatting dates and numbers.
SELECT MinTemp, TO_CHAR(MinTemp) DEF_FORMAT, TO_CHAR(MinTemp, '999.99') "FIXED_DIGITS", TO_CHAR(MinTemp, '9,9.99') "COMMA" FROM Weather;
--You can use TO_CHAR with dates to extract date parts like Date, Month, Year.
SELECT RecordDate, TO_CHAR(RecordDate, 'MON') "MONTH", TO_CHAR(RecordDate, 'Month') "FULL_MONTH", TO_CHAR(RecordDate, 'Dy') "DAY", TO_CHAR(RecordDate, 'Day') "FULL_DAY" FROM Weather;
--TO_CHAR can also be used to format dates in your desired format.
SELECT TO_CHAR(RecordDate) DEF_FORMAT, TO_CHAR(RecordDate, 'DD/MM/CCYY') INDIAN, TO_CHAR(RecordDate, 'MM/DD/YY') AMERICAN FROM Weather;
-- TO_DATE :: TO_DATE(value,format)	Converts a string to a date.
SELECT '01-Jan-2014' DATE_STRING, TO_DATE('01-Jan-2014') CONV_NOFORMAT, TO_DATE('01-Jan-2014', 'DD-Mon-YYYY') CONV_FORMAT FROM DUAL
SELECT 'Jan-01-2014' DATE_STRING, TO_DATE('Jan-01-2014', 'Mon-DD-YYYY') CONV_FORMAT FROM DUAL
-- TO_NUMBER :: TO_NUMBER(value,format)	Converts a string to a number.
SELECT '1000.98' "ORIG_NOFORMAT", TO_NUMBER('1000.98') "CONV_NOFORMAT", '1,000.98' "ORIG_FORMAT", TO_NUMBER('1,000.98', '9,999.99') "CONV_FORMAT" FROM DUAL;

--DATE FUNCTION ::
-- SYSDATE :: SYSDATE	Returns current date of System i.e. the host on which database server is installed.
-- SYSTIMESTAMP :: SYSTIMESTAMP	Returns current timestamp of the System.
-- ADD_MONTHS :: ADD_MONTHS(date, n)	Adds n months to the given date.
-- MONTHS_BETWEEN :: MONTHS_BETWEEN(date1,date2)	Finds difference between two dates in months.
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;
SELECT RECORDDATE, ADD_MONTHS(RECORDDATE, 1) "NEXT_MONTH" FROM Weather; --Next month of specified month will be taken
SELECT MONTHS_BETWEEN('01-Feb-2014', '01-Jan-2014') "MONTH_DIFF1", MONTHS_BETWEEN('10-Jan-2014', '01-Jan-2014') "MONTH_DIFF2" FROM DUAL;

--AGGREGATE FUNCTIONS ::
--MIN
--MAX
--SUM
SELECT MIN(Salary), MAX(Salary), SUM(Salary) FROM Employee
--COUNT
/*
COUNT(BONUS) :: count of not null values
COUNT(*) :: count include null values 
*/
SELECT COUNT(ID) COUNT_ID, COUNT(*) COUNT_bonus, COUNT(Bonus) COUNT_BONUS FROM Employee
--Count of distict value in column :: count2 is column name
SELECT COUNT(DISTINCT Dept) Count2 FROM Employee
--AVG
SELECT AVG(Salary) AvgSalary, AVG(Bonus) AvgBonus1, SUM(Bonus) / Count(Bonus) AvgBonus2 FROM Employee

--MISCELLneous functions ::
--NVL :: NVL(value1, value2)
--Substitutes value1 by value2 if value1 is NULL. The data type of value1 and value2 must be same.
SELECT CITY,
NVL(CITY, 'Not Available') NVL_CITY,
MINTEMP,
NVL(MINTEMP, 0.0) NVL_MINTEMP,
NVL(TO_CHAR(MINTEMP), 'Not Available') NVL_MINTEMP2 from Weather;
--USER :: USER	Returns the current logged in user
SELECT USER FROM DUAL;

--CASE
--Equality :
--column with name new_salary is created having updated data value of salary

SELECT Id, EName, Designation, Salary, 
CASE Designation 
    WHEN 'SE' THEN Salary * 1.2 
    WHEN 'SSE' THEN Salary * 1.1 
    ELSE Salary * 1.05 
END New_Salary 
FROM Employee;
--Expression :
SELECT EName, Designation, Bonus, 
CASE  
    WHEN Designation = 'SE' THEN Bonus + 500 
    WHEN Designation = 'SSE' THEN Bonus + 1000  
    WHEN Designation = 'PM' THEN Bonus + 2000 
    ELSE  Bonus 
END AS NewBonus 
FROM Employee;

SELECT Id, EName, Designation, Salary, 
CASE 
    WHEN Designation = 'SE' OR Designation = 'SSE' THEN TO_CHAR(Salary * 1.2) 
    WHEN Designation = 'PM' AND Salary >= 90000 THEN 'No hike' 
    ELSE TO_CHAR(Salary * 1.05 ) 
END New_Salary 
FROM Employee;

--ORDER BY
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY SALARY
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY DEPT ASC
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY DOJ DESC
--Multiple column sort
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY DEPT, DESIGNATION
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY DEPT ASC, DESIGNATION DESC
--column no. 2 sort i.e. ENAME
Select ID, ENAME, DOJ, SALARY, DEPT, DESIGNATION FROM Employee ORDER BY 2

--GROUP BY
SELECT Dept, Count(ID) FROM Employee GROUP BY Dept;
SELECT Dept, Designation, MAX(Salary) FROM Employee GROUP BY Dept, Designation;
SELECT Dept, MIN(SALARY), MAX(Salary) FROM Employee GROUP BY Dept;
SELECT dept, AVG(Salary) FROM Employee GROUP BY dept;
SELECT MAX(AVG(Salary)) FROM Employee GROUP BY dept;
SELECT Bonus, Count(*) FROM Employee GROUP BY Bonus

--HAVING
SELECT Prodid, sum(quantity) FROM Saledetail WHERE Quantity > 1 GROUP BY Prodid HAVING COUNT(prodid)> 1;

--For combining data
--UNION :: Removes duplicates
SELECT CompId FROM Employee
UNION
SELECT CompId FROM Computer

--UNION ALL :: Not removes duplicate
SELECT CompId FROM Employee UNION ALL SELECT CompId FROM Computer;
select sid, Sname, location from Salesman where sname like '%e%' and location like '%o%'
union all
select sid, Sname, location from Salesman where sname like '%a%' and location like '%a%';
select prodid, pdesc, Category, Discount from product where discount < 10 
union all
select prodid, pdesc, Category, Discount from product where category = 'Sports';

--JOIN
--CROSS JOIN :: M rows of table1 and N rows of table2 then resultant table have M X N rows
SELECT E.ID, E.ENAME, E.COMPID AS E_COMPID, C.COMPID, C.Model
FROM Employee E CROSS JOIN Computer C;

--INNER JOIN :: 
SELECT ID, ENAME, E.COMPID AS E_COMPID, C.COMPID AS C_COMPID, MODEL 
FROM Employee E INNER JOIN Computer C ON E.COMPID = C.COMPID;

--FOR APPLYING SOME FILTER THERE ARE TWO WAYS :: 
--1. Using WHERE
SELECT Id, EName, E.CompId AS E_CopmId, C.CompId AS C_CompId, Model FROM Employee E INNER JOIN Computer C ON E.CompId = C.CompId WHERE Dept='ETA';
--2.Using AND
SELECT Id, EName, E.CompId AS E_CopmId, C.CompId AS C_CompId, Model FROM Employee E INNER JOIN Computer C ON E.CompId = C.CompId AND Dept='ETA';

--SELF JOIN ::
SELECT EMP.ID EMPID, EMP.ENAME EMPNAME, MGR.ID MGRID, MGR.ENAME MGRNAME FROM Employee EMP INNER JOIN Employee MGR ON EMP.MANAGER = MGR.ID;

--LEFT OUTER JOIN ::
SELECT ID, ENAME, E.COMPID AS E_COMPID, C.COMPID AS C_COMPID, MODEL FROM Employee E LEFT OUTER JOIN Computer C ON E.COMPID = C.COMPID;
SELECT Id, EName, Dept, E.CompId AS E_CompId, C.CompId AS C_CompId, Model FROM Employee E LEFT OUTER JOIN Computer C ON E.CompId = C.CompId WHERE Dept = 'ETA';
SELECT Id, EName, Dept, E.CompId AS E_CompId, C.CompId AS C_CompId, Model FROM Employee E LEFT OUTER JOIN Computer C ON E.CompId = C.CompId AND Dept = 'ETA';

--RIGHT OUTER JOIN ::
SELECT ID, ENAME, E.COMPID AS E_COMPID, C.COMPID AS C_COMPID, MODEL 
FROM Employee E RIGHT OUTER JOIN Computer C ON E.COMPID = C.COMPID;

--FULL OUTER JOIN ::
SELECT ID, ENAME, E.COMPID AS E_COMPID, C.COMPID AS C_COMPID, MODEL
FROM Employee E FULL OUTER JOIN Computer C ON E.COMPID = C.COMPID;
