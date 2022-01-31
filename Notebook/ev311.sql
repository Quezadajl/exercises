SELECT * 
FROM ev311;

/***Below you can use INFORMATION_SCHEMA to count the columns in a table ***/
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'ev311';
/***READ an entity relationship program***/
SELECT priority, COUNT(*) AS count
FROM ev311
GROUP BY priority
ORDER BY count DESC;
----Count Categories---
SELECT category, COUNT(*)
  FROM ev311
  GROUP BY category
  ORDER BY category;
------
SELECT source, COUNT(*)
FROM ev311
GROUP BY source
HAVING COUNT(*) >= 100;
----FIND the 5 most common values of street and the count of each---
SELECT street, COUNT(*)
FROM ev311
GROUP BY street
ORDER BY COUNT(*) DESC
LIMIT 5;
-----ERRORS wiht streets?--
SELECT street, COUNT(*)
FROM ev311
GROUP BY street
ORDER BY street DESC;
----Case sensitive filters with TRIM, LIKE---
SELECT category
FROM ev311
WHERE category ILIKE '%water%';---only includes lower case; ILIKE includes both upper and lower
-----
SELECT trim(lower('Wow!'), '!w');
----
SELECT DISTINCT street, trim(street,'0123456789 #/.') AS cleaned_street
FROM ev311
ORDER BY street;
-----Filtering using Ilike and like---
SELECT category, COUNT(*)
FROM ev311
WHERE (description ILIKE '%trash%' OR description ILIKE '%garbage%')
AND category NOT LIKE '%Trash%' AND category NOT LIKE '%Garbage%'
GROUP BY category
ORDER BY COUNT DESC
LIMIT 10;
----Manipulating strings-----
SELECT TRIM(house_num||' '||street)
FROM ev311;
---
SELECT split_part(street,' ',1) AS street_name, COUNT(*)
FROM ev311
GROUP BY street_name
ORDER BY COUNT DESC
LIMIT 20;
-----Shorten long strings: Practice
---SELECT the first 50 characters of description with '...' concatenated on the end wehre the length() of the description is greater than 50 characters.
--Otherwise just select the description as is. Only words that begin with the letter I not words.----
SELECT
	CASE WHEN length(description) > 50
	THEN left(description, 50)|| '...'
	ELSE description END
FROM ev311
WHERE description LIKE 'I %'
ORDER BY description;
----Strategies for multiple transformations---
---Cleaning up evanston 311 data---
SELECT 
	CASE WHEN zipcount < 100 THEN 1---for some reason 'other' was not being accepted as a label
	ELSE zip
	END AS zip_recoded,
	SUM(zipcount) AS zipsum
FROM (SELECT zip, COUNT(*) AS zipcount
	 FROM ev311
	 GROUP BY zip) AS fullcounts
GROUP BY zip_recoded
ORDER BY zipsum DESC;
	