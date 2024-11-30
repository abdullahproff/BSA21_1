
-- Создание таблицы пользователей
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL
);

-- Создание таблицы товаров
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255)
);

-- Создание таблицы избранного (многие ко многим между пользователем и товаром)
CREATE TABLE favorites (
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Наполнение таблицы пользователей
INSERT INTO users (user_id, user_name) VALUES
(1, 'Иванов Сергей'),
(2, 'Петров Иван'),
(3, 'Сидоров Егор'),
(4, 'Столетов Михаил'),
(5, 'Котов Денис');

-- Наполнение таблицы товаров
INSERT INTO products (product_id, product_name, price, description) VALUES
(1, 'Ноутбук', 100.00, 'Ноутбук асус'),
(2, 'Кружка', 200.00, 'Кружка фарфор'),
(3, 'Книга', 300.00, 'Г.Мопассан. Жизнь'),
(4, 'Конструктор', 250.00, 'Лего'),
(5, 'Ручка', 30.00, 'Гелевая');

-- Наполнение таблицы избранного
INSERT INTO favorites (user_id, product_id) 
VALUES ((SELECT user_id FROM users WHERE user_name = 'Иванов Сергей'),
         (SELECT product_id FROM products WHERE product_name = 'Ноутбук'));

INSERT INTO favorites (user_id, product_id) 
VALUES ((SELECT user_id FROM users WHERE user_name = 'Иванов Сергей'),
         (SELECT product_id FROM products WHERE product_name = 'Кружка'));

INSERT INTO favorites (user_id, product_id) 
VALUES ((SELECT user_id FROM users WHERE user_name = 'Петров Иван'),
         (SELECT product_id FROM products WHERE product_name = 'Кружка'));		 


-- SELECT * FROM users;
-- SELECT * FROM products;
-- SELECT * FROM favorites;