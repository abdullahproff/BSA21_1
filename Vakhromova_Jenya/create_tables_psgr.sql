CREATE TABLE clients
(
    client_id      INT PRIMARY KEY,
    tel_number_client    VARCHAR(50) UNIQUE CHECK (tel_number_client ~ '^\+?[0-9]{2,}$'),
    name_client        VARCHAR(150) not NULL,
    surname_client        VARCHAR(150),
    patronymic_client        VARCHAR(150),
    city_client            VARCHAR(150),
    email_client          VARCHAR(255) UNIQUE CHECK (email_client ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE photographers
(
    photographer_id    INT PRIMARY KEY,
    tel_number_ph      VARCHAR(50) UNIQUE CHECK (tel_number_ph ~ '^\+?[0-9]{2,}$'),
    name_ph            VARCHAR(150) not NULL,
    surname_ph         VARCHAR(150),
    patronymic_ph      VARCHAR(150),
    main_city_ph       VARCHAR(150),
    email_ph           VARCHAR(255) UNIQUE CHECK (email_ph ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    type_ph            TEXT[],
    price_list         VARCHAR(100),
    calendar_ph        VARCHAR(100),
    style_ph           TEXT[],
    portfolio          VARCHAR(100),
    rating_ph          INT
);

CREATE TABLE orders
(
    order_id          INT PRIMARY KEY,
    client_id         INT NOT NULL,
    photographer_id    INT,
    time_date         TIMESTAMP WITH TIME ZONE,
    order_location    text,
    duration          INTERVAL,
    type_order        VARCHAR(50),
    style_order       VARCHAR(50),
    summary_price     DECIMAL(10, 2),
    prepayment        DECIMAL(10, 2),
    CONSTRAINT fk_orders_clients FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT fk_orders_photographers FOREIGN KEY (photographer_id) REFERENCES photographers(photographer_id)
);

CREATE TABLE locations
(
	loc_id	INT PRIMARY KEY,
    photographer_id INT NOT NULL,
    ph_country VARCHAR(100) NOT NULL,
    ph_city VARCHAR(100),
    ph_street VARCHAR(100),
    ph_building VARCHAR(50),
    ph_latitude DECIMAL(8, 6) NOT NULL,
    ph_longitude DECIMAL(8, 6) NOT NULL,
    CONSTRAINT fk_locations_photographers FOREIGN KEY (photographer_id) REFERENCES photographers(photographer_id)
);

--  примеры вставки данных 
-- для каждой из таблиц (clients, photographers, orders, locations)

INSERT INTO clients (client_id, tel_number_client, name_client, surname_client, patronymic_client, city_client, email_client) VALUES
(1, '+1234567890', 'Александр', 'Иванов', 'Сергеевич', 'Москва', 'alexandr.ivanov@example.com'),
(2, '+9876543210', 'Мария', 'Петрова', 'Владимировна', 'Санкт-Петербург', 'maria.petrova@example.com'),
(3, '+1029384756', 'Дмитрий', 'Сидоров', 'Алексеевич', 'Казань', 'dmitriy.sidorov@example.com');

INSERT INTO photographers (photographer_id, tel_number_ph, name_ph, surname_ph, patronymic_ph, main_city_ph, email_ph, type_ph, price_list, calendar_ph, style_ph, portfolio, rating_ph) VALUES 
(1, '+1234567891', 'Иван', 'Смирнов', 'Андреевич', 'Москва', 'ivan.smirnov@example.com', '{"Фотограф"}', 'link', 'family', '{"Портрет"}', 'portfolio_ivan.com', 5),
(2, '+2345678901', 'Ольга', 'Кузнецова', 'Дмитриевна', 'Санкт-Петербург', 'olga.kuznetsova@example.com', '{"Семейный"}', 'link', 'Семейная', '{"чб"}', 'portfolio_olga.ru', 4),
(3, '+3456789012', 'Алена', 'Васильева', 'Игоревна', 'Екатеринбург', 'alena.vasilieva@example.com', '{"Модельный"}', 'link', 'Детская', '{"Модельный"}', 'portfolio_alena.ru', 5);

INSERT INTO orders (order_id, client_id, photographer_id, order_location, duration, type_order, style_order, summary_price, prepayment) VALUES
(1, 1, 1,  'Питер, Невский, 3', '2 hours', 'Событие', 'modern', 5000.00, 2500.00),
(2, 2, 2, 'Москва, Тверская, 17', '1.5 hours', 'Свадьба', NULL, 7000.00, 3500.00),
(3, 3, 3, 'Нижний Новгород, Ленина, 39/4', '3 hours', 'Портрет', 'чб', 10000.00, 5000.00);	

INSERT INTO locations (loc_id, photographer_id, ph_country, ph_city, ph_street, ph_building, ph_latitude, ph_longitude) VALUES
(1, 1, 'Россия', 'Москва', 'Тверская', '1', 55.75580000, 37.61730000),
(2, 2, 'Россия', 'Санкт-Петербург', 'Невский проспект', '10', 59.93430000, 30.33510000),
(3, 1, 'Россия', 'Екатеринбург', 'Ленина', '5', 56.83890000, 60.60570000),	
(4, 3, 'Россия', 'NY', 'Ленина', '15', 56.83890000, 43.60570000);	

-- пример фильтрации списка фотографа по локации
select distinct ph.photographer_id, tel_number_ph, name_ph, surname_ph, patronymic_ph, main_city_ph, email_ph, 
	type_ph, price_list, calendar_ph, style_ph, portfolio, rating_ph
from  photographers ph inner join locations l on ph.photographer_id = l.photographer_id
where ph_latitude >= 55  and ph_latitude <= 57 and
	ph_longitude >= 36 and ph_longitude <= 61;