use sakila;
#1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, " ", last_name)) as 'Actor Name' from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name from actor where first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
SELECT * from actor where last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
SELECT * from actor where last_name like '%LI%' order by last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries:
# Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country 
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER table actor ADD COLUMN description blob;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER table actor DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;

#4b List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(*) >= 2; 

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table 
#as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' and last_name = 'WILLIAMS';

#5a You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address,
# of each staff member. Use the tables staff and address:
Select st.first_name, st.last_name, a.* 
	from staff st 
		inner join address a on st.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
# Use tables staff and payment.
SELECT st.first_name, st.last_name, SUM(p.amount) AS Amount
FROM staff st 
INNER JOIN payment p on st.staff_id = p.staff_id 
WHERE MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY st.first_name, st.last_name;
    
#6c. List each film and the number of actors who are listed for that film.
#Use tables film_actor and film. Use inner join.    
Select f.title, COUNT(*) 'Number of Actors'
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;
SELECT 
f.title, (SELECT COUNT(*) FROM film_actor fa WHERE f.film_id = fa.film_id) 'Number of Actors' 
FROM  film f;
    
#6d How many copies of the film Hunchback Impossible exist in the inventory system?   
SELECT COUNT(*) Copies 
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. 
#List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total amount paid'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;
    
#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q 
#have also soared in popularity. Use subqueries to display the titles of movies 
#starting with the letters K and Q whose language is English.
SELECT title FROM film 
WHERE language_id IN (SELECT language_id FROM language WHERE name = 'English')
and (film_id IN (SELECT film_id FROM film WHERE title like 'K%')
OR film_id IN (SELECT film_id FROM film WHERE title like 'Q%'));

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM actor WHERE actor_id IN ( SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f on fa.film_id = f.film_id 
WHERE f.title = 'Alone Trip');
        
#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';
        
#7d. Sales have been lagging among young families, 
#and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT f.title FROM film f
INNER JOIN film_category fc on fc.film_id = f.film_id
INNER JOIN category c on c.category_id = fc.category_id
WHERE c.name = 'Family';
        
#7e. Display the most frequently rented movies in descending order.
SELECT f.title, count(*) rental FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER by rental DESC;
    
#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) rental FROM store s
INNER JOIN inventory i on s.store_id = i.store_id
INNER JOIN rental r on r.inventory_id = i.inventory_id
INNER JOIN payment p on p.customer_id = r.customer_id
GROUP BY s.store_id
ORDER BY s.store_id DESC;
    
#7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country FROM store s
INNER JOIN address a on s.address_id = a.address_id
INNER JOIN city c on c.city_id = a.city_id
INNER JOIN country co on co.country_id = c.country_id
order by s.store_id desc;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) rental FROM category c
INNER JOIN film_category fc on fc.category_id = c.category_id
INNER JOIN inventory i on i.film_id = fc.film_id
INNER JOIN rental r on r.inventory_id = i.inventory_id
INNER JOIN payment p on p.customer_id = r.customer_id
GROUP BY c.name
ORDER BY sum(p.amount) desc Limit 5;

#8a. In your new role as an executive, 
#you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, 
CREATE VIEW top_five_genres as SELECT c.name, SUM(p.amount) rental FROM category c
INNER JOIN film_category fc on fc.category_id = c.category_id
INNER JOIN inventory i on i.film_id = fc.film_id
INNER JOIN rental r on r.inventory_id = i.inventory_id
INNER JOIN payment p on p.customer_id = r.customer_id
GROUP BY c.name
ORDER BY sum(p.amount) desc Limit 5;

SELECT * FROM top_five_genres;

#8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW top_five_genres;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;