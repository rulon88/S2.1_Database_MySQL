-- Create database
CREATE DATABASE optics_cul_dampolla;
USE optics_cul_dampolla;

-- Suppliers table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street VARCHAR(100),
    number VARCHAR(10),
    floor VARCHAR(10),
    door VARCHAR(10),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    phone VARCHAR(20),
    fax VARCHAR(20),
    nif VARCHAR(20) UNIQUE NOT NULL
);

-- Brands table
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    supplier_id INT NOT NULL UNIQUE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Glasses table
CREATE TABLE glasses (
    glasses_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    left_lens_prescription DECIMAL(4,2),
    right_lens_prescription DECIMAL(4,2),
    frame_type ENUM('floating', 'plastic', 'metallic') NOT NULL,
    frame_color VARCHAR(50),
    left_lens_color VARCHAR(50),
    right_lens_color VARCHAR(50),
    price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    registration_date DATE NOT NULL,
    referred_by_customer_id INT,
    FOREIGN KEY (referred_by_customer_id) REFERENCES customers(customer_id)
);

-- Employees table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    hire_date DATE
);

-- Sales table
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    glasses_id INT NOT NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    sale_price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (glasses_id) REFERENCES glasses(glasses_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);