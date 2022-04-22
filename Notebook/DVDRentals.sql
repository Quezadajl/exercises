--Introductory query--
SELECT * FROM category;
-----
SELECT title, length
FROM film AS f
INNER JOIN category AS c
ON f.film_id = c.category_id
WHERE c.name = 'Documentary' AND f.rating IN ('G','PG')
ORDER BY length DESC;
------Review the essentials-----------------
SELECT title, description
FROM film AS f
INNER JOIN language AS l
ON f.language_id = l.language_id
WHERE l.name = 'English'
AND f.release_year = 2006;
-------Practice essentials------------
SELECT first_name, last_name, amount
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
WHERE c.activebool = true
ORDER BY amount DESC;
------Transforming your results--------
SELECT district, UPPER(district) AS upper_district,
LOWER(district) AS lower_district
FROM address;
--------Transforming Numbers---S
SELECT replacement_cost, replacement_cost + 2 AS updated_cost,
ROUND(replacement_cost/length,2) AS cost_per_minute
FROM film;
--------Transforming Dates---------
SELECT rental_date, EXTRACT(YEAR FROM rental_date) AS rental_year,
EXTRACT(HOUR FROM rental_date) AS rental_hour
FROM rental;
------------Practice Example-----
SELECT LOWER(title) AS title,
rental_rate AS original_rate,
rental_rate*0.5 AS sale_rate
FROM film
WHERE release_year < '2007';
---------Extracting Practice-----
SELECT payment_date,
EXTRACT(DAY FROM payment_date) AS payment_day,
EXTRACT(YEAR FROM payment_date) AS payment_year,
EXTRACT(HOUR FROM payment_date) AS payment_hour
FROM payment;
-------Working with aggregate functions----
SELECT rating, ROUND(AVG(replacement_cost),2)
FROM film
GROUP BY rating;
-----
SELECT rating,
AVG(replacement_cost) AS avg_cost,
COUNT(rating) AS number_elements,
SUM(replacement_cost) AS total_cost
FROM film
GROUP BY rating;
----String aggregate functions--
SELECT rating,
STRING_AGG(title,',') AS films
FROM film
GROUP BY rating;
-----Practice:Averaging finances----
SELECT active,
COUNT(payment_id) AS num_transaction,
AVG(amount) AS avg_amount,
SUM(amount) AS total_amount
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY active;
-----
SELECT name, STRING_AGG(title, ',') AS film_titles
FROM film AS f
INNER JOIN language AS l
ON f.language_id = l.language_id
WHERE release_year = 2006
AND rating = 'G'
GROUP BY name;
---Challenge--
SELECT rental_duration
FROM film
ORDER BY rental_duration DESC;
----CHAPTER 2: EXPLORE TABLES---
SELECT *
FROM payment
LIMIT 5;
---
SELECT *
FROM pg_catalog.pg_tables;
----
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname = 'public';
------Using catalog to answer business questions----
SELECT EXTRACT(MONTH FROM payment_date) AS month,
	SUM(amount) AS total_payment
	FROM payment
	GROUP BY month;
-------JOIN other tables----
SELECT *
FROM information_schema.columns
WHERE table_schema = 'public';
-----
SELECT table_name,
STRING_AGG(column_name, ',') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;
-----Saving as a VIEW---
/*CREATE VIEW table_columns AS
SELECT table_name, STRING_AGG(column_name,',') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;*/
---Average length of films by category---
SELECT name,
AVG(length) AS average_length
FROM film AS f
INNER JOIN category AS c
ON f.film_id = c.category_id
GROUP BY name
ORDER BY average_length;
-----
SELECT title, COUNT(title)
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY count DESC;
----CH.3 Store and Manage Data---Creating a new table and storing new data---
/*CREATE TABLE zip_distance (
	postal_code INT,
	distance FLOAT
);*/
----
/*INSERT INTO zip_distance (postal_code, distance)
VALUES
(5463,3.4),
(6545, 10.2),
(5658, 1.9);*/
-----
SELECT *
FROM zip_distance;
/* CREATE TABLE family_films AS
SELECT film_id, title
FROM film
WHERE rating = 'G';*/
---UPDATE statement----
/*UPDATE customer
SET email = LOWER(email)
WHERE address_id IN 
	(SELECT address_id
	FROM address
	WHERE district = 'Tennessee');*/
---Example #2---
/*UPDATE film
SET rental_rate = rental_rate + 0.5;*/
---Example 3---
/*UPDATE film
SET rental_rate = rental_rate + 1
WHERE rating = 'R';*/
---
/*UPDATE film
SET rental_rate = rental_rate - 1
WHERE film_id IN
	(SELECT film_id
	FROM actor AS a
	INNER JOIN film_actor AS f
	ON a.actor_id = f.actor_id
	WHERE last_name IN ('WILLIS', 'CHASE','WINSLET','GUINESS','HUDSON'))
-----
DELETE FROM customer
WHERE active = 0;

DELETE FROM customer
WHERE address_id IN
	(SELECT address_id
	FROM address
	WHERE district = 'Tennessee');*/
