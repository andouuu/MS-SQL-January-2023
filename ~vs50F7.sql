use SoftUni
---1---
select FirstName,LastName
from Employees
where left(FirstName,2)='Sa'
---2---
select FirstName,LastName
from Employees
where LastName like '%ei%'
---3---
select FirstName
from Employees
where (DepartmentID=3 or DepartmentID=10) 
and (DATEPART(YEAR,HireDate)>=1995 and DATEPART(YEAR,HireDate)<=2005)
---4---
select FirstName,LastName
from Employees
where JobTitle not like '%engineer%'
---5---
select [Name]
from Towns
where LEN([Name])=6 or LEN([Name])=5
order by [Name] asc
---6---
select TownID,[Name]
from Towns
where [Name] like 'M%' or [Name] like 'K%' or[Name] like 'B%' or[Name] like 'E%'
order by [Name] asc
---7---
select TownID,[Name]
from Towns
where [Name] not like 'D%' and [Name] not like 'R%' and [Name] not like 'B%'
order by [Name] asc
---8---
create view V_EmployeesHiredAfter2000 as
select FirstName,LastName
from Employees
where DATEPART(year,HireDate)>2000
---9---
select FirstName,LastName
from Employees
where len(LastName)=5
---10---
select EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() over (partition by Salary order by EmployeeID) as [Rank]
from Employees
where Salary between 10000 and 50000
order by Salary Desc
---11---
select * 
from (select EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() over (partition by Salary order by EmployeeID) as [Rank]
from Employees
where Salary between 10000 and 50000) e
where e.[Rank]=2
order by e.Salary desc

----GEOGRAPHY----
use Geography
---12---
select CountryName,IsoCode
from Countries
where lower(CountryName) like '%a%a%a%'
order by IsoCode
---13---
select p.PeakName,r.RiverName, lower(concat(left(p.PeakName,len(p.PeakName)-1),r.RiverName)) as Mix
from Peaks p,Rivers r
where right(PeakName,1)=LEFT(RiverName,1)
order by Mix

----Diablo----
use Diablo
---14---
select top 50 [Name],format([Start],'yyyy-MM-dd') as [Start]
from Games
where DATEPART(YEAR,[Start])=2011 or datepart(year,[Start])=2012
order by [Start] ,[Name] 
---15---
select Username,substring(Email,CHARINDEX('@',Email)+1,len(Email)-charindex('@',Email)) as [Email Provider]
from Users
order by [Email Provider],Username
---16---
select Username,IpAddress
from Users
where IpAddress like '___.1_%._%.___'
order by Username
---17---
select [Name],case
 when DATEPART(HOUR,[Start]) between 0 and 11 then 'Morning'
 when DATEPART(HOUR,[Start]) between 12 and 17 then 'Afternoon'
 else 'Evening'
 end as [Part of the day],
   case when g.Duration<=3 then 'Extra Short'
   when g.Duration between 4 and 6 then 'Short'
   when g.Duration>6 then 'Long'
   else 'Extra Long'
   end as Duration
from Games g
order by [Name], Duration 

----ORDERS----
use Orders
---18---
select ProductName,OrderDate,
DATEADD(DAY,3,OrderDate) as [Pay Due],
DATEADD(MONTH,1,OrderDate) as [Deliver Due]
from Orders