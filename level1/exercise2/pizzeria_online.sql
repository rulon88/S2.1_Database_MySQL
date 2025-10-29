-- Create database
CREATE DATABASE IF NOT EXISTS pizzeria_online;
USE pizzeria_online;

-- Provinces table
CREATE TABLE provinces (
    province_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Cities table
CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    province_id INT NOT NULL,
    FOREIGN KEY (province_id) REFERENCES provinces(province_id)
);

-- Stores table
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(150) NOT NULL,
    postal_code VARCHAR(10),
    city_id INT NOT NULL,
    province_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (province_id) REFERENCES provinces(province_id)
);

-- Employees table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    nif VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role ENUM('cook', 'delivery') NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Categories table (for pizzas)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    price DECIMAL(8,2) NOT NULL,
    category_id INT,
    type ENUM('pizza', 'burger', 'drink') NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    postal_code VARCHAR(10),
    city_id INT NOT NULL,
    province_id INT NOT NULL,
    phone VARCHAR(20),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (province_id) REFERENCES provinces(province_id)
);

-- Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivery_type ENUM('home', 'pickup') NOT NULL,
    delivery_time DATETIME,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Order details table
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
