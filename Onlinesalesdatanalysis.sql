-- creating a sample data with required table and its columns


CREATE TABLE online_sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(10,2),
    product_id INT
);

-- inserting the data into online sales table
INSERT INTO online_sales (order_id, order_date, amount, product_id) VALUES
(6, '2025-03-17', 380.50, 103),
(7, '2025-03-28', 615.00, 105),
(8, '2025-04-02', 799.99, 106),
(9, '2025-04-15', NULL, 107),           -- Example with NULL amount
(10, '2025-05-03', 1215.00, 108),
(11, '2025-05-09', 655.00, 104),
(12, '2025-05-10', 920.50, 109),
(13, '2025-06-04', 375.00, 102),
(14, '2025-06-18', 782.60, 103),
(15, '2025-07-07', 1440.00, 101);


 -- How do you group data by month and year?
SELECT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  COUNT(order_id) AS total_orders,
  SUM(amount) AS total_revenue
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

--  Difference between COUNT and COUNT(DISTINCT col)
-- Regular count
SELECT COUNT(product_id) AS total_products FROM online_sales;

-- Distinct count
SELECT COUNT(DISTINCT product_id) AS distinct_products FROM online_sales;

-- Calculate monthly revenue
SELECT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  SUM(amount) AS monthly_revenue
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Aggregate functions in SQL
SELECT
  SUM(amount) AS total_sales,
  AVG(amount) AS average_sale,
  MIN(amount) AS min_sale,
  MAX(amount) AS max_sale
FROM online_sales;


-- Handle NULLs in aggregates
-- Aggregates like SUM, AVG, MIN, MAX ignore NULLs automatically:
SELECT AVG(amount) AS average_sale FROM online_sales;


-- Show monthly sales sorted by revenue
SELECT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  SUM(amount) AS monthly_revenue
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY monthly_revenue DESC;


-- Top 3 months by sales
SELECT TOP 3
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  SUM(amount) AS monthly_revenue
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY monthly_revenue DESC;


-- Total revenue and order count for the entire dataset
SELECT
  COUNT(order_id) AS total_orders,
  SUM(amount) AS total_revenue
FROM online_sales;

--  List total revenue for each product
SELECT
  product_id,
  SUM(amount) AS total_product_revenue
FROM online_sales
GROUP BY product_id
ORDER BY total_product_revenue DESC;

-- Average order amount per month
SELECT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  AVG(amount) AS avg_order_amount
FROM online_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- Identify months with no orders

SELECT DISTINCT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month
FROM online_sales


-- Highest single order (amount, date, product)

SELECT TOP 1
  order_id,
  order_date,
  amount,
  product_id
FROM online_sales
ORDER BY amount DESC;



-- List number of orders per product per month

SELECT
  product_id,
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  COUNT(order_id) AS monthly_orders
FROM online_sales
GROUP BY product_id, YEAR(order_date), MONTH(order_date)
ORDER BY product_id, year, month;


-- Find orders with amount above the overall average

SELECT *
FROM online_sales
WHERE amount > (SELECT AVG(amount) FROM online_sales);

