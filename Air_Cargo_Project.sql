           --  CUSTOMER TABLE--

-- CREATE DATABASE air_cargo;
-- USE air_cargo;
-- SELECT DATABASE();
-- CREATE TABLE customer (
-- customer_id INT PRIMARY KEY,
-- first_name VARCHAR(50),
-- last_name VARCHAR(50),
-- date_of_birth DATE,
-- gender VARCHAR(10)
-- );
-- DESC customer;

     --  PASSENGERS TABLE--
-- CREATE TABLE passengers_on_flights(
-- aircraft_id INT,
-- route_id INT,
-- customer_id INT,
-- depart VARCHAR (50),
-- arrival VARCHAR(50),
-- seat_num VARCHAR(10),
-- class_id VARCHAR(20),
-- travel_date DATE,
-- flight_num VARCHAR(20)
-- );
-- DESC passengers_on_flights;
     
     -- CUSTOMER ROUTE--
-- CREATE TABLE routes(
-- route_id INT PRIMARY KEY,
-- flight_num VARCHAR(20),
-- origin_airport VARCHAR(50),
-- destination_airport VARCHAR(50),
-- aircraft_id INT,
-- distance_miles INT CHECK(distance_miles > 0)
-- );
-- DESC ROUTES;
   --   --CUSTOMER TICKET TABLE--
-- CREATE TABLE ticket_details(
-- p_date DATE,
-- customer_id INT,
-- aircraft_id INT,
-- class_id VARCHAR (20),
-- no_of_tickets INT,
-- a_code VARCHAR(10),
-- price_per_ticket DECIMAL(10,2),
-- brand VARCHAR(30)
-- );
-- DESC ticket_details;
-- USE air_cargo;
-- SELECT COUNT(*) FROM customer;
--  SELECT COUNT(*) FROM passengers_on_flights;

-- QUESTION -1 ER DIAGRAM

-- The Air Cargo database consists of four tables:
-- 1. Customer
-- 2. Routes
-- 3. Passengers_on_flights
-- 4. Ticket_Details

-- An ER diagram was created to represent the relationship between these tables.
-- Customer has a one-to-many relationship with Ticket_Details and
-- Passengers_on_flights. Routes has a one-to-many relationship with
-- Passengers_on_flights.


-- QUESTION 2: route_details table
-- CREATE TABLE route_details (
--   route_id INT PRIMARY KEY,
--   flight_num VARCHAR(20) CHECK (flight_num LIKE 'FL%'),
--   origin_airport VARCHAR(50),
--   destination_airport VARCHAR(50),
--   aircraft_id INT,
--   distance_miles INT CHECK (distance_miles > 0)
-- );
-- QUESTION 3: Routes 1 TO 25  travel
-- SELECT * FROM passengers_on_flights where route_id BETWEEN 1 AND 25;

-- QUESTION 4: Business class passengers + revenue
-- SELECT SUM(no_of_tickets) AS total_passengers,
-- SUM(no_of_tickets * price_per_ticket) AS total_revenue
-- FROM ticket_details
-- WHERE class_id= 'Business';
-- SELECT COUNT(*) FROM ticket_details;
-- SELECT DISTINCT customer_id FROM customer LIMIT 10;

-- QUESTION 5: Customer  full name
-- SELECT 
--   CONCAT(first_name, ' ', last_name) AS full_name
-- FROM customer;

-- QUESTION 6 Extract the customers who have registered and booked a ticket


-- SELECT distinct
-- c.customer_id,
-- c.first_name,
-- c.last_name
-- FROM customer c
-- JOIN ticket_details t
-- ON c.customer_id=t.customer_id;

-- QUESTION 7 Identify customer first name and last name based on customer ID and brand (Emirates)

-- SELECT DISTINCT
--     c.first_name,
--     c.last_name
-- FROM customer c
-- JOIN ticket_details t
-- ON c.customer_id = t.customer_id
-- WHERE t.brand = 'Emirates';


-- QUESTION 8 Identify the customers who have travelled by Economy Plus class
-- using GROUP BY and HAVING clause on the passengers_on_flights table

-- SELECT
--     customer_id,
--     COUNT(*) AS total_trips
-- FROM passengers_on_flights
-- WHERE class_id = 'Economy Plus'
-- GROUP BY customer_id
-- HAVING COUNT(*) >= 1;

-- QUESTION 9 Identify whether the revenue has crossed 10000 using IF clause

-- SELECT
--   SUM(no_of_tickets * price_per_ticket) AS total_revenue,
--   IF(SUM(no_of_tickets * price_per_ticket) > 10000,
--      'Yes',
--      'No') AS revenue_crossed_10000
-- FROM ticket_details;

-- QUESTION 10 Create and grant access to a new user to perform operations on a database

-- CREATE USER 'air_user'@'localhost' IDENTIFIED BY 'air123';

-- GRANT SELECT, INSERT, UPDATE, DELETE
-- ON air_cargo.*
-- TO 'air_user'@'localhost';

