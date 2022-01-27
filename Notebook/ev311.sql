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