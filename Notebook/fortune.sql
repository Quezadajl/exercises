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
---More summary functions: Correlation------
SELECT corr(assets, equity)
FROM fortune;
-----Revenues and Profits--
SELECT corr(revenues, profits) AS rev_profits,
	corr(revenues, assets) AS rev_assets,
	corr(revenues, equity) AS rev_equity
FROM fortune;
----Mean and Median using WITHIN GROUP----
SELECT sector,avg(assets) AS mean,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY assets) AS median
FROM fortune
GROUP BY sector
ORDER BY mean;
---Creating Temporary Tables----
---Trial: top ten companies--
CREATE TEMP TABLE top_companies AS
SELECT rank, title
FROM fortune
WHERE rank <= 10;
--select from temporaty table---
SELECT *
FROM top_companies;
---Insert new columns to temp tables--
INSERT INTO top_companies
SELECT rank, title
FROM fortune
WHERE rank BETWEEN 11 AND 20;
---DELETE TEMP tables---
DROP TABLE top_companies; ---or---=
---DELECT TEMP tables- DROP TABLE IF EXISTS top_companies;
---Practice SESSION---
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
SELECT sector,
	percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
FROM fortune
GROUP BY sector;
---
SELECT * FROM profit80;
---MERGE original and TEMP---
--ADD columns---
SELECT title, fortune.sector, profits, profits/pct80 AS ratio
FROM fortune
LEFT JOIN profit80
ON fortune.sector = profit80.sector
WHERE profits > pct80;
---Summary of the entire chapter- correlations, casting, TEMP Tables and JOINS--
DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune;

-- Select each column, rounding the correlations
SELECT measure, 
       round(profits::numeric, 2) AS profits,
       round(profits_change::numeric, 2) AS profits_change,
       round(revenues_change::numeric, 2) AS revenues_change
  FROM correlations;
  ----Character data types and common issues: chapter 3---
  SELECT rank, COUNT(*)
  FROM fortune
  GROUP BY rank;
  --othe example---
  /* SELECT category, COUNT(*)
  FROM product
  GROUP BY category
  ORDER BY caterory--- This helps to see which if there are any duplicates or if there are any spelling mistakes;*/
  
  