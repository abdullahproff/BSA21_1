-- Создание таблицы users
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    login VARCHAR NOT NULL,
    favorite_item_id INT
);

-- Создание таблицы items
CREATE TABLE items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR NOT NULL,
    item_desc TEXT,
    price DECIMAL
);

-- Создание таблицы favorite_items
CREATE TABLE favorite_items (
    favorite_item_id INT PRIMARY KEY,
    date_add TIMESTAMP WITH TIME ZONE,
    user_id INT,
    item_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Очистка данных и удаление таблиц
DELETE FROM favorite_items;
DELETE FROM items;
DELETE FROM users;

DROP TABLE IF EXISTS favorite_items;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;
