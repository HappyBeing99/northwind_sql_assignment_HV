use northwind;

-- Question 1 (Marks: 2)
-- Objective: Retrieve data using basic SELECT statements
-- Question: List the names of all customers in the database. 

SELECT CustomerName FROM customers;

-- Question 2 (Marks: 2)
-- Objective: Apply filtering using the WHERE clause 
-- Question: Retrieve the names and prices of all products that cost less than $15. 

SELECT ProductName, Price FROM products WHERE Price < 15;

-- Question 3 (Marks: 2)
-- Objective: Use SELECT to extract multiple fields
-- Question: Display all employees’ first and last names. 

SELECT FirstName, LastName FROM employees;

-- Question 4 (Marks: 2)
-- Objective: Filter data using a function on date values 
-- Question: List all orders placed in the year 1997.

SELECT OrderID, CustomerID, EmployeeID, OrderDate FROM orders WHERE YEAR(OrderDate) = 1997;
 
-- Question 5 (Marks: 2)
-- Objective: Apply numeric filters 
-- Question: Retrieve the names of all products that are currently in stock (UnitsInStock > 0). 

SELECT ProductName, Unit FROM products WHERE Unit > 0;

-- Question 6 (Marks: 3)
-- Objective: Perform multi-table JOIN operations 
-- Question: Show the names of customers and the names of the employees who handled their orders. 

SELECT orders.orderID, customers.CustomerName AS customer_name, employees.FirstName AS employee_first_name, employees.LastName AS employee_last_name
FROM orders
JOIN customers ON orders.CustomerID = customers.CustomerID
JOIN employees ON orders.EmployeeID = employees.EmployeeID;

-- Question 7 (Marks: 3)
-- Objective: Use GROUP BY for aggregation
-- Question: List each country along with the number of customers from that country.  

SELECT Country, COUNT(CustomerID) AS total_customers
FROM customers
GROUP BY Country
ORDER BY total_customers DESC;

-- Question 8 (Marks: 3)
-- Objective: Group data by a foreign key relationship and apply aggregation 
-- Question: Find the average price of products grouped by category. 

SELECT categories.CategoryName, AVG(products.Price) AS average_price
FROM products
JOIN categories ON products.CategoryID = categories.CategoryID
GROUP BY categories.CategoryName
ORDER BY average_price DESC;

-- Question 9 (Marks: 3)
-- Objective: Use aggregation to count records per group 
-- Question: Show the number of orders handled by each employee. 

SELECT employees.FirstName, employees.LastName, COUNT(orders.OrderID) AS total_orders
FROM employees
JOIN orders ON employees.EmployeeID = orders.EmployeeID
GROUP BY employees.EmployeeID, employees.FirstName, employees.LastName
ORDER BY total_orders DESC;

-- Question 10 (Marks: 3)
-- Objective: Filter results using values from a joined table
-- Question: List the names of products supplied by "Exotic Liquid". 

SELECT products.ProductName
FROM products
JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE suppliers.SupplierName = 'Exotic Liquid';


-- Question 11 (Marks: 5)
-- Objective: Rank records using aggregation and sort
-- Question: List the top 3 most ordered products (by quantity). 

SELECT products.ProductName, SUM(orderdetails.Quantity) AS total_quantity
FROM orderdetails
JOIN products ON orderdetails.ProductID = products.ProductID
GROUP BY products.ProductID, products.ProductName
ORDER BY total_quantity DESC
LIMIT 3;

-- Question 12 (Marks: 5)
-- Objective: Use GROUP BY and HAVING to filter on aggregates 
-- Question: Find customers who have placed orders worth more than $10,000 in total.

SELECT 
    customers.customerName, SUM(orderdetails.Quantity * products.Price) AS total_order_value
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
JOIN orderdetails ON orders.OrderID = orderdetails.OrderID
JOIN products ON orderdetails.ProductID = products.ProductID
GROUP BY customers.CustomerID, customers.customerName
HAVING SUM(orderdetails.Quantity * products.Price) > 10000
ORDER BY total_order_value DESC;

-- Question 13 (Marks: 5)
-- Objective: Aggregate and filter at the order level 
-- Question: Display order IDs and total order value for orders that exceed $2,000 in value. 

SELECT 
    o.OrderID,
    SUM(od.Quantity * p.Price) AS total_order_value
FROM orders o
JOIN orderdetails od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID
HAVING SUM(od.Quantity * p.Price) > 2000
ORDER BY total_order_value DESC;

-- Question 14 (Marks: 5)
-- Objective: Use subqueries in HAVING clause
-- Question: Find the name(s) of the customer(s) who placed the largest single order (by value).

SELECT c.CustomerName, o.OrderID, SUM(od.Quantity * p.Price) AS order_value
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID, c.CustomerName
HAVING SUM(od.Quantity * p.Price) = (
    SELECT MAX(order_total) FROM (
        SELECT SUM(od2.Quantity * p2.Price) AS order_total
        FROM orders o2
        JOIN orderdetails od2 ON o2.OrderID = od2.OrderID
        JOIN products p2 ON od2.ProductID = p2.ProductID
        GROUP BY o2.OrderID
    ) AS order_sums
)
ORDER BY order_value DESC;

-- Question 15 (Marks: 5)
-- Objective: Identify records using NOT IN with subquery 
-- Question: Get a list of products that have never been ordered.

SELECT p.ProductName
FROM products p
LEFT JOIN orderdetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;