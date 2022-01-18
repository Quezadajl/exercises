SELECT *
FROM stackexchange;
/***count the number of columns of non-NULL values with DISTINCT*/
SELECT COUNT(DISTINCT tag)
FROM stackexchange;
/***Below you can use INFORMATION_SCHEMA to count the columns in a table ***/
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'stackexchange';
/****/
SELECT tag, COUNT(*) AS count
FROM stackexchange
GROUP BY tag
ORDER BY count DESC;
/****/
SELECT question_count
FROM stackexchange
WHERE question_count IS NOT NULL;
/**Numeric Data types & Summary functions**/
SELECT max(question_pct) --also min; avg
FROM stackexchange;
/**variance and Standard Deviation*/
SELECT var_pop(question_pct) 
FROM stackexchange;
---AND----
SELECT round(stddev(question_pct),5)
FROM stackexchange;
---Summarize Variables by groups in the data---
SELECT tag, 
	min(question_pct),
	avg(question_pct),
	max(question_pct)
FROM stackexchange
GROUP BY tag;
