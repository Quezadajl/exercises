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
