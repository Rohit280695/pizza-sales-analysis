CREATE TABLE pizza_sales (
    pizza_id INTEGER,
    order_id INTEGER,
    pizza_name_id VARCHAR(50),
    quantity INTEGER,
    order_date VARCHAR(20),
    order_time VARCHAR(20),
    unit_price NUMERIC(6,2),
    total_price NUMERIC(8,2),
    pizza_size VARCHAR(5),
    pizza_category VARCHAR(50),
	pizza_ingredients VARCHAR(200),
    pizza_name VARCHAR(100)
);

SELECT * FROM pizza_sales
LIMIT 10;

ALTER TABLE pizza_sales
ADD COLUMN order_date_clean DATE; 


UPDATE pizza_sales
SET order_date_clean = TO_DATE(order_date, 'DD-MM-YYY');

SELECT order_date, order_date_clean
FROM pizza_sales
LIMIT 10;


ALTER TABLE pizza_sales
ADD COLUMN order_time_clean TIME;

UPDATE pizza_sales
SET order_time_clean = order_time::time;

SELECT order_time, order_time_clean
FROM pizza_sales
LIMIT 10;

ALTER TABLE pizza_sales
DROP COLUMN order_date,
DROP COLUMN order_time;

ALTER TABLE pizza_sales
RENAME COLUMN order_date_clean TO order_date;

ALTER TABLE pizza_sales
RENAME COLUMN order_time_clean TO order_time;

SELECT * FROM pizza_sales
LIMIT 10;

SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales;

SELECT * FROM pizza_sales
ORDER BY pizza_id, order_id;


SELECT 
	ROUND(SUM(total_price) / COUNT (DISTINCT order_id), 2)
	AS Average_order_value
FROM pizza_sales;



SELECT SUM(quantity) AS total_pizza_sold 
FROM pizza_sales;


SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales;

SELECT 
	ROUND(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT (DISTINCT order_id)AS DECIMAL(10,2)), 2)
	AS Average_pizza_per_order
FROM pizza_sales;


--Hourly Trend for Total Pizza Sold

SELECT
	EXTRACT(HOUR FROM order_time) AS order_hour,
	SUM(quantity) AS total_pizzas
FROM pizza_sales
GROUP BY order_hour
ORDER BY order_hour;


--Weekly Trend for Total orders


SELECT
	EXTRACT(WEEK FROM order_date) AS week_number,
	EXTRACT(YEAR FROM order_date) AS order_year,
	COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY week_number, order_year
ORDER BY week_number, order_year;


-- Percentage of sales by pizza category MONTH wise (MONTH 1 is jan)


SELECT
	pizza_category, SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_category DESC;


SELECT
	pizza_category, 
	ROUND (SUM(total_price)*100/(SELECT SUM(total_price) FROM pizza_sales WHERE EXTRACT(MONTH FROM order_date) = 1), 2) 
	AS percentage
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY pizza_category;


-- Percentage of sales by pizza size QUATERT WISE (1 is 1st quarter of the year)


SELECT
	pizza_size, ROUND( SUM(total_price) * 100/ (SELECT SUM(total_price)FROM pizza_sales WHERE EXTRACT(QUARTER FROM order_date) = 1), 2) AS percentage
FROM pizza_sales
WHERE EXTRACT(QUARTER FROM order_date) = 1
GROUP BY pizza_size;


--Total pizza sold by pizza category


SELECT 
	pizza_category, SUM(quantity) AS total_pizza
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_category DESC;

--Top 5 best sellers (Revenue)

SELECT 
    pizza_name,
    SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;

--BOTTOM 5 PIZZA (Revenue)

SELECT 
    pizza_name,
    SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue ASC
LIMIT 5;

--Top 5 best sellers (QUANTITY)

SELECT 
    pizza_name,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;



--BOTTOM 5 PIZZA (QUANTITY)

SELECT 
    pizza_name,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;

--Top 5 best sellers (orders)

SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

--BOTTOM 5 PIZZA (orders)

SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders
LIMIT 5;




