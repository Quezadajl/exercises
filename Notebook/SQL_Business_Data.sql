
WITH temp_table AS (
	SELECT f.film_id, f.title,
	rental_rate * COUNT(customer_id) AS pre
	FROM film AS f
	INNER JOIN inventory AS inv
		ON f.film_id = inv.film_id
	INNER JOIN rental AS r
		ON inv.inventory_id = r.inventory_id
	GROUP BY f.film_id, f.title)

/* Here we are using a CTE to calculate revenue for films
SELECT film_id, title, SUM(pre) AS Revenue
FROM temp_table
GROUP BY film_id, title
ORDER BY Revenue DESC;*/
----
/*Here we are calculating the revenue for film greater than 150 in film_id
SELECT SUM(pre) AS Revenue
FROM temp_table
WHERE film_id > 150;*/