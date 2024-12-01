-- Создание таблиц

-- Таблица пользователей
CREATE TABLE Users (
    user_ID INT PRIMARY KEY, 
    user_name VARCHAR, 
    license_issue_date DATE, 
    loyalty_points INT, 
    user_city VARCHAR, 
    user_status VARCHAR, 
    email VARCHAR UNIQUE NOT NULL, 
    driving_license_number VARCHAR
);

-- Таблица автомобилей
CREATE TABLE Cars (
    car_ID INT PRIMARY KEY, 
    license_plate VARCHAR UNIQUE NOT NULL, 
    car_category VARCHAR, 
    last_adress VARCHAR, 
    fuel_level DECIMAL, 
    car_details TEXT,
    is_reserved BOOLEAN,
    user_ID INT,
    FOREIGN KEY (user_ID) REFERENCES Users(user_ID)
);

-- Таблица поездок
CREATE TABLE Trips (
    trip_ID SERIAL PRIMARY KEY, 
    trip_type VARCHAR, 
    destination_adress VARCHAR, 
    booking_start_time TIMESTAMP, 
    booking_timer TIMESTAMP, 
    total_price DECIMAL,
    user_ID INT,
    car_ID INT,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID),
    FOREIGN KEY (car_ID) REFERENCES cars(car_ID)
);


-- Заполнение таблицы Users
INSERT INTO users (user_ID, user_name, license_issue_date, loyalty_points, user_city, user_status, email, driving_license_number) VALUES
(1, 'Алексей Голубкин', '2010-12-29', 256, 'Казань', '+', 'alexgg@mail.ru', '00987 654321'),
(2, 'Ирина Панфилова', '2014-04-06', 500, 'Москва', '+++', 'irinapan@mail.ru', '9999 999956');


-- Заполнение таблицы Cars
INSERT INTO cars (car_ID, license_plate, car_category, last_adress, fuel_level, car_details, is_reserved, user_ID) VALUES
(1, 'А123ВС716', 'Эконом', 'Казань, ул. Советская, 24', 50.5, 'Hyundai Solaris, 2019, 1.6 л, 123 л.с., седан', false, 1),
(2, 'В456ТА716', 'Бизнес', 'Казань, ул. Баумана, 10', 30.0, 'Toyota Camry, 2020, 2.0 л, 150 л.с., седан', false, 1),
(3, 'С789АА977', 'Бизнес', 'Москва, ул.  Сельскохозяйственная, 32Б', 75.0, 'BMW 5 Series, 2021, 3.0 л, 249 л.с., универсал', false, 2),
(4, 'К123ОТ799', 'Эконом', 'Москва, ул. Ленина, 12', 40.5, 'Kia Rio, 2018, 1.4 л, 100 л.с., хэтчбек', false, 2),
(5, 'Е100ЕЕ797', 'Комфорт', 'Москва, ул. Мира, 20', 60.0, 'Volkswagen Passat, 2019, 1.8 л, 150 л.с., седан', true, 2);




-- Создание поездки "Межгород" в Санкт-Петербург для Ирины Панфиловой на автомобиле класса "бизнес"
INSERT INTO Trips (trip_type, destination_adress, booking_start_time, booking_timer, total_price, user_ID, car_ID)
SELECT 
    'Межгород' AS trip_type, 
    'Санкт-Петербург' AS destination_adress, 
    NOW() AS booking_start_time, 
    NOW() + INTERVAL '30 MINUTE' AS booking_timer,
    GREATEST(5000.00 - u.loyalty_points, 0) AS total_price,     
    u.user_ID,
    c.car_ID
FROM 
    Users u
JOIN 
    Cars c ON c.car_category = 'Бизнес' AND c.is_reserved = false
WHERE 
    u.user_name = 'Ирина Панфилова' 
    AND c.user_ID = u.user_ID
LIMIT 1;



-- Создание поездки "Межгород" в Пермь для Алексея Голубкина на машине с бОльшим запасом топлива
INSERT INTO Trips (trip_type, destination_adress, booking_start_time, booking_timer, total_price, user_ID, car_ID)
SELECT 
    'Межгород' AS trip_type, 
    'Пермь' AS destination_adress, 
    NOW() AS booking_start_time, 
    NOW() + INTERVAL '15 MINUTE' AS booking_timer, 
    GREATEST(3000.00 - u.loyalty_points, 0) AS total_price,     
    u.user_ID,
    c.car_ID
FROM 
    Users u
JOIN 
    Cars c ON c.is_reserved = false 
WHERE 
    u.user_name = 'Алексей Голубкин' 
    AND c.user_ID = u.user_ID
ORDER BY 
    c.fuel_level DESC
LIMIT 1;

-- Создание поездки "Межгород" в Санкт-Петербург для Ирины Панфиловой на автомобиле класса "эконом"
INSERT INTO Trips (trip_type, destination_adress, booking_start_time, booking_timer, total_price, user_ID, car_ID)
SELECT 
    'Межгород' AS trip_type, 
    'Сочи' AS destination_adress, 
    NOW() AS booking_start_time, 
    NOW() + INTERVAL '30 MINUTE' AS booking_timer, 
    GREATEST(10000.00 - u.loyalty_points, 0) AS total_price,  -- Укажите стоимость поездки, если она фиксированная
    u.user_ID,
    c.car_ID
FROM 
    Users u
JOIN 
    Cars c ON c.car_category = 'Эконом' AND c.is_reserved = false  -- Выбираем машины класса "Эконом", которые не забронированы
WHERE 
    u.user_name = 'Ирина Панфилова' 
    AND c.user_ID = u.user_ID
LIMIT 1;

--Посмотреть таблицу с созданными поездками
SELECT * FROM Trips;

--Посмотреть таблицу с автомобилями, которые находятся в г. Москва
SELECT * 
FROM Cars
WHERE last_adress LIKE '%Москва%';

--Посмотреть все доступные автомобили для пользователя Алексей Голубкин
SELECT c.*
FROM Cars c
JOIN Users u ON c.user_ID = u.user_ID
WHERE u.user_name = 'Алексей Голубкин'
  AND c.is_reserved = false;
 
 