--In this project I need to check the startup employees and their education.
--1.Display the first and last name of all startup employees. 
--Add a field with the name of the educational institution from which the employee graduated, if this information is known.
SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT OUTER JOIN education AS e ON p.id=e.person_id

--2.For each company, find the number of schools that its employees have graduated from. 
--Enter the name of the company and the number of unique school names. Make the top 5 companies by number of universities.
SELECT c.name,
       COUNT(DISTINCT e.instituition) AS university_amount
FROM company AS c
JOIN people AS p ON c.id=p.company_id
JOIN education AS e ON e.person_id=p.id
GROUP BY c.name
ORDER BY university_amount DESC
LIMIT 5;

--3.Make a list with the unique names of the closed companies for which the first round of funding turned out to be the last.
SELECT DISTINCT name
FROM company AS c
JOIN (SELECT company_id
FROM funding_round
WHERE is_first_round=1 AND is_last_round=1) AS f ON f.company_id=c.id
WHERE status = 'closed'

--4.Make a list of the unique numbers of employees who work for the companies selected in the previous assignment.
SELECT DISTINCT p.id
FROM people AS p
JOIN company AS c ON c.id=p.company_id
WHERE name IN (SELECT DISTINCT name
FROM company AS c
JOIN (SELECT company_id
FROM funding_round
WHERE is_first_round=1 AND is_last_round=1) AS f ON f.company_id=c.id
WHERE status = 'closed');

--5.Make a table that includes unique pairs with employee numbers from the previous task and the educational institution from which the employee graduated.
SELECT DISTINCT p.id,
       e.instituition
FROM people AS p
JOIN education AS e ON p.id=e.person_id
JOIN company AS c ON c.id=p.company_id
WHERE name IN (SELECT DISTINCT name
FROM company AS c
JOIN (SELECT company_id
FROM funding_round
WHERE is_first_round=1 AND is_last_round=1) AS f ON f.company_id=c.id
WHERE status = 'closed')

--6.Count the number of schools for each employee from the previous job.
--When calculating, take into account that some employees may have graduated from the same institution twice.
SELECT DISTINCT p.id,
       COUNT(e.instituition)
FROM people AS p
JOIN education AS e ON p.id=e.person_id
JOIN company AS c ON c.id=p.company_id
WHERE name IN (SELECT DISTINCT name
FROM company AS c
JOIN (SELECT company_id
FROM funding_round
WHERE is_first_round=1 AND is_last_round=1) AS f ON f.company_id=c.id
WHERE status = 'closed')
GROUP BY p.id;

--7.Complete the previous query and display the average number of educational institutions (all, not just unique ones) 
--that employees of different companies graduated from. You only need to print one record, you don't need to group here.
SELECT AVG(university)
FROM 
(SELECT DISTINCT p.id,
       COUNT(e.instituition) AS university
FROM people AS p
JOIN education AS e ON p.id=e.person_id
JOIN company AS c ON c.id=p.company_id
WHERE name IN (SELECT DISTINCT name
FROM company AS c
JOIN (SELECT company_id
FROM funding_round
WHERE is_first_round=1 AND is_last_round=1) AS f ON f.company_id=c.id
WHERE status = 'closed')
GROUP BY p.id) as id_uni

--8.Write a similar query: Enter the average number of schools (all schools, not just unique ones) that Facebook employees graduated from
SELECT AVG(university)
FROM 
(SELECT DISTINCT p.id,
       COUNT(e.instituition) AS university
FROM people AS p
JOIN education AS e ON p.id=e.person_id
JOIN company AS c ON c.id=p.company_id
WHERE name = 'Facebook'
GROUP BY p.id) as id_uni
