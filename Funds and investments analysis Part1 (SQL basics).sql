--In this project, I analyze data on funds and investments and write queries to the database.
--1.I count how many companies actually closed
SELECT COUNT(status)
FROM company
WHERE status = 'closed'

--2. Display the amount of funds raised for U.S. news companies. 
--Use the data from the company table. 
--Sort the table in descending order of values in the funding_total field.
SELECT funding_total
FROM company
WHERE category_code = 'news'
      AND country_code = 'USA'
ORDER BY funding_total DESC;

--3. Find the total amount of transactions for the purchase of some companies by others in dollars.
--Select transactions that were made only for cash from 2011 to 2013 inclusive.
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code='cash'
      AND EXTRACT(YEAR FROM CAST(acquired_at AS date)) IN ('2011', '2012', '2013')

--4. Display the first name, last name, and account names of people in the network_username field whose account names start with 'Silver'.
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%'

--5. Display all the information about people whose account names in the network_username field contain the substring 'money' and 
--their last name starts with 'K'.
SELECT *
FROM people
WHERE twitter_username LIKE '%money%'
      AND last_name LIKE 'K%'

--6.For each country, display the total amount of attracted investments received by companies registered in that country. 
--The country in which the company is registered can be identified by the country code. 
--Sort the data in descending order of amount.
SELECT country_code,
       SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;

--7. Make a table that includes the date of the round, as well as the minimum and maximum values of the amount of investments raised on this date.
--Leave only those records in the summary table where the minimum value of the investment amount is not zero and is not equal to the maximum value.
SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount)!=0 AND
      MIN(raised_amount)!= MAX(raised_amount)

--8.Create a field with categories:
--For funds that invest in 100 or more companies, assign a high_activity category.
--For funds that invest in 20 or more companies up to 100, assign a middle_activity category.
--If the number of investee companies in the fund does not reach 20, assign a category low_activity.
--Display all the fields in the fund table and the new category field

SELECT *,
            CASE
                 WHEN invested_companies >= 100 THEN 'high_activity'
                 WHEN invested_companies >=20 THEN 'middle_activity'
                 WHEN invested_companies <20 THEN 'low_activity'
           END
FROM fund;

--9.For each of the categories assigned in the previous task, calculate the average number of investment rounds in which the fund participated,
--rounded to the nearest whole number. Display the categories and the average number of investment rounds.Sort the table in ascending order of average.
SELECT t1.activity,
       ROUND(AVG(investment_rounds),0) AS avg_investment_rounds
FROM (SELECT *,
             CASE
                WHEN invested_companies>=100 THEN 'high_activity'
                WHEN invested_companies>=20 THEN 'middle_activity'
                ELSE 'low_activity'
             END AS activity
       FROM fund) AS t1
GROUP BY t1.activity
ORDER BY avg_investment_rounds 

--10.Analyze the countries in which the funds that most often invest in startups are located. 
--For each country, calculate the minimum, maximum, and average number of companies in which that country's funds have invested from 2010 to 2012 inclusive.
--Exclude countries with funds where the minimum number of companies that have received investments is zero. 
--Download the ten most active investor countries: sort the table by the average number of companies from largest to smallest.
--Then, add sorting by country code in lexicographic order.
SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) IN ('2010','2011','2012')
GROUP BY country_code
HAVING MIN(invested_companies) !=0
ORDER BY AVG(invested_companies) DESC,
      country_code
LIMIT 10