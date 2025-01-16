
-- Создание таблицы пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15)
);

-- Создание таблицы продуктов
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Создание таблицы избранного
CREATE TABLE favorites (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_favorites_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_favorites_products FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Добавление данных в таблицу пользователей
INSERT INTO users (user_name, email, phone_number)
VALUES 
('John Doe', 'john.doe@example.com', '1234567890'),
('Jane Smith', 'jane.smith@example.com', '0987654321');

-- Добавление данных в таблицу продуктов
INSERT INTO products (product_name, price, description)
VALUES 
('Laptop', 999.99, 'A high-performance laptop with 16GB RAM and 512GB SSD'),
('Smartphone', 499.99, 'A smartphone with a stunning camera and long battery life');

-- Добавление данных в таблицу избранного
INSERT INTO favorites (user_id, product_id)
VALUES 
(1, 1),
(1, 2),
(2, 1);

-- Запрос всех пользователей
SELECT * FROM users;

-- Запрос всех продуктов
SELECT * FROM products;

-- Запрос всех записей в избранном
SELECT * FROM favorites;

-- Запрос избранных продуктов для конкретных пользователей
SELECT f.favorite_id, u.user_name, p.product_name, p.price, p.description
FROM favorites f
JOIN users u ON f.user_id = u.user_id
JOIN products p ON f.product_id = p.product_id
WHERE u.user_id IN (1, 2)
ORDER BY f.favorite_id;
