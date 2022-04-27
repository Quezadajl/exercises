
SELECT f.film_id,
	rental_rate * COUNT(customer_id) AS part
FROM film AS f
INNER JOIN inventory AS inv
	ON f.film_id = inv.film_id
INNER JOIN rental AS r
	ON inv.inventory_id = r.inventory_id
GROUP BY f.film_id;