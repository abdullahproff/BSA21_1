--Создание таблиц
create table users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100),
    address VARCHAR(100)
);

create table orders (
    order_id SERIAL PRIMARY KEY,
    order_number INT,
    create_at TIMESTAMP WITH TIME ZONE,
    order_product VARCHAR(100),
    user_id INT,
    CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

create table deliveries (
    delivery_id SERIAL PRIMARY KEY,
    delivery_date TIMESTAMP WITH TIME ZONE,
    delivery_product VARCHAR(100),
    delivery_address VARCHAR(100),
    order_id INT,
    CONSTRAINT fk_deliveries_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE
);

CREATE TYPE status_enum AS ENUM(
    'Принят',
    'Собирается',
    'В пути',
    'Ожидает в пункте выдачи',
    'Задерживается',
    'Отменён'
);

create table products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    status status_enum Default 'Принят',
    order_id INT,
    CONSTRAINT fk_products_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE
);

create table delivery_points (
    delivery_point_id SERIAL PRIMARY KEY,
    delivery_point_address VARCHAR(100),
    delivery_point_time VARCHAR(100),
    delivery_point_product VARCHAR(100),
    order_storage_term VARCHAR(100),
    user_id INT,
    order_id INT,
    CONSTRAINT fk_delivery_points_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_delivery_points_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE
);

--Данные в таблицах
INSERT INTO
    users (user_id, user_name, address)
VALUES (
        2,
        'Елена',
        'Москва Алтуфьевское шоссе дом 95 кв 10'
    );

INSERT INTO
    orders (
        order_id,
        order_number,
        create_at,
        order_product,
        user_id
    )
VALUES (
        21,
        '248',
        '2024-10-10 00:00:00+00',
        'Чехол для Samsung 21',
        2
    ),
    (
        22,
        '248',
        '2024-10-11 00:00:00+00',
        'Толстовка Puma',
        2
    ),
    (
        23,
        '248',
        '2024-10-11 00:00:00+00',
        'Кроссовки Nike',
        2
    );

INSERT INTO
    deliveries (
        delivery_id,
        delivery_date,
        delivery_product,
        delivery_address,
        order_id
    )
VALUES (
        10,
        '2024-10-14 00:00:00+00',
        'Чехол для Samsung 21',
        'Алтуфьевское шоссе 97',
        21
    ),
    (
        11,
        '2024-10-14 00:00:00+00',
        'Толстовка Puma',
        'Алтуфьевское шоссе 97',
        22
    ),
    (
        12,
        '2024-10-15 00:00:00+00',
        'Кроссовки Nike',
        'Алтуфьевское шоссе 97',
        23
    );

INSERT INTO
    products (
        product_id,
        product_name,
        status,
        order_id
    )
VALUES (
        100,
        'Чехол для Samsung 21',
        'Ожидает в пункте выдачи',
        21
    ),
    (
        101,
        'Толстовка Puma',
        'Ожидает в пункте выдачи',
        22
    ),
    (
        102,
        'Кроссовки Nike',
        'Задерживается',
        23
    );

INSERT INTO
    delivery_points (
        delivery_point_id,
        delivery_point_address,
        delivery_point_time,
        user_id,
        delivery_point_product,
        order_storage_term,
        order_id
    )
VALUES (
        31,
        'Алтуфьевское шоссе 97',
        '10:00-22:00',
        2,
        'Чехол для Samsung 21',
        'до 20 октября',
        21
    ),
    (
        32,
        'Алтуфьевское шоссе 97',
        '10:00-22:00',
        2,
        'Толстовка Puma',
        'до 21 октября',
        22
    );

--Вывод таблицы
SELECT
    users.user_id AS "ID пользователя",
    users.user_name AS "Имя пользователя",
    users.address AS "Адрес пользователя",
    orders.order_id AS "ID заказа",
    orders.order_number AS "Номер заказа",
    orders.create_at AS "Дата заказа",
    delivery_points.delivery_point_address AS "Адрес пункта выдачи",
    delivery_points.delivery_point_time AS "Режим работы",
    delivery_points.delivery_point_product AS "Товар в пункте выдачи",
    delivery_points.order_storage_term AS "Срок хранения заказа"
FROM
    users
    LEFT JOIN orders ON users.user_id = orders.user_id
    LEFT JOIN delivery_points ON orders.order_id = delivery_points.order_id;

SELECT
    products.product_id AS "ID продукта",
    products.product_name AS "Название продукта",
    products.status AS "Статус продукта",
    orders.order_id AS "ID заказа",
    orders.order_number AS "Номер заказа",
    orders.create_at AS "Дата заказа"
FROM products
    LEFT JOIN orders ON products.order_id = orders.order_id;

SELECT
    delivery_product AS "Товар в доставке",
    delivery_date AS "Дата доставки",
    delivery_address AS "Адрес доставки",
    order_product AS "Товар заказанный",
    order_number AS "Номер заказа",
    create_at AS "Дата заказа",
    delivery_point_address AS "Адрес пункта выдачи",
    delivery_point_time AS "Режим работы",
    delivery_point_product AS "Товар в пункте выдачи",
    order_storage_term AS "Срок хранения заказа"
FROM
    deliveries
    LEFT JOIN orders ON deliveries.order_id = orders.order_id
    LEFT JOIN delivery_points ON deliveries.order_id = delivery_points.order_id;

SELECT
    o.order_id AS "ID заказа",
    o.order_number AS "Номер заказа",
    o.create_at AS "Дата заказа",
    dp.delivery_point_address AS "Адрес пункта выдачи",
    dp.delivery_point_time AS "Режим работы",
    dp.delivery_point_product AS "Товар в пункте выдачи",
    dp.order_storage_term AS "Срок хранения заказа"
FROM orders o
    LEFT JOIN delivery_points dp ON o.order_id = dp.order_id;

--Удаление таблиц и enum
drop table IF EXISTS users,
orders,
products,
delivery_points,
deliveries;

drop type status_enum;

/*select * from users;
select * from deliveries;
select * from orders;
select * from products;
select * from delivery_points;*/