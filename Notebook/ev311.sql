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
---Cleaning up evanston 311 data---
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
SELECT DISTINCT category, rtrim(split_part(category,'-',1)) AS standardized
FROM ev311;
UPDATE recode SET standardized='Trash Cart'
WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal'
WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED'
WHERE standardized IN ('THIS REQUEST IS INACTIVE...TRASH CART', '(DO NOT USE) WATER BILL','DO NOT USE Trash', 'NO LONGER IN USE');

SELECT standardized, COUNT(*)
FROM ev311
LEFT JOIN recode
ON ev311.category = recode.category
GROUP BY standardized
ORDER BY COUNT DESC;
-----Creating a table with indicator variables--
DROP TABLE IF EXISTS indicators;

CREATE TEMP TABLE indicators AS
SELECT id, 
	CAST(description LIKE '%@%' AS integer) AS email,
	CAST(description LIKE '%___-___-____%' AS integer) AS phone
FROM ev311;

SELECT priority,
	SUM(email)/COUNT(*)::numeric AS email_prop,
	SUM(phone)/COUNT(*)::numeric AS phone_prop
FROM ev311
LEFT JOIN indicators
ON ev311.id = indicators.id
GROUP BY priority;
-----Chapter 4: Date and Time----
SELECT COUNT(*)
FROM ev311
WHERE date_created::date = '2017-01-31';
---Filter in between dates---
SELECT COUNT(*)
FROM ev311
WHERE date_created >= '2016-02-29'
AND date_created < '2016-03-01';
----Different filter request---
SELECT COUNT(*)
FROM ev311
WHERE date_created >= '2017-03-13'
AND date_created < '2017-03-13'::date + 1;