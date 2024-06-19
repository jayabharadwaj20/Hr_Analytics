use hr_analyst;
show tables;
select * from hr1;
select * from hr2;
#---------------------------------------------KPI 1---------------------------------------------
/* 1-- Average Attrition Rate for All Department -- */
select a.Department, concat(format(avg(a.attrition_y)*100,2),'%') as Attrition_Rate
from  
( select department,attrition,
case when attrition='Yes'
then 1
Else 0
End as attrition_y from hr1 ) as a
group by a.department;

#-----------------------------KPI 2-------------------------------------------------------------
/*  2-- Average Hourly Rate for Male Research Scientist --*/
select JobRole, format(avg(hourlyrate),2) as Average_HourlyRate,Gender
from hr1
where upper(jobrole)= 'RESEARCH SCIENTIST' and upper(gender)='MALE'
group by jobrole,gender;

#---------------------------KPI 3-----------------------------------------------------------------------
/* 3-- AttritionRate vs MonthlyIncomeStats against department-- */

-- Calculate attrition rate and average income by department
select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from  hr1 h1)*100,2) 'Attrtion rate',
round(avg(h2.MonthlyIncome),2) average_incom from hr1 h1 join hr2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

-- Creating a view for attrition rate and average income by department
create view Attrition_employeeincome as
select h1.department,
round(count(h1.attrition)/(select count(h1.employeenumber) from hr1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_income from hr1 h1 join hr2 h2
on h1.EmployeeNumber = h2.`employee id`
where attrition = 'Yes'
group by h1.department;

-- Query the created view for attrition rate and average income by department
select * from attrition_employeeincome;

#----------------------------------------KPI 4-----------------------------------------------------------------------
# 4. Average working years for each Department

select h1.department,Round(avg(h2.totalworkingyears),0) from hr1 h1
join hr2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

Create view `Employee Age` as 
select h1.department,Round(avg(h2.totalworkingyears),0) from hr1 h1
join hr2 h2 on h1.employeenumber = h2.`Employee ID`
group by h1.department;

select * from `employee age`;

#---------------------------------------KPI 5-------------------------------------------------------------
# 5. Job Role Vs Work life balance
-- Describe the hr2 table to check column names
DESCRIBE hr2;

-- Select job role, count of each performance rating, total employees, and average work-life balance rating
SELECT h1.JobRole,
    SUM(CASE WHEN h2.performancerating = 1 THEN 1 ELSE 0 END) AS 1st_Rating_Total,
    SUM(CASE WHEN h2.performancerating = 2 THEN 1 ELSE 0 END) AS 2nd_Rating_Total,
    SUM(CASE WHEN h2.performancerating = 3 THEN 1 ELSE 0 END) AS 3rd_Rating_Total,
    SUM(CASE WHEN h2.performancerating = 4 THEN 1 ELSE 0 END) AS 4th_Rating_Total,
    COUNT(h2.performancerating) AS Total_Employee,
    FORMAT(AVG(h2.WorkLifeBalance), 2) AS Average_WorkLifeBalance_Rating
FROM hr1 h1
INNER JOIN hr2 h2 ON h1.employeenumber = h2.`Employee ID`
GROUP BY h1.JobRole
LIMIT 0, 10000;
 
 #--------------------------------KPI 6-----------------------------------------------------------------
 #6.Attrition rate Vs Year since last promotion relation

select a.JobRole,concat(format(avg(a.attrition_rate)*100,2),'%') as Average_Attrition_Rate,
format(avg(b.YearsSinceLastPromotion),2) as Average_YearsSinceLastPromotion
from ( select JobRole,attrition,employeenumber,
case when attrition = 'yes' then 1
else 0
end as attrition_rate from hr1) as a
inner join hr2 as b on b.`employee id` = a.employeenumber
group by a.JobRole;


