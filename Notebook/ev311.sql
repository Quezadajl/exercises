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