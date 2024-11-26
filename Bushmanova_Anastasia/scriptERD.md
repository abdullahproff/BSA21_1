-- Создание таблицы пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    login varchar
);

-- Создание таблицы товаров
CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    item_name varchar,
    item_description text,
    price decimal
);

-- Создание таблицы избранных товаров
CREATE TABLE favorite_items (
    favorite_item_id SERIAL PRIMARY KEY,
    date_add date,
    user_id int,
    item_id int,
    CONSTRAINT fk_favorite_items_users FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT fk_favorite_items_items FOREIGN KEY (item_id) REFERENCES items (item_id),
    CONSTRAINT unique_user_item UNIQUE (user_id, item_id) -- Уникальная пара user_id и item_id
);
