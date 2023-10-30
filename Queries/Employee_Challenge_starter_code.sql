-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
WHERE _______
ORDER BY _____, _____ DESC;


Deliverable 1:
- create a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955
- use the DISTINCT ON statement to create a table that contains the most recent title of each employee
- use the COUNT() function to create a table that has the number of retirement-age employees by most recent job title
- exclude employees who have already left the company