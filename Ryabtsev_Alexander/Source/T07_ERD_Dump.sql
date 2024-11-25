DROP SCHEMA IF EXISTS redavero CASCADE;

CREATE SCHEMA redavero;

SET SEARCH_PATH TO redavero;


-- СОЗДАНИЕ СУЩНОСТЕЙ
CREATE TABLE addresses
(
    address_id      SERIAL PRIMARY KEY,
    address_name    VARCHAR(127),
    postcode        VARCHAR(31),
    city            VARCHAR(127) NOT NULL,
    street          VARCHAR(127),
    building_number VARCHAR(127),
    entryway        VARCHAR(31),
    floor           VARCHAR(31),
    apartment       VARCHAR(31),
    intercom        VARCHAR(31)
);

CREATE TABLE users
(
    user_id             SERIAL PRIMARY KEY,
    username            VARCHAR(127) UNIQUE                                                             NOT NULL,
    surname             VARCHAR(127),
    name                VARCHAR(127),
    patronymic          VARCHAR(127),
    birth_date          DATE,
    gender              VARCHAR(1) CHECK ( gender IN ('M', 'F') ),
    phone_number        VARCHAR(31) CHECK ( phone_number ~ '^\+?[0-9]{2,}$' ),
    email               VARCHAR(255) CHECK ( email ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' ) NOT NULL,
    shipping_address_id INT,
    CONSTRAINT fk_users_addresses FOREIGN KEY (shipping_address_id) REFERENCES addresses (address_id) ON DELETE SET NULL
);

CREATE TABLE products
(
    product_id          SERIAL PRIMARY KEY,
    product_name        VARCHAR(255)   NOT NULL,
    product_unit        VARCHAR(31)    NOT NULL,
    product_price       DECIMAL(17, 4) NOT NULL,
    product_description TEXT,
    product_category    VARCHAR(255) -- TODO: Иерархическая структура
);

CREATE TABLE carts
(
    cart_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    CONSTRAINT fk_carts_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE cart_items
(
    cart_id       INT            NOT NULL,
    product_id    INT            NOT NULL,
    item_quantity DECIMAL(17, 4) NOT NULL,
    CONSTRAINT fk_cart_items_carts FOREIGN KEY (cart_id) REFERENCES carts (cart_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT pk_cart_items PRIMARY KEY (cart_id, product_id)
);

CREATE TABLE warehouses
(
    warehouse_id         SERIAL PRIMARY KEY,
    warehouse_address_id INT                 NOT NULL,
    warehouse_name       VARCHAR(255) UNIQUE NOT NULL,
    CONSTRAINT fk_warehouses_addresses FOREIGN KEY (warehouse_address_id) REFERENCES addresses (address_id) ON DELETE SET NULL
);

CREATE TYPE reservation_status_enum AS ENUM ('active', 'paid', 'cancelled', 'expired');

CREATE TABLE warehouse_stocks
(
    warehouse_stock_id   SERIAL PRIMARY KEY,
    cart_id              INT,
    product_id           INT                                               NOT NULL,
    warehouse_id         INT                                               NOT NULL,
    operation_type       VARCHAR(1) CHECK ( operation_type IN ('+', '-') ) NOT NULL,
    operation_quantity   DECIMAL(17, 4)                                    NOT NULL,
    updated_at           TIMESTAMPTZ DEFAULT NOW()                         NOT NULL,
    reservation_status   reservation_status_enum,
    reservation_interval INTERVAL,
    CONSTRAINT fk_warehouse_stocks_carts FOREIGN KEY (cart_id) REFERENCES carts (cart_id) ON DELETE NO ACTION,
    CONSTRAINT fk_warehouse_stocks_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT fk_warehouse_stocks_warehouses FOREIGN KEY (warehouse_id) REFERENCES warehouses (warehouse_id) ON DELETE NO ACTION
);


-- ДОБАВЛЕНИЕ КОРТЕЖЕЙ
INSERT INTO users (username, surname, name, patronymic, gender, phone_number, email)
VALUES ('user1', 'Р.', 'Александр', 'Анатольевич', 'M', '+98765432109', 'user1@mail.ru'),
       ('user2', NULL, NULL, NULL, NULL, NULL, 'user2@mail.ru'),
       ('user3', NULL, NULL, NULL, NULL, NULL, 'user3@mail.ru');

INSERT INTO products(product_name, product_unit, product_price, product_description, product_category)
VALUES ('Кефир', 'шт', 50, '500 гр', 'Продукты / Молочные'),
       ('Полбатона', 'шт', 20, '200 гр', 'Продукты / Хлеб'),
       ('Икарус', 'шт', 3333, '1 шт', 'Игрушки / Транспорт'),
       ('Кефир', 'шт', 80, '900 гр', 'Продукты / Молочные');

INSERT INTO addresses(address_name, postcode, city)
VALUES ('Основной', '101000', 'г. Москва');

INSERT INTO warehouses(warehouse_address_id, warehouse_name)
VALUES (1, 'МегаМаркет');

INSERT INTO warehouse_stocks(product_id, warehouse_id, operation_type, operation_quantity)
VALUES (1, 1, '+', 1),
       (2, 1, '+', 2),
       (3, 1, '+', 3);

INSERT INTO carts(user_id)
VALUES (1),
       (2),
       (3);

-- TODO: Добавить функции и триггеры проверки наличия на складе

INSERT INTO cart_items(cart_id, product_id, item_quantity)
VALUES (1, 1, 2),
       (1, 2, 1),
       (2, 3, 1);


-- ПРОСМОТР КОРЗИНЫ ПОЛЬЗОВАТЕЛЯ
SELECT surname                                               AS Фамилия,
       name                                                  AS Имя,
       patronymic                                            AS Отчество,
       email                                                 AS Эл_почта,
       product_name                                          AS Товар,
       product_unit                                          AS Ед_изм,
       item_quantity                                         AS Количество,
       product_price                                         AS Цена_за_ед,
       product_price * item_quantity                         AS Сумма,
       COALESCE(SUM(operation_quantity), 0)                  AS В_наличии,
       CASE
           WHEN COALESCE(SUM(operation_quantity), 0) < item_quantity THEN 'Нет'
           WHEN COALESCE(SUM(operation_quantity), 0) >= item_quantity THEN 'Да'
           END                                               AS Достаточно_для_заказа,
       SUM(cart_items.item_quantity) OVER ()                 AS Количество_Общее,
       SUM(product_price * cart_items.item_quantity) OVER () AS Сумма_Общая
FROM products
         INNER JOIN cart_items ON products.product_id = cart_items.product_id
         INNER JOIN carts ON cart_items.cart_id = carts.cart_id
         INNER JOIN users ON carts.user_id = users.user_id
    -- TODO: Изменить логику присоединений после добавления триггеров:
         LEFT JOIN warehouse_stocks ON products.product_id = warehouse_stocks.product_id
         LEFT JOIN warehouses ON warehouse_stocks.warehouse_id = warehouses.warehouse_id
WHERE users.user_id = 1
  AND warehouses.warehouse_id = 1
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9;
