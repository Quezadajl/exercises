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
/*SELECT title, description
FROM film as f
INNER JOIN language AS l
ON f.language_id = l.language_id
WHERE l.name IN ('Italian','French')
AND f.release_year = '2006';*/
SELECT title, description
FROM film;