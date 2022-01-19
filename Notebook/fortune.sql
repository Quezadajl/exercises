/* exploring a database and its column names*/
---Examining distributions and counting observations of interest.
 SELECT *
 FROM fortune;
/**** count and distinct will printout the number of non-null values and different non-null values respectively******/
SELECT COUNT(DISTINCT rank)
FROM fortune;
/***Below you can use INFORMATION_SCHEMA to count the columns in a table ***/
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'fortune';
/****The example below is to identify if there are any null values**/
SELECT profits_change
FROM fortune
WHERE profits IS NULL;
/*** You can calculate missing values individually from the total count by subtracting from each column***/
SELECT COUNT(*) - COUNT (profits_change) AS missing
FROM fortune;
/***INNER JOIN tables that have common columns and the same values ***/
SELECT c.name
FROM fortune AS f
JOIN company as c
ON f.ticker = c.ticker
ORDER BY c.name DESC;
/***READ an entity relationship diagram**  
Use the code below to count the number of ticker with each type**/
SELECT ticker, COUNT(*) as count
FROM fortune
GROUP BY ticker			
ORDER BY count DESC;
/***Now select the most common ticker and count**/
SELECT company.title, fortune.ticker, fortune.sector
FROM fortune
INNER JOIN company
ON fortune.ticker = company.ticker
WHERE sector='Health Care';
/**Using Coalesce to find the most common industry without count NULL values ***/
SELECT coalesce(industry, sector, 'Unknown') AS industry2, COUNT(*)
FROM fortune
GROUP BY industry2
ORDER BY COUNT DESC
LIMIT 1;
/***USE the above code when  the value you need could be in more than one column**/
/**Self-join to find out which companies are in both tables***/
SELECT company_original.name, fortune.title, rank
---start with original company information
FROM company AS company_original
	---Join to another copy of company with parent
	--- company information by using parent_id and id
LEFT JOIN company AS company_parent
ON company_original.ticker = company_parent.ticker
INNER JOIN fortune 
ON coalesce(company_parent.ticker, company_original.ticker) = fortune.ticker
ORDER BY rank;
/**CAST() OR use the double colon :: EXAMPLE BELOW***/
SELECT profits_change, CAST(profits_change AS integer) AS profits_change_int
FROM fortune;
/***SUMMARY: companies that had a positive revenue change**/
SELECT COUNT(*)
FROM fortune
WHERE revenues_change > 0;
/***Summarizing and aggregating numeric data*****/

SELECT sector, AVG(revenues/employees::numeric) AS avg_rev_employee
FROM fortune
GROUP BY sector
ORDER BY avg_rev_employee;
------Summarize numeric columns---
SELECT sector, 
	min(profits),
	avg(profits),
	max(profits),
	stddev(profits)
FROM fortune
GROUP BY sector
ORDER BY avg;
----Exploring Distributions using trunc--
SELECT trunc(employees, -5) AS employee_bin,COUNT(*)
FROM fortune
GROUP BY employee_bin
ORDER BY employee_bin;