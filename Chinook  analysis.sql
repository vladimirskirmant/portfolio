--#1. Show Customers (their full names, customer ID, and country) who are not in the US. (Hint: != or <> can be used to say "is not equal to").

SELECT FirstName, LastName, CustomerId, Country 
FROM chinook.customers 
WHERE Country != "USA";

--#2. Show only the Customers from Brazil
SELECT * FROM chinook.customers 
WHERE Country = "Brazil" ;

--#3. Find the Invoices of customers who are from Brazil. The resulting table should show the customer's full name, Invoice ID, Date of the invoice, and billing country.

SELECT cust.FirstName, cust.LastName, inv.InvoiceId, inv.BillingCountry, inv.InvoiceDate
FROM chinook.invoices AS inv 
LEFT JOIN chinook.customers AS cust 
ON inv.CustomerId = cust.CustomerId 
WHERE inv.BillingCountry = "Brazil";

--#4. Show the Employees who are Sales Agents

SELECT * FROM chinook.Employees
WHERE Title = "Sales Support Agent" ;

--#5. Find a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry FROM chinook.Invoices ;

--#6. Provide a query that shows the invoices associated with each sales agent. The resulting table should include the Sales Agent's full name.

SELECT emp.LastName, emp.Firstname, inv.InvoiceId
FROM chinook.Employees emp 
JOIN chinook.Customers cust ON cust.SupportRepId = emp.EmployeeId
JOIN chinook.Invoices Inv ON Inv.CustomerId = cust.CustomerId;

--#7. Show the Invoice Total, Customer name, Country, and Sales Agent name for all invoices and customers.

SELECT emp.LastName, emp.Firstname, cust.FirstName, cust.LastName, cust.Country, inv.total
FROM chinook.employees emp 
JOIN chinook.Customers cust ON cust.SupportRepId = emp.EmployeeId
JOIN chinook.Invoices Inv ON Inv.CustomerId = cust.CustomerId;

--#8. How many Invoices were there in 2009?

SELECT COUNT(*)
FROM chinook.Invoices
WHERE InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

--#9. What are the total sales for 2009?

SELECT SUM(Total)
FROM chinook.Invoices
WHERE InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

--#10. Write a query that includes the purchased track name with each invoice line ID.

SELECT t.Name, i.InvoiceLineId
FROM chinook.Invoice_items i
JOIN chinook.Tracks t 
ON i.TrackId = t.TrackId;