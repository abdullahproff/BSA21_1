DROP TABLE IF EXISTS customers, products, purchases CASCADE;

-- Таблица покупателей

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    nickname VARCHAR(31) UNIQUE NOT NULL,
    first_name VARCHAR(31),
    last_name VARCHAR(31),
    email VARCHAR(63) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    gender CHAR CHECK(gender IN ('M', 'F')),
    address VARCHAR(255) NOT NULL,
    birth DATE,
    registered_at TIMESTAMPTZ
);

-- Таблица товаров

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    title VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price_rub DECIMAL(16, 4) CHECK(price_rub > 0) NOT NULL,
    quantity INT CHECK(quantity >= 0) NOT NULL,
    link VARCHAR(255) UNIQUE NOT NULL,
    rating DECIMAL(3, 2) CHECK(rating BETWEEN 1 AND 5) DEFAULT NULL,
    created_at TIMESTAMPTZ
);

-- Таблица Покупки

CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    amount SMALLINT CHECK(amount > 0) NOT NULL,
    score SMALLINT CHECK(score BETWEEN 1 AND 5) DEFAULT NULL,
    added_at TIMESTAMPTZ,
    scored_at TIMESTAMPTZ DEFAULT NULL,
    CONSTRAINT fk_purchases_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_purchases_products FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Создание функции, которая будет обновлять рейтинг продукта

CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
DECLARE
    new_rating DECIMAL(3, 2);  -- Переменная для хранения нового рейтинга
BEGIN  -- Вычисление нового рейтинга как среднее арифметическое всех оценок данного товара
    SELECT AVG(score)::DECIMAL(3, 2)
    INTO new_rating
    FROM purchases
    WHERE product_id = NEW.product_id;
    -- Обновление поля rating в таблице products
    UPDATE products
    SET rating = new_rating
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера, который вызывает функцию при вставке или обновлении строки в таблице purchases

CREATE TRIGGER trigger_update_product_rating
AFTER INSERT OR UPDATE OF score ON purchases
FOR EACH ROW
EXECUTE FUNCTION update_product_rating();

-- Вставка данных в таблицу покупателей

INSERT INTO customers (nickname, first_name, last_name, email, phone, gender, address, birth, registered_at)
VALUES
    ('nick1', 'Павел', 'Иванов', 'ivanov@email.ru', '+79161234567', 'M', 'Москва, ул. Ленина, д. 10', '1990-01-01', '2023-04-01T12:00:00+03'),
    ('nick2', 'Анна', 'Петрова', 'petrova@email.ru', '+79221234568', 'F', 'Санкт-Петербург, пр-т Невский, д. 20', '1988-02-05', '2023-04-02T13:30:00+03'),
    ('nick3', 'Сергей', 'Семенов', 'semenov@email.ru', '+79331234569', 'M', 'Новосибирск, ул. Мира, д. 30', '1976-06-07', '2023-04-03T14:45:00+03'),
    ('nick4', 'Елена', 'Васильева', 'vasilyeva@email.ru', '+79441234570', 'F', 'Краснодар, ул. Пушкина, д. 40', '1993-09-08', '2023-04-04T16:00:00+03'),
    ('nick5', 'Дмитрий', 'Кузнецов', 'kuznetsov@email.ru', '+79551234571', 'M', 'Екатеринбург, ул. Горького, д. 50', '2000-11-25', '2023-04-05T17:15:00+03');

-- Вставка данных в таблицу товаров

