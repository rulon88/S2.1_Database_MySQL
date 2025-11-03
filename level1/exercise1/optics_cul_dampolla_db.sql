-- Create database (con IF NOT EXISTS como recomendó)
CREATE DATABASE IF NOT EXISTS optics_cul_dampolla;
USE optics_cul_dampolla;

-- 1️⃣ TABLA ADDRESS (como pidió: "suppliers debe tener su tabla relacional con address")
CREATE TABLE IF NOT EXISTS addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(100),
    number VARCHAR(10),
    floor VARCHAR(10),
    door VARCHAR(10),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50) DEFAULT 'Spain'
);

-- 2️⃣ SUPPLIERS (con address_id relacional)
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address_id INT NOT NULL,  -- ✅ RELACIÓN CON ADDRESS
    phone VARCHAR(20),
    fax VARCHAR(20),
    nif VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

-- 3️⃣ BRANDS 
CREATE TABLE IF NOT EXISTS brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 4️⃣ GLASSES (con supplier_id directo - como pidió: "glasses se relaciona con supplier más que con brands")
CREATE TABLE IF NOT EXISTS glasses (
    glasses_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    supplier_id INT NOT NULL,  -- ✅ RELACIÓN DIRECTA CON SUPPLIER
    left_lens_prescription DECIMAL(4,2),
    right_lens_prescription DECIMAL(4,2),
    frame_type ENUM('floating', 'plastic', 'metallic') NOT NULL,
    frame_color VARCHAR(50),
    left_lens_color VARCHAR(50),
    right_lens_color VARCHAR(50),
    price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)  -- ✅ NUEVA FK
);

-- 5️⃣ EMPLOYEES (también con address_id para consistencia)
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    hire_date DATE,
    address_id INT NOT NULL,  -- ✅ USA ADDRESS
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

-- 6️⃣ CUSTOMERS (con assigned_employee_id - como pidió: "relación entre employees y customers")
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address_id INT NOT NULL,  -- ✅ USA ADDRESS
    phone VARCHAR(20),
    email VARCHAR(100),
    registration_date DATE NOT NULL,
    referred_by_customer_id INT,
    assigned_employee_id INT,  -- ✅ RELACIÓN CON EMPLOYEES
    FOREIGN KEY (address_id) REFERENCES addresses(address_id),
    FOREIGN KEY (referred_by_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (assigned_employee_id) REFERENCES employees(employee_id)  -- ✅ NUEVA FK
);

-- 7️⃣ SALES 
CREATE TABLE IF NOT EXISTS sales (
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


-- INSERTS DE EJEMPLO
INSERT INTO addresses (street, number, city, postal_code) VALUES
('Calle Mayor', '123', 'Barcelona', '08001'),
('Gran Vía', '456', 'Madrid', '28001');

INSERT INTO suppliers (name, address_id, phone, nif) VALUES
('Proveedor A', 1, '911111111', 'A11111111'),
('Proveedor B', 2, '922222222', 'B22222222');

INSERT INTO brands (name, supplier_id) VALUES
('Marca X', 1), ('Marca Y', 2);

INSERT INTO employees (name, email, hire_date, address_id) VALUES
('Ana García', 'ana@email.com', '2023-01-01', 1),
('Carlos López', 'carlos@email.com', '2023-02-01', 2);

INSERT INTO customers (name, address_id, phone, registration_date, assigned_employee_id) VALUES
('Cliente 1', 1, '633333333', '2024-01-01', 1),
('Cliente 2', 2, '644444444', '2024-01-02', 2);

INSERT INTO glasses (brand_id, supplier_id, frame_type, frame_color, price) VALUES
(1, 1, 'floating', 'negro', 100.00),
(2, 2, 'metallic', 'plateado', 150.00);

INSERT INTO sales (glasses_id, customer_id, employee_id, sale_price) VALUES
(1, 1, 1, 100.00), (2, 2, 2, 150.00);