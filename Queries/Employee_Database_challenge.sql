-- DELIVERABLE 1: The Number of Retiring Employees by Title
-- Creating a retirement titles table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = ('9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

-- Creating table for retiring employees by title
SELECT COUNT (ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.title) DESC;

-- reviewing tables
SELECT * FROM unique_titles;
SELECT * FROM retiring_titles;

-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program
-- Creating a mentorship-eligible table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- reviewing table
SELECT * FROM mentorship_eligibility;



-- DATA EXPLORATION: SUPPORTING QUERIES for Deliverable 1 -- 
-- Creating table of total company employees (TCE)
SELECT DISTINCT ON (ti.emp_no) ti.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO dft_tot_emp
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE ti.to_date = ('9999-01-01')
ORDER BY ti.emp_no, ti.to_date DESC;

-- Creating table of TCE by title
SELECT COUNT (tce.emp_no), tce.title
INTO active_emp
FROM dft_tot_emp as tce
GROUP BY tce.title
ORDER BY COUNT (tce.title) DESC;

-- reviewing tables
SELECT * FROM dft_tot_emp;
SELECT * FROM active_emp;

-- counting total company employees (TCE) by title (n= 240,124)
SELECT COUNT (tce.title) as total
FROM dft_tot_emp as tce;

-- counting total retiring employees (n = 72,458)
SELECT COUNT (emp_no) as total
FROM unique_titles;

-- TABLE: percentage of retiring employees per title (IMAGE A)
SELECT count, rt.title,
ROUND(CAST(count AS DECIMAL(7, 2)) * 100/72458, 3) as "percent of total (%)"
INTO rt_title_percent
FROM retiring_titles as rt;

-- counting total retiring engineers (n = 36,291)
SELECT SUM (count)
FROM retiring_titles as rt
WHERE rt.title LIKE '%ngineer%';

-- creating table of retiring employee by department using inner and left join (IMAGE B)
SELECT COUNT (ut.emp_no), 
	d.dept_name
INTO retiring_dept
FROM unique_titles as ut
LEFT JOIN dept_emp as de
ON ut.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;

-- reviewing table
SELECT * FROM unique_titles;
SELECT * FROM retiring_titles;
SELECT * FROM rt_title_percent;
SELECT * FROM retiring_dept;

-- percentage (included) of retiring per department
SELECT count, rd.dept_name,
	 ROUND (CAST (count AS DECIMAL(7, 2)) * 100/72458, 3) as "percent of total (%)"
FROM retiring_dept as rd
INNER JOIN departments as d
ON rd.dept_name = d.dept_name
ORDER BY count DESC;



-- SUPPORTING QUERIES for Deliverable 2 --
-- counting total employees in mentorship eligible (ME) program (n= 1,549)
SELECT COUNT(*) FROM mentorship_eligibility; 

-- creating table for ME by title
SELECT COUNT (me.emp_no), me.title
INTO mentor_title
FROM mentorship_eligibility as me
GROUP BY me.title
ORDER BY COUNT (me.title) DESC;

-- percentage of ME per title (IMAGE C)
SELECT count, mbt.title,
ROUND(CAST(count AS DECIMAL(7, 2)) * 100/1549, 3) as "percent of total (%)"
INTO mentor_title_percent
FROM mentor_title as mbt;

-- use dictinct with orderby to remove duplicate rows in dept_emp
SELECT DISTINCT ON (de.emp_no) de.emp_no,
de.dept_no
INTO current_dept
FROM dept_emp as de
WHERE de.to_date = ('9999-01-01')
ORDER BY de.emp_no;

-- reviewing tables 
SELECT * FROM mentorship_eligibility;
SELECT * FROM dept_emp; -- (x10 (d004, d006), x18 (etc.), x29 (etc.) had duplicates)
SELECT * FROM current_dept;
SELECT * FROM mentor_title;
SELECT * FROM mentor_title_percent;

-- creating table of mentors by department using left and inner join (IMAGE D)
SELECT COUNT (me.emp_no), 
	cd.dept_no,
	d.dept_name
INTO mentor_dept
FROM mentorship_eligibility as me
LEFT JOIN current_dept as cd
ON me.emp_no = cd.emp_no
INNER JOIN departments as d
ON cd.dept_no = d.dept_no
GROUP BY cd.dept_no, d.dept_name
ORDER BY cd.dept_no;

-- reviewing tables
SELECT * FROM mentor_title;
SELECT * FROM mentor_dept;
SELECT * FROM mentor_dept_percent;
SELECT * FROM employees_dept_and_title;

-- percentage of mentors per department
SELECT count, d.dept_name,
	 ROUND (CAST (count AS DECIMAL(7, 2)) * 100/1549, 3) as "percent of total (%)"
INTO mentor_dept_percent
FROM mentor_dept as md
INNER JOIN departments as d
ON md.dept_no = d.dept_no
ORDER BY count DESC;

-- creating table of both retiring and mentoring employees by department and title
SELECT COUNT(ut.emp_no) AS title_count,
       d.dept_name,
       ut.title
INTO employees_dept_and_title
FROM unique_titles AS ut
LEFT JOIN dept_emp AS de 
ON ut.emp_no = de.emp_no
INNER JOIN departments AS d 
ON de.dept_no = d.dept_no
GROUP BY d.dept_name, ut.title
ORDER BY d.dept_name, title_count DESC;
