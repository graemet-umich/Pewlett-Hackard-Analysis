--
-- Deliverable 1: The Number of Retiring Employees by Title
--


-- Steps 1-7

-- Create retirement_titles table
DROP TABLE IF EXISTS retirement_titles;

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
