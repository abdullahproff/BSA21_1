-- таблица адресов доставки
CREATE TABLE delivery_addresses (
    address_id SERIAL PRIMARY KEY,
    sity VARCHAR NOT NULL,
    street VARCHAR NOT NULL,
    house VARCHAR NOT NULL,
    apartment VARCHAR
);

-- таблица пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    surname VARCHAR NOT NULL,
    email VARCHAR,
    phone VARCHAR NOT NULL,
    address_id INT NOT NULL,
    CONSTRAINT users_delivery_addresses_fk FOREIGN KEY (address_id) REFERENCES delivery_addresses(address_id)
);

-- таблица товаров
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    price INT NOT NULL,
    category VARCHAR NOT NULL,
    quantity INT NOT NULL,
    size VARCHAR,
    weight INT
);

-- таблица заказов
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    status VARCHAR NOT NULL,
    total_cost INT NOT NULL,
    order_date DATE NOT NULL,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    CONSTRAINT orders_users_fk FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT orders_delivery_addresses_fk FOREIGN KEY (address_id) REFERENCES delivery_addresses(address_id)
);

-- таблица позиций в заказах
CREATE TABLE order_positions (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT order_positions_pk PRIMARY KEY (order_id, product_id),
    CONSTRAINT order_positions_orders_fk FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT order_positions_products_fk FOREIGN KEY (product_id) REFERENCES products(product_id)
);



-- адреса доставки
INSERT INTO delivery_addresses (sity, street, house, apartment)
VALUES 
('Москва', 'Космонавтов', '34', '1'),
('Новосибирск', 'Ленина', '19', '12'),
('Петрозаводск', 'Машезерская', '56', '44');

-- пользователи
INSERT INTO users (name, surname, email, phone, address_id)
VALUES 
('Мария', 'Марченко', 'masha@mail.ru', '809110000001', 1),
('Иван', 'Сергеев', 'ivan@mail.ru', '809110000002', 2),
('Алина', 'Ясинская', 'alina@mail.ru', '809110000003', 3);

-- товары
INSERT INTO products (name, description, price, category, quantity, size, weight)
VALUES 
('Корм Monge', 'Сухой корм для кошек с чувствительным пищеварением', '1700', 'Корма', '28', '40х50', '1500'),
('Лежанка', 'Мягкая лежанка для кошек и собак, с бортиками', '2500', 'Лежанки', '49', '50x50', '1000'),
('Фурминатор', 'Расческа для вычёсывания подшерстка, подходит для кошек и собак с длинной шерстью', '3500','Расчески', '18', '10x25', '300');

-- заказы
INSERT INTO orders (status, total_cost, order_date, user_id, address_id)
VALUES 
('В обработке', '1700', '2024-12-12', 1, 1),
('Собран', '2500', '2024-11-12', 2, 2),
('Доставлен', '3500', '2024-10-12', 3, 3);

-- позиции в заказах
INSERT INTO order_positions (order_id, product_id, quantity)
VALUES 
(1, 1, '1'),
(2, 2, '1'),
(3, 3, '1');