INSERT INTO products (title, description, price_rub, quantity, link, created_at)
VALUES
    ('Товар 1', 'Описание товара 1.', 100.00, 10, 'https://marketplace.com/product/1', '2023-04-01T12:00:00+03'),
    ('Товар 2', 'Описание товара 2.', 150.00, 7, 'https://marketplace.com/product/2', '2023-04-02T13:30:00+03'),
    ('Товар 3', 'Описание товара 3.', 80.00, 12, 'https://marketplace.com/product/3', '2023-04-03T14:45:00+03'),
    ('Товар 4', 'Описание товара 4.', 120.00, 5, 'https://marketplace.com/product/4', '2023-04-04T16:00:00+03'),
    ('Товар 5', 'Описание товара 5.', 90.00, 8, 'https://marketplace.com/product/5', '2023-04-05T17:15:00+03'),
    ('Товар 6', 'Описание товара 6.', 110.00, 9, 'https://marketplace.com/product/6', '2023-04-06T18:30:00+03'),
    ('Товар 7', 'Описание товара 7.', 130.00, 6, 'https://marketplace.com/product/7', '2023-04-07T19:45:00+03'),
    ('Товар 8', 'Описание товара 8.', 140.00, 4, 'https://marketplace.com/product/8', '2023-04-08T21:00:00+03'),
    ('Товар 9', 'Описание товара 9.', 160.00, 3, 'https://marketplace.com/product/9', '2023-04-09T22:15:00+03'),
    ('Товар 10', 'Описание товара 10.', 170.00, 2, 'https://marketplace.com/product/10', '2023-04-10T23:30:00+03');

-- Вставка данных в таблицу Покупки

INSERT INTO purchases (customer_id, product_id, amount, score, added_at, scored_at)
VALUES
    (1, 1, 2, 4, '2023-04-01T12:00:00+03', '2023-04-01T12:00:00+03'),
    (2, 2, 1, 5, '2023-04-02T13:30:00+03', '2023-04-02T13:30:00+03'),
    (1, 3, 3, 3, '2023-04-03T14:45:00+03', '2023-04-03T14:45:00+03'),
    (1, 4, 2, 4, '2023-04-04T16:00:00+03', '2023-04-04T16:00:00+03'),
    (2, 5, 1, 5, '2023-04-05T17:15:00+03', '2023-04-05T17:15:00+03'),
    (1, 9, 2, 4, '2023-04-06T18:30:00+03', '2023-04-06T18:30:00+03'),
    (2, 7, 1, 5, '2023-04-07T19:45:00+03', '2023-04-07T19:45:00+03'),
    (3, 8, 3, 3, '2023-04-08T21:00:00+03', '2023-04-08T21:00:00+03'),
    (4, 9, 2, 4, '2023-04-09T22:15:00+03', '2023-04-09T22:15:00+03'),
    (1, 10, 1, NULL, '2023-04-10T23:30:00+03', NULL),
    (1, 1, 2, 3, '2023-04-11T12:00:00+03', '2023-04-11T12:00:00+03'),
    (2, 2, 1, 5, '2023-04-12T13:30:00+03', '2023-04-12T13:30:00+03'),
    (3, 3, 3, 4, '2023-04-13T14:45:00+03', '2023-04-13T14:45:00+03'),
    (1, 4, 2, 4, '2023-04-14T16:00:00+03', '2023-04-14T16:00:00+03'),
    (5, 5, 1, 3, '2023-04-15T17:15:00+03', '2023-04-15T17:15:00+03'),
    (1, 9, 2, 5, '2023-04-16T18:30:00+03', '2023-04-16T18:30:00+03'),
    (2, 7, 1, 4, '2023-04-17T19:45:00+03', '2023-04-17T19:45:00+03'),
    (3, 9, 3, 2, '2023-04-18T21:00:00+03', '2023-04-18T21:00:00+03'),
    (4, 9, 2, 3, '2023-04-19T22:15:00+03', '2023-04-19T22:15:00+03'),
    (1, 10, 1, NULL, '2023-04-20T23:30:00+03', NULL);

-- Вывод информации о покупках первого покупателя

SELECT products.title AS "Product",
       purchases.amount AS "Amount",
       COALESCE(purchases.score::TEXT, 'N/A') AS "Score",
       purchases.added_at AS "Date"
FROM purchases
JOIN products ON purchases.product_id = products.product_id
WHERE purchases.customer_id = 1
ORDER BY "Date" DESC;

-- Вывод информации о рейтинге и общем количестве проданных товаров

SELECT products.title AS "Product",
       COALESCE(SUM(purchases.amount)::TEXT, '0') AS "Total purchased",
       COALESCE(products.rating::TEXT, 'N/A') AS "Rating"
FROM products
LEFT JOIN purchases ON products.product_id = purchases.product_id
GROUP BY products.product_id
ORDER BY products.product_id
