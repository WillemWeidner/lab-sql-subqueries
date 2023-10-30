USE sakila;

-- 1.Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT i.film_id, f.title, COUNT(f.title) AS number_of_copies
FROM inventory i
JOIN film f
USING(film_id)
WHERE f.title='Hunchback Impossible' 
GROUP BY film_id;

-- Alternative solution from group
SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = "Hunchback Impossible");


-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film)
ORDER BY f.length DESC;

-- Alternative solution from group
SELECT film_id, title, release_year, length
FROM film
WHERE length > (SELECT avg(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT f.title, fa.actor_id, a.first_name, a.last_name
FROM film f
JOIN film_actor fa
USING(film_id)
JOIN actor a
USING(actor_id)
WHERE f.title = (SELECT f.title FROM film f WHERE f.title="Alone Trip");

-- Alternative solution from group
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id FROM film_actor
	WHERE film_id =
		(
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
		)
	);


-- Bonus

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion.
-- Identify all movies categorized as family films.
-- Category is called "Family" in the category table

SELECT *
FROM category;

SELECT f.film_id, f.title, c.name AS category_name
FROM film f
JOIN film_category fc
USING(film_id)
JOIN category c
USING(category_id)
WHERE c.name="Family";

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins.
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- Relevant tables are customer (customer_id, store_id, address_id) country(country_id)
-- Possible connection via store or address 
    -- address(address_id, city_id)
		-- city(city_id, country_id)
	-- store(store_id, address_id) 
-- Chose city 
	-- wanted connection to country
    
-- Error, Subquery returns more than one row.alter
	-- WHERE co.country = (SELECT co.country FROM country WHERE co.country="Canada");
	-- Therefore IN has to be used
    -- https://stackoverflow.com/questions/28171474/solution-to-subquery-returns-more-than-1-row-error
    
-- Example from class
-- use this list of banks to check which orders relate to these banks
  -- IN (list we created)
  
-- SELECT * FROM bank.order
  -- WHERE bank_to IN (
  -- SELECT bank
  -- FROM bank.trans
  -- WHERE bank <> ''
  -- GROUP BY bank
  -- HAVING AVG(amount) > 5500) 
  -- AND k_symbol <> ' ';
 -- we want k_symbol as non empty

SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
JOIN address a
USING(address_id)
JOIN city ci
USING(city_id)
JOIN country co
USING(country_id)
WHERE co.country IN (SELECT co.country FROM country WHERE co.country="Canada");


-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
-- Find most prolific actor: COUNT(film_id), MAX or ORDER BY DESC LIMIT 1 
-- needed tables: actor, film, film_actor

-- I got stuck

SELECT f.film_id, f.title, a.actor_id
FROM film f
JOIN film_actor fa
USING(film_id)
JOIN actor a
USING(actor_id)
WHERE film_id IN (SELECT f.film_id, f.title, (SELECT film_id FROM film HAVING film_id = COUNT(film_id) ORDER BY COUNT(film_id) DESC LIMIT 1));

SELECT COUNT(f.film_id)
FROM film f
LEFT JOIN 
ON table1.column_name = table2.column_name;

"""SELECT operation FROM (
  SELECT AVG(balance) AS Avg_balance, operation
  FROM bank.trans
  WHERE k_symbol IN (
    SELECT k_symbol AS symbol
    FROM (
      SELECT AVG(amount) AS Average, k_symbol
      FROM bank.order
      WHERE k_symbol <> ' '
      GROUP BY k_symbol
      HAVING Average > 3000
      ORDER BY Average DESC
    ) sub1
  )
  GROUP BY operation
) sub2
ORDER BY Avg_balance
LIMIT 1;"""
