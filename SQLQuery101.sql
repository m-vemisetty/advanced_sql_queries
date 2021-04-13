use Company

--find the name of the departments with 2 or more employees
select * from DEPARTMENT
select * from EMPLOYEE

select D.dname, COUNT(E.ssn) as emp_count from DEPARTMENT D join EMPLOYEE E 
on E.dno = D.dnumber 
group by D.dname
having COUNT(E.ssn) >=2
order by D.dname;

--Find the name of the departments with 2 or more female employees 
select * from DEPARTMENT
select * from EMPLOYEE

select D.dname, COUNT(E.ssn) as emp_count from DEPARTMENT D join EMPLOYEE E 
on E.dno = D.dnumber 
where E.sex = 'F' 
group  by d.dname
having COUNT(E.ssn) >=2
order by D.dname;

--Find the name of the departments with 2 or more employees who earn more than $30000
select * from DEPARTMENT
select * from EMPLOYEE

select D.dname, COUNT(E.ssn) as emp_count from DEPARTMENT D join EMPLOYEE E 
on E.dno = D.dnumber 
where E.salary > 30000.00
group by D.dname
having COUNT(E.ssn) >=2
order by D.dname;

--Find the name of the departments with most number of employees
select * from DEPARTMENT
select * from EMPLOYEE

select max(total_emp) max_emp from (
select d.dname,count(e.ssn) total_emp from DEPARTMENT d 
join EMPLOYEE e 
on d.dnumber = e.dno 
group by d.dname) inn

select d.dname,count(e.ssn) total_emp from DEPARTMENT d 
join EMPLOYEE e 
on d.dnumber = e.dno 
group by d.dname
having COUNT(e.ssn)= (select max(total_emp) max_emp from (
select d.dname,count(e.ssn) total_emp from DEPARTMENT d 
join EMPLOYEE e 
on d.dnumber = e.dno 
group by d.dname) inn);

-- Find the number of employees for each project:         
select * from WORKS_ON
select * from PROJECT

select p.pname, count(w.essn) as tot_emp from WORKS_ON w join project p 
on p.pnumber = w.pno
group by p.pname

--Find the fname and lname of the employees with the most number of dependents
select * from EMPLOYEE
select * from DEPENDENT

select max(total_dep) max_emp from (
select e.ssn,count(d.essn) as total_dep from DEPENDENT d 
join EMPLOYEE e 
on d.essn = e.ssn 
group by e.ssn) inn

select e.fname,e.lname,e.ssn, count(d.essn) total_emp from DEPENDENT d 
join EMPLOYEE e 
on d.essn = e.ssn 
group by e.fname,e.lname,e.ssn
having COUNT(d.essn)= (select max(total_emp) max_emp from (
select d.essn,count(d.essn) total_emp from DEPENDENT d 
join EMPLOYEE e 
on d.essn = e.ssn 
group by d.essn) inn)

--Find the fname and lname of the employees with more than 2 dependents and work on 
--more than 2 projects

select r.fname, r.lname,r.ssn,p.tot_project_count from(select e.fname,e.lname,e.ssn, count(d.essn) total_dep from DEPENDENT d 
join EMPLOYEE e 
on d.essn = e.ssn 
group by e.fname,e.lname,e.ssn
having COUNT(d.essn)= (select max(total_dep) max_dep from (
select d.essn,count(d.essn) total_dep from DEPENDENT d 
join EMPLOYEE e 
on d.essn = e.ssn 
group by d.essn) inn)) r join (select e.fname, e.lname,e.ssn, count(w.essn) as tot_project_count 
from EMPLOYEE e join WORKS_ON w 
on e.ssn = w.essn
group by e.fname,e.lname, e.ssn
having COUNT(w.essn) > 2) p
on r.ssn = p.ssn
group by r.fname, r.lname, r.ssn, p.tot_project_count
order by p.tot_project_count

--subquerying 

select fname, lname from EMPLOYEE where ssn in (
select essn from DEPENDENT group by essn having COUNT(dependent_name) >2) and
ssn in (select essn from WORKS_ON group by essn having count(pno) >2);



