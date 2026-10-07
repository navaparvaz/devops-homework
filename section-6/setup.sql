-- Create user

CREATE USER IF NOT EXISTS 'webserver'@'localhost' IDENTIFIED BY 'SecurePass123!';



-- Create database

CREATE DATABASE IF NOT EXISTS shopdb;



-- Grant privileges

GRANT ALL PRIVILEGES ON shopdb.* TO 'webserver'@'localhost';

FLUSH PRIVILEGES;



-- Use database

USE shopdb;



-- Create table

DROP TABLE IF EXISTS products;

CREATE TABLE products (

    id INT PRIMARY KEY AUTO_INCREMENT,

    name VARCHAR(100),

    price DECIMAL(10,2),

    stock INT

);



-- Insert data

INSERT INTO products (name, price, stock) VALUES

('Laptop', 1200.00, 10),

('Mouse', 25.50, 100),

('Keyboard', 75.00, 50);



-- 7) Show all

SELECT * FROM products;



-- 8) Show expensive

SELECT * FROM products WHERE price > 100;



-- 9) Add column (fresh table, so no duplicate)

ALTER TABLE products ADD COLUMN category VARCHAR(50);



-- 10) Update stock to 0

UPDATE products SET stock = 0 WHERE name = 'Mouse';



-- 11) Increase price 10%

UPDATE products SET price = price * 1.10;



-- Final show

SELECT * FROM products;



-- 12) Cleanup

DROP DATABASE IF EXISTS shopdb;

DROP USER IF EXISTS 'webserver'@'localhost';
