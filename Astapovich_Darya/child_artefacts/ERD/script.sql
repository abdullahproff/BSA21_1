CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    birthday DATE
);
CREATE TABLE villas (
    villa_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    house VARCHAR(10) NOT NULL,
    max_guests INT NOT NULL,
    villa_class VARCHAR(50),
    sea_view BOOLEAN,
    wifi BOOLEAN,
    payment_method BOOLEAN NOT NULL,
    price_night DECIMAL NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    villa_id INT NOT NULL,
    user_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    price_total DECIMAL NOT NULL,
    number_guests INT NOT NULL,
    CONSTRAINT fk_orders_villa_id FOREIGN KEY (villa_id) REFERENCES villas(villa_id),
    CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- пользователи
INSERT INTO users (name, surname, birthday)
VALUES 
('Кирилл', 'Иванов', '1969-01-01'),
('Полина', 'Фролова', '1975-05-12'),
('Елизавета', 'Козлова', '2001-03-15');

-- виллы
INSERT INTO villas (name, country, city, street, house, max_guests, villa_class, sea_view, wifi, payment_method, price_night)
VALUES 
('Panaram', 'Thailand', 'Phuket', 'Phuket road', '28', 6, 'Delux', TRUE, FALSE, TRUE, 18.50),
('Guoda', 'Georgia', 'Tbilisi', 'Panaramskay ', '14a', 4, 'Lux', TRUE, FALSE, TRUE, 200.67),
('Ivolita', 'Thailand', 'Phangan',' Thong Nai Pan Noi Bay', '18', 8, 'Delux', TRUE, TRUE, TRUE, 500.4);

-- заказы
INSERT INTO orders (user_id, villa_id, check_in_date, departure_date, price_total, number_guests)
VALUES 
(1, 1, '2024-12-12', '2024-12-25', 19690, 3),
(2, 2, '2024-11-12', '2024-12-12', 1756, 1),
(3, 3, '2024-10-12', '2024-11-09', 2001, 5);
