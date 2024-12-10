-- Удаление существующих таблиц, если они существуют
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

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
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
(1, 'Ноутбук', 1000.00, 'Ноутбук Asus, 16GB RAM, 512GB SSD'),
(2, 'Кружка', 200.00, 'Кружка из фарфора, объем 300 мл'),
(3, 'Книга', 300.00, 'Г.Мопассан. Жизнь. Классическая литература.'),
(4, 'Конструктор', 250.00, 'Конструктор LEGO, 500 деталей'),
(5, 'Ручка', 30.00, 'Гелевая ручка с синей пастой');

-- Наполнение таблицы избранного с временными метками
INSERT INTO favorites (user_id, product_id, added_at) VALUES
(1, 1, '2023-10-01 10:00:00'),  -- Иванов Сергей добавил Ноутбук
(1, 2, '2023-10-02 12:00:00'),  -- Иванов Сергей добавил Кружку
(2, 2, '2023-10-03 09:30:00'),  -- Петров Иван добавил Кружку
(3, 3, '2023-10-04 11:15:00'),  -- Сидоров Егор добавил Книгу
(4, 4, '2023-10-05 08:45:00');  -- Столетов Михаил добавил Конструктор

-- избранное Иванова Сергея
-- SELECT p.product_name, f.added_at
-- FROM favorites f
-- JOIN users u ON f.user_id = u.user_id
-- JOIN products p ON f.product_id = p.product_id
-- WHERE u.user_name = 'Иванов Сергей';

-- избранное всех пользователей
-- SELECT f.user_id, u.user_name, f.product_id, p.product_name, f.added_at
-- FROM favorites f
-- JOIN users u ON f.user_id = u.user_id
-- JOIN products p ON f.product_id = p.product_id;


-- SELECT * FROM users;
-- SELECT * FROM products;
-- SELECT * FROM favorites;