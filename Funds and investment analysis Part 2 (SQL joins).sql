--11. Make a table of the following fields: 
--name_of_fund is the name of the fund;
--name_of_company is the name of the company;
--amount: the amount of investment that the company raised in the round.
--The table will include data on companies with more than six important milestones in their history, and funding rounds took place from 2012 to 2013 inclusive.
SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
       

FROM investment AS i
LEFT JOIN company AS c ON i.company_id=c.id
LEFT JOIN fund AS f ON i.fund_id=f.id
LEFT JOIN funding_round AS fr ON i.funding_round_id=fr.id
WHERE i.company_id IN (SELECT id
                     FROM company
                     WHERE milestones > 6)
                   AND EXTRACT(YEAR FROM funded_at) IN (2012, 2013);

--12. Upload a table with the following fields:
--the name of the buyer company;
--the amount of the transaction;
--the name of the company you bought;
--the amount of investment made in the purchased company;
--Share, which shows how many times the purchase amount exceeded the amount of investment made in the company, rounded to the nearest whole number.
--Sort the table by the amount of the transaction from largest to smallest, and then by the name of the purchased company in lexicographic order. 
--Limit the table to the first ten records.
SELECT cing.name AS bying_company,
       SUM(a.price_amount) AS perchase_amount,
       ced.name AS bought_company,
       SUM(ced.funding_total) AS investment_amount,
       ROUND(SUM(a.price_amount)/SUM(ced.funding_total),0) AS share
FROM acquisition AS a
LEFT JOIN company AS cing ON a.acquiring_company_id=cing.id
LEFT JOIN company AS ced ON a.acquired_company_id=ced.id
GROUP BY cing.name,
         ced.name
HAVING NOT SUM(ced.funding_total)=0
ORDER BY perchase_amount DESC,
         bought_company
LIMIT 10;

--13. Upload a table that includes the names of social companies that received funding from 2010 to 2013 inclusive. 
--Make sure that the investment amount is not zero. Also display the number of the month in which the funding round took place.
SELECT c.name,
       EXTRACT(MONTH FROM CAST(funded_at AS date)) as month
FROM company AS c
INNER JOIN funding_round AS f ON f.company_id=c.id
WHERE f.raised_amount!=0
      AND category_code = 'social' 
      AND EXTRACT(YEAR FROM CAST(funded_at AS date)) IN ('2010','2011','2012','2013')

--14.Take data for the months from 2010 to 2013 when the investment rounds took place.
--Group the data by month number and get a table with the following fields:
--number of the month in which the rounds took place;
--the number of unique U.S. fund names that invested this month;
--Number of companies purchased during this month
--The total amount of purchase transactions for this month.                   
WITH 
t1 AS (SELECT EXTRACT(MONTH FROM CAST(a.acquired_at AS date)) as month,
       COUNT(a.acquired_company_id) AS amount_bought_companies,
       SUM(a.price_amount) AS total_purchase
FROM acquisition AS a
WHERE EXTRACT(YEAR FROM CAST(a.acquired_at AS date)) IN ('2010','2011','2012','2013')
       AND a.acquired_at IS NOT NULL
GROUP BY month
ORDER BY month),
      
t2 AS (SELECT EXTRACT(MONTH FROM CAST(fr.funded_at AS date)) as month,
       COUNT(DISTINCT f.name) AS fund_amount_USA
FROM funding_round AS fr
LEFT JOIN investment AS i ON fr.id=i.funding_round_id
LEFT JOIN fund AS f ON i.fund_id=f.id
WHERE country_code='USA' AND
      fr.funded_at IS NOT NULL
      AND EXTRACT(YEAR FROM CAST(funded_at AS date)) IN ('2010','2011','2012','2013')
GROUP BY month
ORDER BY month)

SELECT t2.month,
       t2.fund_amount_USA,
       t1.amount_bought_companies,
       t1.total_purchase
FROM t1 
JOIN t2 ON t1.month=t2.month

--15.Make a summary table and output the average investment amount for countries that have startups registered in 2011, 2012, and 2013. 
--The data for each year should be in a separate field. Sort the table by average investment for 2011 from highest to lowest.
 WITH
t1 AS (SELECT country_code,
       AVG(funding_total) AS avg_2011
FROM company
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2011
GROUP BY country_code),

t2 AS (SELECT country_code,
       AVG(funding_total) AS avg_2012
FROM company
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2012
GROUP BY country_code),

t3 AS (SELECT country_code,
       AVG(funding_total) AS avg_2013
FROM company
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2013
GROUP BY country_code)

SELECT t1.country_code,
       t1.avg_2011,
       t2.avg_2012,
       t3.avg_2013
FROM t1
JOIN t2 ON t1.country_code=t2.country_code
JOIN t3 ON t2.country_code=t3.country_code
ORDER BY avg_2011 DESC;

