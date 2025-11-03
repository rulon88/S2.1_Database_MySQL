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

-- Stores table CORREGIDA - solo relación con cities
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(150) NOT NULL,
    postal_code VARCHAR(10),
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
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

-- Categories table
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

-- Customers table CORREGIDA - solo relación con cities
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    postal_code VARCHAR(10),
    city_id INT NOT NULL,
    phone VARCHAR(20),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
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

-- INSERTS para pizzeria_online
INSERT INTO provinces (name) VALUES
('Barcelona'),
('Madrid'),
('Valencia');

INSERT INTO cities (name, province_id) VALUES
('Barcelona', 1),
('Madrid', 2),
('Valencia', 3),
('Badalona', 1),
('Móstoles', 2);

INSERT INTO stores (address, postal_code, city_id) VALUES
('Calle Gran Vía 123', '08013', 1),
('Avenida Sol 456', '28001', 2),
('Plaza Ayuntamiento 789', '46002', 3);

INSERT INTO employees (store_id, first_name, last_name, nif, phone, role) VALUES
(1, 'Carlos', 'Gómez', '12345678A', '611111111', 'cook'),
(1, 'Ana', 'López', '87654321B', '622222222', 'delivery'),
(2, 'Miguel', 'Rodríguez', '11223344C', '633333333', 'cook'),
(2, 'Elena', 'Martínez', '44332211D', '644444444', 'delivery');

INSERT INTO categories (name) VALUES
('Clásicas'),
('Especiales'),
('Gourmet'),
('Vegetarianas');

INSERT INTO products (name, description, image, price, category_id, type) VALUES
('Margarita', 'Tomate, mozzarella y albahaca', 'margarita.jpg', 12.50, 1, 'pizza'),
('Pepperoni', 'Tomate, mozzarella y pepperoni', 'pepperoni.jpg', 14.00, 1, 'pizza'),
('Cuatro Quesos', 'Mezcla de cuatro quesos selectos', 'cuatro_quesos.jpg', 15.50, 2, 'pizza'),
('BBQ Burger', 'Hamburguesa con salsa barbacoa', 'bbq_burger.jpg', 9.50, NULL, 'burger'),
('Coca-Cola', 'Refresco de cola 33cl', 'cocacola.jpg', 2.50, NULL, 'drink'),
('Agua Mineral', 'Agua mineral 50cl', 'agua.jpg', 1.80, NULL, 'drink');

INSERT INTO customers (first_name, last_name, address, postal_code, city_id, phone) VALUES
('Juan', 'Pérez', 'Calle Mayor 123', '08001', 1, '655555555'),
('María', 'García', 'Avenida Libertad 456', '28002', 2, '666666666'),
('Pedro', 'Sánchez', 'Plaza España 789', '46003', 3, '677777777');

INSERT INTO orders (customer_id, store_id, employee_id, delivery_type, delivery_time, total_price) VALUES
(1, 1, 2, 'home', '2024-01-15 21:30:00', 27.50),
(2, 2, 4, 'pickup', NULL, 16.00),
(3, 3, NULL, 'home', '2024-01-15 22:00:00', 15.50);

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 12.50),
(1, 5, 2, 2.50),
(1, 6, 1, 1.80),
(2, 2, 1, 14.00),
(2, 5, 1, 2.00),
(3, 3, 1, 15.50);