-- Creating a Customer Summary Report
-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

use sakila;

-- 1.

CREATE VIEW customer_summary AS
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        COUNT(r.rental_id) as rental_count
    FROM
        customer c
            JOIN
        rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT * FROM customer_summary;

-- 2. create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_total_paid AS
	SELECT 
		cs.customer_id, 
        SUM(p.amount) as total_paid
	FROM 
		customer_summary cs
		JOIN 
		payment p ON cs.customer_id = p.customer_id
GROUP BY cs.customer_id;

SELECT * FROM customer_total_paid;

DROP TEMPORARY TABLE costumer_total_paid;

-- 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH sakila_cte AS (
    SELECT
    customer_id,
    first_name,
    last_name,
    email,
    rental_count
    FROM 
		customer_summary
)
SELECT first_name,
    sc.last_name,
    sc.email,
    sc.rental_count,
    ct.total_paid
FROM 
	sakila_cte sc
	JOIN
	customer_total_paid ct ON sc.customer_id = ct.customer_id;
    

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, 
-- email, rental_count, total_paid and average_payment_per_rental,this last column is a derived column from total_paid and rental_count.

WITH sakila_cte AS (
    SELECT 
        customer_id,   
        first_name,
        last_name,
        email,
        rental_count
    FROM 
        customer_summary
)
SELECT 
    sc.first_name,
    sc.last_name,
    sc.email,
    sc.rental_count,
    ct.total_paid,
    ct.total_paid / sc.rental_count AS average_payment_per_rental
FROM 
    sakila_cte sc
JOIN 
    customer_total_paid ct ON sc.customer_id = ct.customer_id;