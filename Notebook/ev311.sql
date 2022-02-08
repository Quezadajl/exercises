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
SELECT '2018-01-01'::date + 1;

SELECT '2018-12-10'::date + '1 year 2 days 3 minutes'::interval;
-------
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
WHERE date_created >= '2017-03-13';
-----
SELECT category, AVG(date_completed::date - date_created::date) AS completion_time ---For some reason, I have to used the date CAST so my code can run; otherwise it would be text - text
FROM ev311
GROUP BY category
ORDER BY completion_time DESC;
------Field extraction----
---EXTRACT the month from date_created and count requests---
SELECT date_part('month',date_created::date) AS month, COUNT(*)---I figured out that the reason I have to CAST my date..columns is because they are considered text,I need to used date
FROM ev311
WHERE date_created >= '2016-01-01'
AND date_created < '2018-01-01'
GROUP BY month;
---Get hour and count request---
SELECT date_part('hour',date_completed::date) AS hour, COUNT(*)
FROM ev311
GROUP BY hour
ORDER BY COUNT;
---Variation by day of the week---
SELECT to_char(date_created::date, 'day') AS day, AVG(date_completed::date - date_created::date) AS duration
FROM ev311
GROUP BY day, EXTRACT(DOW FROM date_created::date)
ORDER BY EXTRACT(DOW FROM date_created::date);
---Date truncation---
SELECT date_trunc('month', day) AS month, AVG(COUNT)
FROM(SELECT date_trunc('day',date_created::date) AS day, COUNT(*) AS COUNT FROM ev311 GROUP BY day) AS daily_count
GROUP BY month
ORDER BY month;
---------FIND THE MISSING DATES--=
SELECT day ---subquery to generate all dates from min to max in date_created
FROM (SELECT generate_series(MIN(date_created::date), MAX(date_created::date), '1 day')::date AS day FROM ev311) AS all_dates
WHERE day NOT IN ---subquery to select all date_created values as dates
	(SELECT date_created::date FROM ev311);
---Generate 6 month bins covering 2016-01-01 and 2018-06-30--
SELECT generate_series('2016-01-01','2018-01-01','6 month'::interval) AS lower,
	generate_series('2016-07-01','2018-07-01','6 months'::interval) AS upper;
---Count number of requests made per day--
SELECT day, COUNT(date_created) AS count
FROM( SELECT generate_series('2016-01-01', '2018-06-30', '1 day'::interval)::date AS day) AS daily_series
LEFT JOIN ev311
ON day = date_created::date
GROUP BY day;
---Monthly average with missing dates---
WITH all_days AS
	(SELECT generate_series('2016-01-01','2018-06-30','1 day'::interval) AS date),
	daily_count AS
	(SELECT date_trunc('day', date_created::date) AS day, COUNT(*) AS count
	FROM ev311
	GROUP BY day)
SELECT date_trunc('month', date) AS month, AVG(COALESCE(count, 0)) AS average
FROM all_days
LEFT JOIN daily_count
ON all_days.date = daily_count.day
GROUP BY month
ORDER BY month;
------Compute the longest gap---
WITH request_gaps AS (
	SELECT date_created, LAG(date_created) OVER (ORDER BY date_created) AS previous, date_created::date - LAG(date_created::date) OVER(ORDER BY date_created) AS gap FROM ev311)

SELECT *
FROM request_gaps
WHERE gap = (SELECT MAX(gap)
				FROM request_gaps);
------Summary of Chapter---
SELECT date_trunc('day',date_completed::date - date_created::date) AS completion_time, COUNT(*)
FROM ev311
WHERE category = 'Rodents- Rats'
GROUP BY completion_time
ORDER BY completion_time;
----
SELECT category, AVG(date_completed::date - date_created::date) AS avg_completion_time
FROM ev311
WHERE date_completed::date - date_created::date < (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed::date - date_created::date) FROM ev311)
GROUP BY category
ORDER BY avg_completion_time DESC;
--------
SELECT corr(avg_completion, COUNT)
FROM (SELECT date_trunc('month', date_created) AS month, AVG(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, COUNT(*) AS count
	 FROM ev311 WHERE category ='Rodents- Rats'
	 GROUP BY month)
	 AS monthly_avgs;
------
