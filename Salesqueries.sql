-- creating required tables for sample dataset

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Details Table (line items for each order)
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- inserting data into the tables 
-- Insert customers
INSERT INTO customers VALUES (1, 'Rahul Singh', 'rahul@email.com', 'India');
INSERT INTO customers VALUES (2, 'Priya Sharma', 'priya@email.com', 'USA');
INSERT INTO customers VALUES (3, 'Sam Lee', 'sam@email.com', 'UK');

-- Insert products
INSERT INTO products VALUES (1, 'Laptop', 'Electronics', 60000.00);
INSERT INTO products VALUES (2, 'Chair', 'Furniture', 2000.00);
INSERT INTO products VALUES (3, 'Mouse', 'Electronics', 500.00);

-- Insert orders
INSERT INTO orders VALUES (101, 1, '2025-09-10', 62000.00);
INSERT INTO orders VALUES (102, 2, '2025-09-21', 2000.00);

-- Insert order details
INSERT INTO order_details VALUES (1001, 101, 1, 1, 60000.00);
INSERT INTO order_details VALUES (1002, 101, 3, 4, 500.00);
INSERT INTO order_details VALUES (1003, 102, 2, 1, 2000.00);


-- viewing the data in each table
select * from customers
select * from products
select * from orders
select * from order_details

/* What is the total sales amount for each customer? */
select customer_id, sum(total_amount) as totsales from orders group by customer_id

SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Which product has generated the highest revenue?
select product_name, max(price) as highrevenue from products group by product_name order by max(price) desc;

SELECT p.product_id, p.product_name, SUM(od.quantity * od.price) AS revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;


-- What are the total sales by product category?
select category, sum(price) as totsalecatgory from products group by category

SELECT p.category, SUM(od.quantity * od.price) AS total_sales
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category;


-- Who are the top 3 customers by total amount spent?
select top 3 customer_id, total_amount from orders

SELECT top 3 c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- Monthly sales trend for 2025:
SELECT MONTH(order_date) AS month, SUM(total_amount) AS sales
FROM orders
WHERE YEAR(order_date) = 2025
GROUP BY MONTH(order_date)
ORDER BY month;

-- What is the average order value (AOV) for all orders?
select avg(price) as avgordervalue from order_details 

-- List all orders placed in September 2025:
Select * from orders where order_date between '2025-09-01' and '2025-09-30'

-- Write a query using an INNER JOIN to get customer names and the products they have ordered.
select c.customer_name, c.country, p.product_name, p.category from customers as c inner join products p on c.customer_id = p.product_id

-- Write a LEFT JOIN to show all customers and any orders they may have placed (including those with no orders).
select c.customer_name , o.order_date, o.total_amount from customers as c left join orders o on c.customer_id = o.customer_id

-- Write a query using a subquery to find customers who spent above average.
select c.customer_id, c.customer_name from customers c join orders o on c.customer_id = o.customer_id 
group by c.customer_id, c.customer_name
having sum(total_amount) > 
(select avg(total_amount) as avgspent from orders) 

-- Create a view showing the order ID, customer name, total order amount, and order date.
create view order_summary as 
select o.order_id, o.total_amount, o.order_date, c.customer_name from orders o
join customers c on o.customer_id = c.customer_id 

-- Write a query that identifies products that have not been ordered by any customer.
select p.product_id, p.product_name, od.order_detail_id from products p join order_details od 
on p.product_id = od.product_id where order_detail_id is null;

--  Total sales for each month, ordered by month:
select month(order_date) as month, sum(total_amount) as totalsales from orders
group by month(order_date) order by month;