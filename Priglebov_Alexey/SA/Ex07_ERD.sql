-- Создание таблиц

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(255) NULL
);

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    house BOOLEAN,
    flat BOOLEAN,
    townhouse BOOLEAN,
    summer_house BOOLEAN
);

CREATE TABLE Locations (
    location_id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    region VARCHAR(100) NULL,
    locality VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    house_number VARCHAR(20) NOT NULL
);

CREATE TABLE Real_estates (
    real_estate_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    price NUMERIC(15, 2) NOT NULL,
    area NUMERIC(10, 2) NOT NULL,
    category_id INTEGER REFERENCES Categories(category_id),
    location_id INTEGER REFERENCES Locations(location_id)
);

-- Заполнение таблиц

-- Заполнение таблицы Users
INSERT INTO Users (name, surname, phone, email) VALUES
('Иван', 'Иванов', '89991111111', 'ivan@mail.ru'),
('Виктория', 'Викторова', '89992222222', 'viktoria@mail.ru'),
('Василий', 'Васильев', '89993333333', 'vasiliy@mail.ru');

-- Заполнение таблицы Categories
INSERT INTO Categories (house, flat, townhouse, summer_house) VALUES
('TRUE', 'FALSE', 'FALSE', 'FALSE'),
('FALSE', 'TRUE', 'FALSE', 'FALSE'),
('FALSE', 'FALSE', 'TRUE', 'FALSE'),
('FALSE', 'FALSE', 'FALSE', 'TRUE');

-- Заполнение таблицы Locations
INSERT INTO Locations (country, region, locality, street, house_number) VALUES
('РФ', 'Московская область', 'Химки', 'Первая', '1А'),
('РФ', 'Курская область', 'Курск', 'Вторая', '2'),
('РФ', 'NULL', 'Москва', 'Третья', '3');

-- Заполнение таблицы Real_estates
INSERT INTO Real_estates (user_id, price, area, category_id, location_id) VALUES
('1', '5000000', '25', '2', '1'),
('2', '7000000', '70', '1', '2'),
('3', '9000000', '30', '2', '3');

-- Проверка поиска по цене "За все"

SELECT 
    re.real_estate_id,
    re.price,
    (re.price / re.area) AS price_m,
    re.area,
    loc.country,
    loc.region,
    loc.locality,
    loc.street,
    loc.house_number
FROM 
    Real_estates re
JOIN 
    Categories c ON re.category_id = c.category_id
JOIN 
    Locations loc ON re.location_id = loc.location_id
WHERE 
    re.price >= 2500000 AND re.price <= 8000000
    AND c.flat = TRUE;

-- Проверка поиска по цене "За кв.м"

SELECT
   re.real_estate_id,
    re.price,
    (re.price / re.area) AS price_m,
    re.area,
    loc.country,
    loc.region,
    loc.locality,
    loc.street,
    loc.house_number
FROM 
    Real_estates re
JOIN 
    Categories c ON re.category_id = c.category_id
JOIN 
    Locations loc ON re.location_id = loc.location_id
WHERE 
    (re.price / re.area) >= 25000 
    AND (re.price / re.area) <= 210000 
    AND c.house = TRUE;
