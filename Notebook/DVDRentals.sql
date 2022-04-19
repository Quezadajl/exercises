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