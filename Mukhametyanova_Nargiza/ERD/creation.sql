-- Удаление таблиц и типов данных
DROP TABLE IF EXISTS basket_to_products CASCADE;
DROP TABLE IF EXISTS buyer_to_products CASCADE;
DROP TABLE IF EXISTS buyer_to_actions CASCADE;
DROP TABLE IF EXISTS product_to_categories CASCADE;
DROP TABLE IF EXISTS product_to_actions CASCADE;
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

-- Таблица акций
CREATE TABLE best_actions (
    best_action_id SERIAL PRIMARY KEY,
    action_name VARCHAR(255),
    action_description TEXT,
    action_start DATE,
    action_end DATE
);

-- Таблица категорий
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255),
    target_group target_group_enum,
    category_type category_type_enum,
    subcategory_type subcategory_type_enum
);

-- Таблица товаров
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    product_photo TEXT,
    product_cost INT,
    product_size VARCHAR(50)
);

-- Таблица корзин
CREATE TABLE baskets (
    basket_id SERIAL PRIMARY KEY,
    buyer_id INT NOT NULL,
    basket_status basket_status_enum NOT NULL,
    basket_payment VARCHAR(50),
    basket_delivery VARCHAR(50),
    basket_cost INT,
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id)
);

-- Промежуточная таблица для связи покупателей и товаров
CREATE TABLE buyer_to_products (
    buyer_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (buyer_id, product_id),
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Промежуточная таблица для связи покупателей и акций
CREATE TABLE buyer_to_actions (
    buyer_id INT NOT NULL,
    best_action_id INT NOT NULL,
    PRIMARY KEY (buyer_id, best_action_id),
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id),
    FOREIGN KEY (best_action_id) REFERENCES best_actions(best_action_id)
);

-- Промежуточная таблица для связи товаров и категорий
CREATE TABLE product_to_categories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Промежуточная таблица для связи товаров и акций
CREATE TABLE product_to_actions (
    product_id INT NOT NULL,
    best_action_id INT NOT NULL,
    PRIMARY KEY (product_id, best_action_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (best_action_id) REFERENCES best_actions(best_action_id)
);

-- Промежуточная таблица для связи корзин и товаров
CREATE TABLE basket_to_products (
    basket_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (basket_id, product_id),
    FOREIGN KEY (basket_id) REFERENCES baskets(basket_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Вставка нескольких пользователей
INSERT INTO buyers (buyer_id, surname, name, telephone_num, email, personal_sale)
VALUES
(1, 'Иванова', 'Дарья', '89012345678', 'ivanova@mail.com', 10),
(2, 'Петров', 'Егор', '89098765432', 'petrov@mail.com', 15),
(3, 'Смирнов', 'Алексей', '89123456789', 'smirnov@mail.com', 5),
(4, 'Кузнецова', 'Елена', '89234567890', 'kuznetsova@mail.com', 20);

-- Вставка нескольких акций
INSERT INTO best_actions (best_action_id, action_name, action_description, action_start, action_end)
VALUES
(1, 'Скидки до 50%', 'Скидки на все товары бренда Mossmore до 50%', '2024-11-01', '2024-11-30'),
(2, 'Зимняя распродажа', 'Скидки на зимнюю одежду до 40%', '2024-12-01', '2024-12-20'),
(3, 'Чёрная пятница', 'Скидки до 70% на уходовые средства', '2024-11-25', '2024-12-03');

-- Вставка нескольких категорий
INSERT INTO categories (category_id, target_group, category_type, subcategory_type)
VALUES
(1, 'Женщины', 'Одежда', 'Платья'),
(2, 'Мужчины', 'Обувь', 'Джинсы'),
(3, 'Дети', 'Аксессуары', 'Зонты'),
(4, 'Женщины', 'Красота', 'Для волос');

-- Вставка нескольких товаров
INSERT INTO products (product_id, product_name, product_photo, product_cost, product_size)
VALUES
(1, 'Платье вечернее', 'coctail_dress.jpg', 7500, 'M'),
(2, 'Зимние ботинки', 'winter_shoes.jpg', 5500, '43'),
(3, 'Зонт с бусами', 'umbrella_wbeads.jpg', 2200, 'M'),
(4, 'Лосьон увлажняющий', 'moisturizing_lotion.jpg', 1500, '150ml');

-- Связь товаров с категориями
INSERT INTO product_to_categories (product_id, category_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Связь товаров с акциями
INSERT INTO product_to_actions (product_id, best_action_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);

-- Связь покупателей и акций
INSERT INTO buyer_to_actions (buyer_id, best_action_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);

-- Связь покупателей и товаров
INSERT INTO buyer_to_products (buyer_id, product_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Вставка нескольких записей в корзину
INSERT INTO baskets (basket_id, buyer_id, basket_status, basket_payment, basket_delivery, basket_cost)
VALUES
(1, 1, 'активная', 'При получении', 'Курьером', 7500),
(2, 2, 'оформлена', 'При получении', 'Самовывоз', 11000),
(3, 3, 'ожидает подтверждения', 'СБП', 'Курьером', 2200),
(4, 4, 'отменена', 'Банковская карта', 'Постамат', 1500);

-- Связь корзин и товаров
INSERT INTO basket_to_products (basket_id, product_id, quantity)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 1);