-- FLUSH PRIVILEGES;

-- QUESTION 11 Find the maximum ticket price for each class

-- SELECT
--   class_id,
--   price_per_ticket,
--   MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_price_per_class
-- FROM ticket_details;'

-- QUESTION 12 Extract the passengers whose route ID is 4

-- CREATE INDEX idx_route_id
-- ON passengers_on_flights(route_id);
-- SELECT * FROM passengers_on_flights 
-- WHERE route_id=4;


-- QUESTION 13 For the route ID 4, view the execution plan

-- EXPLAIN SELECT * FROM passengers_on_flights WHERE route_id=4;

-- QUESTION 14 Calculate total price of all tickets booked by a customer

-- SELECT customer_id,
-- aircraft_id,
-- sum(no_of_tickets*price_per_ticket)  AS total_price
-- from ticket_details
-- group by customer_id, aircraft_id WITH ROLLUP;

-- QUESTION 15 Create a VIEW with only Business class customers along with airline brand

-- CREATE VIEW business_class_customers AS
-- SELECT DISTINCT
--   c.customer_id,
--   c.first_name,
--   c.last_name,
--   t.brand
-- FROM customer c
-- JOIN ticket_details t
-- ON c.customer_id = t.customer_id
-- WHERE t.class_id = 'Business';

-- SELECT * FROM business_class_customers;

-- QUESTION 16 Create a stored procedure to get the details of all passengers

-- DELIMITER $$

-- CREATE PROCEDURE get_passengers_by_route_range (
--     IN start_route INT,
--     IN end_route INT
-- )
-- BEGIN
--     -- Table existence check
--     IF NOT EXISTS (
--         SELECT 1
--         FROM information_schema.tables
--         WHERE table_schema = DATABASE()
--         AND table_name = 'passengers_on_flights'
--     ) THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Table passengers_on_flights does not exist';
--     ELSE
--         SELECT *
--         FROM passengers_on_flights
--         WHERE route_id BETWEEN start_route AND end_route;
--     END IF;
-- END$$

-- DELIMITER ;

-- CALL get_passengers_by_route_range(1, 10);

-- QUESTION 17 Create a stored procedure that extracts all the

-- DELIMITER $$

-- CREATE PROCEDURE get_long_distance_routes()
-- BEGIN
--     SELECT *
--     FROM routes
--     WHERE distance_miles > 2000;
-- END$$

-- DELIMITER ;

-- CALL get_long_distance_routes();

-- QUESTION 18 Create a stored procedure that groups the distance travelled by each flight into three categories
-- Categories:

-- DELIMITER $$

-- CREATE PROCEDURE categorize_flight_distance()
-- BEGIN
--     SELECT 
--         route_id,
--         flight_num,
--         distance_miles,
--         CASE
--             WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'SDT'
--             WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'IDT'
--             ELSE 'LDT'
--         END AS distance_category
--     FROM routes;
-- END$$

-- DELIMITER ;

-- CALL categorize_flight_distance();

-- QUESTION 19 Ticket purchase date, customer ID, class ID + complimentary services (Yes/No)


-- DELIMITER $$

-- CREATE FUNCTION complimentary_service(class_name VARCHAR(20))
-- RETURNS VARCHAR(3)
-- DETERMINISTIC
-- BEGIN
--     RETURN (
--         CASE
--             WHEN class_name IN ('Business', 'Economy Plus') THEN 'Yes'
--             ELSE 'No'
--         END
--     );
-- END$$

-- DELIMITER ;

-- DELIMITER $$

-- CREATE PROCEDURE ticket_complimentary_details()
-- BEGIN
--     SELECT 
--         p_date,
--         customer_id,
--         class_id,
--         complimentary_service(class_id) AS complimentary_services
--     FROM ticket_details;
-- END$$

-- DELIMITER ;

-- CALL ticket_complimentary_details();

-- QUESTION 20

-- SELECT * FROM customer
-- WHERE last_name LIKE '%Scott';


DELIMITER $$

-- CREATE PROCEDURE get_scott_customer()
-- BEGIN
--     DECLARE done INT DEFAULT 0;
--     DECLARE v_customer_id INT;
--     DECLARE v_first_name VARCHAR(50);
--     DECLARE v_last_name VARCHAR(50);

--     DECLARE scott_cursor CURSOR FOR
--         SELECT customer_id, first_name, last_name
--         FROM customer
--         WHERE last_name LIKE '%Scott';

--     
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

--     OPEN scott_cursor;

--     read_loop: LOOP
--         FETCH scott_cursor INTO v_customer_id, v_first_name, v_last_name;

--         IF done = 1 THEN
--             LEAVE read_loop;
--         END IF;

--         -- FIRST record milte hi output de do
--         SELECT v_customer_id AS customer_id,
--                v_first_name AS first_name,
--                v_last_name AS last_name;

--         LEAVE read_loop;
--     END LOOP;

--     CLOSE scott_cursor;
-- END$$

-- DELIMITER ;

-- CALL get_scott_customer();




