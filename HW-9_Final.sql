/*Homework Assignment
Installation Instructions
Refer to the installation guide to install the necessary files.
Instructions*/

USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.

SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT UPPER (CONCAT(first_name,' ',last_name)) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
--     What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor WHERE first_name ='Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
                     

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
--     so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
--     as the difference between it and VARCHAR are significant).

ALTER TABLE actor 
ADD COLUMN description BLOB;

-- Checking the description data type

UPDATE actor SET description = 99999 WHERE last_name ='WILLIAMS';
SELECT * FROM actor WHERE last_name ='WILLIAMS';
                     

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor DROP COLUMN description;
SELECT * FROM actor;

                     
-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(actor_id) FROM actor
GROUP BY last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(actor_id) FROM actor
GROUP BY last_name
HAVING COUNT(actor_id) >1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SELECT * FROM actor WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
--     if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
SELECT * FROM actor WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
                     

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
--     Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

SHOW CREATE TABLE address;
DESCRIBE address;
                     

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address 
FROM staff
JOIN address ON staff.address_id = address.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film.title, COUNT(i.inventory_id)
FROM film
JOIN inventory i ON film.film_id = i.film_id
WHERE film.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name,c.last_name, SUM(p.amount) AS 'Total Amount Paid'
FROM customer c
JOIN payment p
ON c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;
                     

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting 
--     with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting 
--     with the letters K and Q whose language is English.


SELECT title AS 'Film Title'
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN
	(
    SELECT language_id
	FROM language
	WHERE name='ENGLISH'
    );


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name,last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id 
        FROM film
		WHERE title = 'Alone Trip'
        )
    );


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
--     Use joins to retrieve this information.

SELECT c.first_name,c.last_name,c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city
ON city.city_Id = a.city_id
JOIN country cc
ON cc.country_id = city.country_id
WHERE cc.country='Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT film.title, category.name
FROM film, category, film_category
WHERE category.name = 'Family'
AND film_category.category_id = category.category_id
AND film.film_id = film_category.film_id;


-- 7e. Display the most frequently rented movies in descending order.


SELECT f.title AS 'Film Title', COUNT(r.rental_id) AS 'Frequency of Rentals'
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(payment.amount) AS 'Amount in Dollars'
FROM store
JOIN inventory i
ON store.store_id = i.store_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment
ON r.rental_id = payment.rental_id
GROUP BY store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, cc.country
FROM store
JOIN address a
ON store.address_id = a.address_id
JOIN city
ON city.city_Id = a.city_id
JOIN country cc
ON cc.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables:
--     category, film_category, inventory, payment, and rental.)

SELECT category.name AS 'Genres', SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category fc
ON fc.category_id = category.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment
ON r.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;
                     

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
--     Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE OR REPLACE VIEW Top_five_genres_by_gross_revenue AS 
SELECT category.name AS 'Genres', SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category fc
ON fc.category_id = category.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment
ON r.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_five_genres_by_gross_revenue;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_five_genres_by_gross_revenue;


                     
                     
                     
                     
                     

-- Appendix: List of Tables in the Sakila DB


-- A schema is also available as sakila_schema.svg. Open it with a browser to view.


/*'actor'
'actor_info'
'address'
'category'
'city'
'country'
'customer'
'customer_list'
'film'
'film_actor'
'film_category'
'film_list'
'film_text'
'inventory'
'language'
'nicer_but_slower_film_list'
'payment'
'rental'
'sales_by_film_category'
'sales_by_store'
'staff'
'staff_list'
'store'

Uploading Homework



To submit this homework using BootCampSpot:


Create a GitHub repository.
Upload your .sql file with the completed queries.
Submit a link to your GitHub repo through BootCampSpot.*/