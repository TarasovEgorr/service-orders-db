-- ============================================
-- Схема Data Vault
-- ============================================
CREATE SCHEMA IF NOT EXISTS dv;
SET search_path TO dv;

-- ============================================
-- HUBS
-- ============================================

CREATE TABLE hub_client (
    client_hkey UUID PRIMARY KEY,
    client_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_service (
    service_hkey UUID PRIMARY KEY,
    service_bk VARCHAR(100) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_employee (
    employee_hkey UUID PRIMARY KEY,
    employee_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE hub_order (
    order_hkey UUID PRIMARY KEY,
    order_bk VARCHAR(50) UNIQUE NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- ============================================
-- LINKS
-- ============================================

CREATE TABLE link_order_client (
    link_order_client_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    client_hkey UUID NOT NULL REFERENCES hub_client(client_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE link_order_service (
    link_order_service_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    service_hkey UUID NOT NULL REFERENCES hub_service(service_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE link_order_employee (
    link_order_employee_hkey UUID PRIMARY KEY,
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    employee_hkey UUID NOT NULL REFERENCES hub_employee(employee_hkey),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- ============================================
-- SATELLITES
-- ============================================

CREATE TABLE sat_client (
    client_hkey UUID NOT NULL REFERENCES hub_client(client_hkey),
    full_name VARCHAR(100),
    email VARCHAR(100),
    address TEXT,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (client_hkey, load_date)
);

CREATE TABLE sat_service (
    service_hkey UUID NOT NULL REFERENCES hub_service(service_hkey),
    description TEXT,
    price NUMERIC(10,2),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (service_hkey, load_date)
);

CREATE TABLE sat_employee (
    employee_hkey UUID NOT NULL REFERENCES hub_employee(employee_hkey),
    full_name VARCHAR(100),
    position VARCHAR(50),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_hkey, load_date)
);

CREATE TABLE sat_order (
    order_hkey UUID NOT NULL REFERENCES hub_order(order_hkey),
    order_date DATE,
    completion_date DATE,
    status VARCHAR(30),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (order_hkey, load_date)
);

CREATE TABLE sat_order_service (
    link_order_service_hkey UUID NOT NULL REFERENCES link_order_service(link_order_service_hkey),
    quantity INT,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    PRIMARY KEY (link_order_service_hkey, load_date)
);
