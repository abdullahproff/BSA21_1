-- таблица пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR ,
    number VARCHAR NOT NULL,
    email  VARCHAR
);

-- таблица водителей
CREATE TABLE drivers (
   driver_id SERIAL PRIMARY KEY,
   name VARCHAR NOT NULL,
   photo_url VARCHAR,
   brand_car VARCHAR NOT NULL,
   car_number VARCHAR NOT NULL
   
);

-- таблица заказов
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    driver_id INT NOT NULL,
    user_id INT NOT NULL,
    address_start VARCHAR NOT NULL,
    address_finish VARCHAR NOT NULL,
    price DECIMAL NOT NULL,
    rate VARCHAR,
    payment_type BOOLEAN NOT NULL,
    CONSTRAINT fk_orders_driver_id FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (name, number, email)
VALUES 
('Ангелина', '+79805678766', 'fgghgj@bk.ru'),
('Илья', '+7932468906', 'daserf@google.com'),
('Мартин', '+79214560324', 'awer433@mail.ru');

INSERT INTO drivers (name, photo_url, brand_car, car_number)
VALUES 
('Казбек', 'https://example.com/photos/john_doe.jpg', 'Toyota', 'ABC123'),
('Петр', 'https://example.com/photos/jon_doe.jpg', 'Honda', 'XYZ789'),
('Владимир', 'https://example.com/photos/ohn_doe.jpg', 'BMW', 'Th7693');

INSERT INTO orders (user_id, driver_id, address_start, address_finish, price, rate, payment_type)
VALUES
(1, 1, '789 Oak St, City C', '456 Elm St, City C', 1990, 'Economy', true),
(2, 2, '719 Oak St, City C', '321 Pine St, City C', 1756, 'Comfort', false),
(3, 3, '123 Main St, City A', '31 Pine St, City A', 2001, 'Business', true);

SELECT * FROM users;
SELECT * FROM drivers; 
SELECT * FROM orders;
