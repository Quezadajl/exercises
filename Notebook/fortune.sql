/* exploring a database and its column names*/
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