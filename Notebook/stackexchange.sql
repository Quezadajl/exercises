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
-------------- Explore with Division---
----What does the pct of unaswered questions show?--
SELECT unanswered_count/question_count::numeric AS computed_pct,
	unanswered_pct
FROM stackexchange
WHERE question_count > 0
LIMIT 10;
----Summarize results using a SubQuery---
SELECT MIN(maxval),
	MAX(maxval),
	AVG(maxval),
	STDDEV(maxval)
FROM (SELECT MAX(question_count) AS maxval
	 FROM stackexchange
	 GROUP BY tag) AS max_results;