/* exploring a database and its column names*/
 
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
/*** ***/
