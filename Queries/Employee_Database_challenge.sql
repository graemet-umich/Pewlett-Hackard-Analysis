-- Deliverable 1: The Number of Retiring Employees by Title


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