select * from EMPLOYEE
select * from PROJECT
select * from WORKS_ON

select e.fname, e.lname,e.ssn, count(w.essn) as tot_project_count 
from EMPLOYEE e join WORKS_ON w 
on e.ssn = w.essn
group by e.fname,e.lname, e.ssn
having COUNT(w.essn) > 2
order by e.ssn

--Using 'WTIH' clause to get the employee count for each department
WITH temporaryTable as
    (select  d.dname, count(e.ssn) emp_count, e.dno 
from DEPARTMENT d join EMPLOYEE e 
on e.dno = d.dnumber 
group by d.dname, e.dno)
        select e.ssn, e.dno,p.emp_count 
		from EMPLOYEE e join temporaryTable p
on e.dno = p.dno
order by e.dno;

--using partition by for the to get the emp_count against total employees count
select ssn,dno, count(ssn) OVER (PARTITION BY dno) as emp_count, 
count(ssn) over () as tot_employees 
from EMPLOYEE

-- using partition by to get the rank
select fname,dno, salary, rank() over (order by salary desc) r, 
rank() over (partition by dno order by salary desc)
from EMPLOYEE
order by 4

-- using partition by to get the dense rank
select fname,dno, salary, dense_rank() over (order by salary desc) r, 
dense_rank() over (partition by dno order by salary desc)
from EMPLOYEE
order by 4

-- using partition by to get the row num
select fname,dno, salary, sex ,
row_number() over (partition by dno, sex order by salary desc)
from EMPLOYEE
order by 4

--fname, salary, avg salary, avg salary per department, dname

select e.fname, e.salary, d.dname, AVG(salary) over (partition by e.dno) avg_sal_dno,
AVG(salary) over () total_avg_sal
from EMPLOYEE e join DEPARTMENT d  
on e.dno = d.dnumber

--fname, overall ranks based on salary
select fname, rank() over (order by salary desc) r
from EMPLOYEE
order by 2
--grading based on overall ranks
WITH temporaryTable as
    (select fname, rank() over (order by salary desc) r
from EMPLOYEE)
        select fname,r,
		(CASE 
			WHEN r <= 3 THEN  'Grade 1'
			WHEN r > 3 and r < 6 THEN  'Grade 2'
			ELSE  'Grade 3'
		END) as grades
		from temporaryTable

----------------------------------------------------------------------
CREATE TABLE test_table (
    id INT,
    name VARCHAR(10) NOT NULL
);



INSERT INTO test_table(id,name) 
VALUES(1,'A'),
      (2,'B'),
      (2,'B'),
      (3,'C'),
      (3,'C'),
      (3,'C'),
      (4,'D');

-- using 'WITH' clause with partition by to get the row_number

WITH temporaryTable as
    (select id, name, row_number() over (partition by id order by id desc) temp
from test_table)
        select id, name 
		from temporaryTable where temp =1

select * from test;

---Analytical Functions  - LEAD and LAG
select fname,dno, salary, 
lead(salary) over (order by salary desc) nextsal, lead(fname) over (order by salary desc) nextname,
lag(salary) over (order by salary desc) prevsal, lag(fname) over (order by salary desc) prevname,
lead(salary) over (partition by dno order by salary desc) nextsal, 
lead(fname) over (partition by dno order by salary desc) nextname
from EMPLOYEE
order by 2

---------------------------------------------------------------------
CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);
 
INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

--row_number
select sales_employee, fiscal_year, sale, 
max(sale) OVER (PARTITION BY fiscal_year) as max_sale,
row_number() over (partition by fiscal_year order by fiscal_year desc) as rownum
from sales;

select * from sales order by fiscal_year;
--retrieving max sale with row_number
WITH tempTable as
    (select sales_employee, fiscal_year, sale, 
max(sale) OVER (PARTITION BY fiscal_year) m,
row_number() over (partition by fiscal_year order by fiscal_year desc) r
from sales)
        select sales_employee, fiscal_year, sale 
		from tempTable where r =1











