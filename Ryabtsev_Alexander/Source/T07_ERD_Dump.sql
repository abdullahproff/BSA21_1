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

CREATE TABLE baskets
(
    basket_id        SERIAL PRIMARY KEY,
    user_id          INT            NOT NULL,
    product_id       INT            NOT NULL,
    product_quantity DECIMAL(17, 4) NOT NULL,
    is_paid          BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_baskets_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_baskets_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE SET NULL
);

CREATE TABLE warehouses
(
    warehouse_id         SERIAL PRIMARY KEY,
    warehouse_address_id INT                                               NOT NULL,
    product_id           INT                                               NOT NULL,
    operation_type       VARCHAR(1) CHECK ( operation_type IN ('+', '-') ) NOT NULL,
    operation_timestamp  TIMESTAMPTZ DEFAULT NOW()                         NOT NULL,
    operation_quantity   DECIMAL(17, 4)                                    NOT NULL,
    CONSTRAINT fk_warehouses_addresses FOREIGN KEY (warehouse_address_id) REFERENCES addresses (address_id) ON DELETE SET NULL,
    CONSTRAINT fk_warehouses_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
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
VALUES ('Основной склад', '101000', 'г. Москва');

INSERT INTO warehouses(warehouse_address_id, product_id, operation_type, operation_quantity)
VALUES (1, 1, '+', 1),
       (1, 2, '+', 2),
       (1, 3, '+', 3);

INSERT INTO baskets(user_id, product_id, product_quantity)
VALUES (1, 1, 2),
       (1, 2, 1),
       (2, 3, 1);



-- СОЗДАНИЕ ФУНКЦИИ И ТРИГГЕРА ДЛЯ ОБРАБОТКИ ИЗМЕНЕНИЯ СТАТУСА ОПЛАТЫ КОРЗИНЫ НА "TRUE"
CREATE OR REPLACE FUNCTION handle_paid_basket()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.is_paid = TRUE AND OLD.is_paid = FALSE THEN
        INSERT INTO warehouses(warehouse_address_id,
                               product_id,
                               operation_type,
                               operation_quantity)
        VALUES (1, -- ID склада
                NEW.product_id,
                '-',
                NEW.product_quantity * -1);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_paid_basket
    AFTER UPDATE OF is_paid
    ON baskets
    FOR EACH ROW
EXECUTE FUNCTION handle_paid_basket();


-- ПРИМЕР СЦЕНАРИЯ С ОПЛАТОЙ КОРЗИНЫ ЧЕРЕЗ ПРОВЕРКУ НАЛИЧИЯ НА СКЛАДЕ
UPDATE baskets
SET is_paid = TRUE
WHERE user_id = 1
  AND NOT EXISTS (SELECT 1
                  FROM baskets
                           LEFT JOIN (SELECT product_id,
                                             SUM(operation_quantity) AS total_quantity
                                      FROM warehouses
                                      GROUP BY product_id) AS w
                                     ON w.product_id = baskets.product_id
                  WHERE baskets.user_id = 1
                    AND (w.total_quantity IS NULL OR w.total_quantity < baskets.product_quantity));


-- ПРОСМОТР КОРЗИНЫ ПОЛЬЗОВАТЕЛЯ
SELECT surname                                         AS Фамилия,
       name                                            AS Имя,
       patronymic                                      AS Отчество,
       email                                           AS Эл_почта,
       product_name                                    AS Товар,
       product_unit                                    AS Ед_изм,
       product_quantity                                AS Количество,
       product_price                                   AS Цена_за_ед,
       product_price * baskets.product_quantity        AS Сумма,
       COALESCE(SUM(warehouses.operation_quantity), 0) AS В_наличии,
       CASE
           WHEN COALESCE(SUM(warehouses.operation_quantity), 0) < product_quantity THEN 'Нет'
           WHEN COALESCE(SUM(warehouses.operation_quantity), 0) >= product_quantity THEN 'Да'
           END                                         AS Достаточно_для_заказа
FROM products
         INNER JOIN baskets ON baskets.product_id = products.product_id
         INNER JOIN users ON users.user_id = baskets.user_id
         LEFT JOIN warehouses ON warehouses.product_id = products.product_id
WHERE baskets.is_paid = FALSE
  AND users.user_id = 1
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9;


-- ПОДСЧЁТ СТАТИСТИКИ ПОЛЬЗОВАТЕЛЯ: ОПЛАЧЕНО / НЕ ОПЛАЧЕНО
SELECT username                                      AS Имя_пользователя,
       SUM(baskets.product_quantity)                 AS Количество_Товаров_Итого,
       SUM(product_price * baskets.product_quantity) AS Сумма_Товаров_Итого,
       baskets.is_paid                               AS Оплачено
FROM products
         INNER JOIN baskets ON baskets.product_id = products.product_id
         INNER JOIN users ON users.user_id = baskets.user_id
GROUP BY username, baskets.is_paid
HAVING username = 'user1';
