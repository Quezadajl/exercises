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
----Check for distribution errors---
SELECT unanswered_count, count(*)
FROM stackexchange
WHERE tag ='amazon-ebs'
GROUP BY unanswered_count
ORDER BY unanswered_count;
--Use Truncate---
SELECT trunc(42.1256, 2); --positive # makes all place values not selected zeros 
SELECT trunc(12598, -3);--(negative values does the same thing past zero)
-----
SELECT trunc(unanswered_count, -1) AS trunc_ua, COUNT(*)
FROM stackexchange
WHERE tag = 'amazon-ebs'---this will tell us how many values between 30  and 40
GROUP BY trunc_ua
ORDER BY trunc_ua;