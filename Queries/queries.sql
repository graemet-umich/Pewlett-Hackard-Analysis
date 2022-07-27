SELECT * FROM employees;

-- retirement eligibility queries
-- 21209
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- 22857
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- 23228
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- 23104
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
-- 90398 for just birth constraint
-- 41380 when also include hire constraint
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND    (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create retirement eligibility table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Recreate the retirement_info table with the emp_no column
-- First remove the existing table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- 7.3.3 Joins in Action

-- Joining departments and dept_manager tables
-- shows all employees who ever managed each department
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
       retirement_info.first_name,
       retirement_info.last_name,
       dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables
-- redux: use aliases
SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
       de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
-- redux: use aliases
SELECT d.dept_name,
       dm.emp_no,
       dm.from_date,
       dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Current employees eligible for retirement
SELECT ri.emp_no,
       ri.first_name,
       ri.last_name,
       de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;


-- 7.3.4 Use Count, Group By, and Order By

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- ... and create table
SELECT COUNT(ce.emp_no), de.dept_no
INTO num_ret_elig_by_dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM num_ret_elig_by_dept_no;



-- 7.3.5 Create Additional Lists

---- List 1: Employee Information

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
       e.first_name,
       e.last_name,
       e.gender,
       s.salary,
       de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   AND (de.to_date = '9999-01-01');

-- List 2: Management

-- My try. Uncomment for retirement eligible managers (2)
-- Or use current_emp, which are just those retirement eligible, instead of employees
SELECT d.dept_no,
       d.dept_name,
       e.emp_no,
       e.last_name,
       e.first_name,
       dm.from_date,
       dm.to_date
FROM employees AS e
INNER JOIN dept_manager AS dm
ON (e.emp_no = dm.emp_no)
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
WHERE --(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   --AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   --AND 
   (dm.to_date = '9999-01-01');

-- List of managers per department
-- No filter for current managers (there are 2)
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
    ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
    ON (dm.emp_no = ce.emp_no);
 
-- List 3: Department Retirees

-- Multiple entries per employee result from inclusion of employees'
-- old jobs
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

