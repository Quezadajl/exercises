
WITH temp_table AS (
	SELECT f.film_id,
	rental_rate * COUNT(customer_id) AS pre
	FROM film AS f
	INNER JOIN inventory AS inv
		ON f.film_id = inv.film_id
	INNER JOIN rental AS r
		ON inv.inventory_id = r.inventory_id
	GROUP BY f.film_id)

SELECT film_id, SUM(pre) AS Revenue
FROM temp_table
GROUP BY film_id
ORDER BY Revenue DESC;