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

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER table actor ADD COLUMN description blob;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER table actor DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;