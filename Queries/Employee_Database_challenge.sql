--
-- Deliverable 1: The Number of Retiring Employees by Title
--


-- Steps 1-7

-- Create retirement_titles table
SELECT e.emp_no,
       e.first_name,
       e.last_name,
       ti.title,
       ti.from_date,
       ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS ti
  ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Confirm table
SELECT * FROM retirement_titles
LIMIT 10;


-- Steps 8-15

-- Use Dictinct with Orderby to remove duplicate rows
-- Employee_Challenge_starter_code.sql query template

-- SELECT DISTINCT ON (______) _____,
-- ______,
-- ______,
-- ______

-- INTO nameyourtable
-- FROM _______
-- WHERE _______
-- ORDER BY _____, _____ DESC;

-- Remove duplicate rows in retirement_titles and
-- put result in unique_titles
SELECT DISTINCT ON (rt.emp_no)
       rt.emp_no,
       rt.first_name,
       rt.last_name,
       rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

-- Confirm table
SELECT * FROM unique_titles
LIMIT 10;


-- Steps 16-22

-- Create retiring_titles, the number of retiring employees
-- by job title
SELECT COUNT(emp_no),
       title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Confirm table
SELECT * FROM retiring_titles;



--
-- Deliverable 2: The Employees Eligible for the Mentorship Program
--


-- Steps 1-11

-- Create the mentorship eligibility table
SELECT DISTINCT ON (e.emp_no)
       e.emp_no,
       e.first_name,
       e.last_name,
       e.birth_date,
       de.from_date,
       de.to_date,
       ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
  ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
  ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
  AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Confirm table
SELECT * FROM mentorship_eligibility
LIMIT 10;
