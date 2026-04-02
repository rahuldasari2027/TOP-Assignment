CREATE DATABASE Amazon;
USE Amazon;

-- -------------------- TABLES --------------------

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- -------------------- DATA --------------------

INSERT INTO Customers (name, email, country) VALUES
('Amit Sharma', 'amit@gmail.com', 'India'),
('Priya Mehta', 'priya@gmail.com', 'India'),
('John Smith', 'john@gmail.com', 'USA'),
('Mahesh Ram', 'mahesh@gmail.com', 'Australia'),
('Dax Rau', 'dax@gmail.com', 'Japan'),
('Parth Sharma', 'parth@gmail.com', 'Pakistan'),
('Raj Mishra', 'raj@gmail.com', 'USA');   -- FIXED email

INSERT INTO Products (name, category, price, stock) VALUES
('Laptop', 'Electronics', 60000, 10),
('Mobile', 'Electronics', 25000, 15),
('Shoes', 'Fashion', 3000, 25),
('Watch', 'Accessories', 5000, 20),
('TV', 'Electronics', 20000, 12),
('Clothes', 'Fashion', 2500, 8);  -- FIXED price

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2025-10-10', 'Delivered'),
(2, '2025-10-12', 'Pending'),
(3, '2025-10-14', 'Delivered'),
(4, '2025-09-25', 'Arrived'),
(5, '2025-10-03', 'Pending'),
(6, '2025-05-06', 'Arrived');

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 4, 2),
(2, 2, 1),
(3, 3, 3),
(4, 5, 2),   -- FIXED (was unrealistic 7)
(5, 2, 4);

INSERT INTO Payments (order_id, payment_method, amount, payment_date) VALUES
(1, 'Credit Card', 70000, '2025-10-11'),
(2, 'UPI', 25000, '2025-10-13'),
(3, 'Debit Card', 9000, '2025-10-15'),
(4, 'UPI', 10000, '2025-06-04'),
(5, 'Credit Card', 52000, '2025-08-23'),
(6, 'Debit Card', 42000, '2025-03-12');

-- -------------------- QUERIES --------------------

SELECT * FROM Customers WHERE country = 'India';

SELECT * FROM Products WHERE price BETWEEN 10000 AND 100000;

SELECT * FROM Products ORDER BY price DESC LIMIT 2;

SELECT DISTINCT status FROM Orders;

-- JOIN
SELECT o.order_id, c.name, p.name, od.quantity
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id;

-- AGGREGATION
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

SELECT p.category, SUM(od.quantity * p.price) AS revenue
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category;

-- -------------------- VIEW --------------------

CREATE VIEW OrderSummary AS
SELECT o.order_id, c.name AS customer_name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- -------------------- STORED PROCEDURE --------------------

DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT o.order_id, o.status, p.amount, p.payment_date
    FROM Orders o
    JOIN Payments p ON o.order_id = p.order_id
    WHERE o.customer_id = cust_id;
END //
DELIMITER ;

-- -------------------- LOG TABLE (CREATE ONLY ONCE!) --------------------

CREATE TABLE action_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action_type VARCHAR(20),
    old_data TEXT,
    new_data TEXT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------- TRIGGERS --------------------

DELIMITER //

-- BEFORE INSERT
CREATE TRIGGER before_product_insert
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SET NEW.price = 0;
    END IF;
END //

-- AFTER INSERT
CREATE TRIGGER after_customer_insert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO action_log(table_name, action_type, new_data)
    VALUES ('Customers', 'INSERT',
    CONCAT('Name:', NEW.name, ', Email:', NEW.email, ', Country:', NEW.country));
END //

-- BEFORE UPDATE
CREATE TRIGGER before_product_update
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END //

-- AFTER UPDATE
CREATE TRIGGER after_product_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO action_log(table_name, action_type, old_data, new_data)
    VALUES (
        'Products',
        'UPDATE',
        CONCAT('Old:', OLD.name, ',', OLD.price),
        CONCAT('New:', NEW.name, ',', NEW.price)
    );
END //

-- BEFORE DELETE
CREATE TRIGGER before_product_delete
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO action_log(table_name, action_type, old_data)
    VALUES (
        'Products',
        'DELETE',
        CONCAT('Deleted:', OLD.name)
    );
END //

DELIMITER ;