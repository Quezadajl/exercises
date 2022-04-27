WITH temp_table AS (
						SELECT COUNT(customer_id) AS counts
						FROM rental)

SELECT f.film_id,
	SUM(rental_rate * counts) AS revenue
FROM film AS f
INNER JOIN inventory AS inv
	ON f.film_id = inv.film_id
INNER JOIN rental AS r
	ON inv.inventory_id = r.inventory_id
GROUP BY f.film;