-- ============================================
-- Создаем схему 3NF
-- ============================================
CREATE SCHEMA IF NOT EXISTS "3nf";

-- Переключаемся на схему 3NF
SET search_path TO "3nf";

-- ============================================
-- Таблица: Клиенты
-- ============================================
CREATE TABLE client (
    client_id SERIAL PRIMARY KEY,            
    full_name VARCHAR(100) NOT NULL,         
    phone VARCHAR(20) NOT NULL UNIQUE,       
    email VARCHAR(100) UNIQUE,               
    address TEXT                             
);

-- ============================================
-- Таблица: Услуги
-- ============================================
CREATE TABLE service (
    service_id SERIAL PRIMARY KEY,           
    name VARCHAR(100) NOT NULL,              
    description TEXT,                        
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0)
);

-- ============================================
-- Таблица: Сотрудники
-- ============================================
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,          
    full_name VARCHAR(100) NOT NULL,         
    phone VARCHAR(20) UNIQUE,                
    position VARCHAR(50)                     
);

-- ============================================
-- Таблица: Заказы
-- ============================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,             
    order_date DATE NOT NULL DEFAULT CURRENT_DATE, 
    completion_date DATE,                    
    status VARCHAR(30) NOT NULL CHECK (status IN ('новый', 'в работе', 'выполнен', 'отменен')),
    client_id INT NOT NULL,                  
    CONSTRAINT fk_order_client FOREIGN KEY (client_id)
        REFERENCES client (client_id) ON DELETE CASCADE
);

-- ============================================
-- Таблица: Заказанные услуги
-- ============================================
CREATE TABLE order_service (
    order_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, service_id),
    CONSTRAINT fk_os_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_os_service FOREIGN KEY (service_id)
        REFERENCES service (service_id) ON DELETE CASCADE
);

-- ============================================
-- Таблица: Назначения сотрудников
-- ============================================
CREATE TABLE assignment (
    assignment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    employee_id INT NOT NULL,
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_assignment_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) ON DELETE SET NULL
);

-- ============================================
-- Индексы
-- ============================================
CREATE INDEX idx_client_phone ON client (phone);
CREATE INDEX idx_order_status ON orders (status);
CREATE INDEX idx_assignment_order ON assignment (order_id);
