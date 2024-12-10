-- Удаление таблиц и типов данных
DROP TABLE IF EXISTS baskets_to_products CASCADE;
DROP TABLE IF EXISTS products_to_actions CASCADE;
DROP TABLE IF EXISTS baskets CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS best_actions CASCADE;
DROP TABLE IF EXISTS buyers CASCADE;

DROP TYPE IF EXISTS category_type_enum CASCADE;
DROP TYPE IF EXISTS subcategory_type_enum CASCADE;
DROP TYPE IF EXISTS target_group_enum CASCADE;
DROP TYPE IF EXISTS basket_status_enum CASCADE;

-- Создание типов данных для ENUM
CREATE TYPE category_type_enum AS ENUM ('Одежда', 'Обувь', 'Аксессуары', 'Красота', 'Спорт', 'Дом');
CREATE TYPE subcategory_type_enum AS ENUM ('Платья', 'Джинсы', 'Зонты', 'Для волос', 'Бег', 'Свечи и ароматы');
CREATE TYPE target_group_enum AS ENUM ('Мужчины', 'Женщины', 'Дети');
CREATE TYPE basket_status_enum AS ENUM ('активная', 'ожидает подтверждения', 'оформлена', 'отменена');

-- Таблица покупателей
CREATE TABLE buyers (
    buyer_id SERIAL PRIMARY KEY,
    surname VARCHAR(255),
    name VARCHAR(255),
    telephone_num VARCHAR(15),
    email VARCHAR(255),
    personal_sale INT
);

-- Таблица категорий
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    target_group target_group_enum NOT NULL,
    category_type category_type_enum NOT NULL,
    subcategory_type subcategory_type_enum NOT NULL
);

-- Таблица акций
CREATE TABLE best_actions (
    best_action_id SERIAL PRIMARY KEY,
    action_name VARCHAR(255),
    action_description TEXT,
    action_start TIMESTAMPTZ,
    action_end TIMESTAMPTZ
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_photo TEXT,
    product_cost NUMERIC(10, 2),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Таблица корзин
CREATE TABLE baskets (
    basket_id SERIAL PRIMARY KEY,
    buyer_id INT UNIQUE NOT NULL,
    basket_status basket_status_enum NOT NULL,
    basket_payment VARCHAR(50),
    basket_delivery VARCHAR(50),
    basket_cost NUMERIC(10, 2),
    basket_quantity INT NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id) ON DELETE CASCADE
);

-- Промежуточная таблица для связи корзин и товаров
CREATE TABLE baskets_to_products (
    basket_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (basket_id) REFERENCES baskets(basket_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Промежуточная таблица для связи товаров и акций
CREATE TABLE products_to_actions (
    product_id INT NOT NULL,
    best_action_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (best_action_id) REFERENCES best_actions(best_action_id)
);

-- Вставка данных в таблицу buyers
INSERT INTO buyers (surname, name, telephone_num, email, personal_sale)
VALUES
('Иванова', 'Дарья', '89012345678', 'ivanova@mail.com', 10),
('Петров', 'Егор', '89098765432', 'petrov@mail.com', 15),
('Смирнов', 'Алексей', '89123456789', 'smirnov@mail.com', 5),
('Кузнецова', 'Елена', '89234567890', 'kuznetsova@mail.com', 20);

-- Вставка данных в таблицу categories
INSERT INTO categories (target_group, category_type, subcategory_type)
VALUES
('Женщины', 'Одежда', 'Платья'),
('Мужчины', 'Обувь', 'Джинсы'),
('Дети', 'Аксессуары', 'Зонты'),
('Женщины', 'Красота', 'Для волос');

-- Вставка данных в таблицу products
INSERT INTO products (category_id, product_name, product_photo, product_cost, product_color, product_size)
VALUES
(1, 'Платье вечернее', 'coctail_dress.jpg', 7500.00, 'Красный', 'M'),
(2, 'Зимние ботинки', 'winter_shoes.jpg', 5500.50, 'Коричневый', '43'),
(3, 'Зонт с бусами', 'umbrella_wbeads.jpg', 2200.00, 'Желтый', 'M'),
(4, 'Лосьон увлажняющий', 'moisturizing_lotion.jpg', 1500.75, 'Белый', '150ml');

-- Вставка данных в таблицу best_actions
INSERT INTO best_actions (action_name, action_description, action_start, action_end)
VALUES
('Скидки до 50%', 'Скидки на все товары бренда Mossmore до 50%', '2024-11-01 12:00:00', '2024-11-30 12:00:00'),
('Зимняя распродажа', 'Скидки на зимнюю одежду до 40%', '2024-12-01 17:00:00', '2024-12-20 23:00:00'),
('Чёрная пятница', 'Скидки до 70% на уходовые средства', '2024-11-25 06:00:00', '2024-12-03 23:59:59'),
('Всё по 1500', 'Все товары по низкой цене', '2024-12-02 15:30:00', '2024-12-17 17:10:00');

-- Вставка данных в таблицу baskets
INSERT INTO baskets (buyer_id, basket_status, basket_payment, basket_delivery, basket_cost, basket_quantity)
VALUES
(1, 'активная', 'При получении', 'Курьером', 7500.00, 1),
(2, 'оформлена', 'При получении', 'Самовывоз', 11001.00, 2),
(3, 'ожидает подтверждения', 'СБП', 'Курьером', 2200.00, 1),
(4, 'отменена', 'Банковская карта', 'Постамат', 1500.75, 1);

-- Вставка данных в таблицу baskets_to_products
INSERT INTO baskets_to_products (basket_id, product_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Вставка данных в таблицу baskets_to_products
INSERT INTO products_to_actions (product_id, best_action_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);