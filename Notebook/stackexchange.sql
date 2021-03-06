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
---Use Generate Series to create Bins(like a histogram)---
WITH bins AS (
	SELECT generate_series(30,60,5) AS lower,
	generate_series(35,65,5) AS upper),
	--subset data to tag of interest--
	ebs AS (
	SELECT unanswered_count
	FROM stackexchange
	WHERE tag='amazon-ebs')
SELECT lower, upper, count(unanswered_count)
FROM bins
LEFT JOIN ebs
ON unanswered_count >= lower
AND unanswered_count < upper
GROUP BY lower, upper
ORDER BY lower;
-----Generate Series: step 1-----
SELECT MIN(question_count),MAX(question_count)
FROM stackexchange
WHERE tag='dropbox';
-----Generate Series: step 2-----
SELECT generate_series(2200,3050,50) AS lower,
	generate_series(2250,3100,50) AS upper,
-----Generate Series: step 3-----
WITH bins AS (
	SELECT generate_series(2200,3050,50) AS lower,
	generate_series(2250,3100,50) AS upper),
	---subset stackoverflow to just tag dropbox---
	dropbox AS (
	SELECT question_count
	FROM stackexchange
	WHERE tag = 'dropbox')
	----select columns for results---
SELECT lower, upper, COUNT(question_count)
FROM bins
LEFT JOIN dropbox
ON question_count >= lower
AND question_count < upper
GROUP BY lower, upper
ORDER BY lower
---More summary functions: Correlation------
SELECT corr(unanswered_count, unanswered_pct)
FROM stackexchange;
----CREATING AND USING TEMP TABLES----
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, MIN(date) AS mindate
FROM stackexchange
GROUP BY tag;

SELECT * FROM startdates;
---JOIN TO TEMP TABLE TWICE OVER!!!!----
SELECT startdates.tag, mindate, so_min.question_count AS min_date_question_count,
	so_max.question_count AS max_date_question_count,
	so_max.question_count - so_min.question_count AS change
FROM startdates
INNER JOIN stackexchange AS so_min
ON startdates.tag = so_min.tag
AND startdates.mindate = so_min.date
INNER JOIN stackexchange AS so_max
ON startdates.tag = so_max.tag
AND so_max.date = '2018-09-25';
----datetime practice---
SELECT *
FROM stackexchange
WHERE date >= '2018-01-01'
AND date < '2018-05-01';
---Extract to summarize by field----
SELECT date_part('month',date) AS month, SUM(question_count)
FROM stackexchange
GROUP BY month
ORDER BY month;
------
SELECT EXTRACT(MONTH FROM date) AS month, SUM(question_count)
FROM stackexchange
GROUP BY month
ORDER BY month;