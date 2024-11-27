CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR,
    opening_time VARCHAR,
    closing_time VARCHAR,
    floor_count INT
);

CREATE TABLE floors (
    floor_id INT PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    name VARCHAR
);

CREATE TABLE tables (
    table_id INT PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    floor_id INT REFERENCES floors(floor_id),
    capacity INT
);

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR,
    email VARCHAR,
    phone_number VARCHAR
);

CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    user_id INT REFERENCES users(user_id),
    table_id INT REFERENCES tables(table_id),
    reservation_date DATE,
    start_time VARCHAR,
    end_time VARCHAR,
    reason VARCHAR,
    guests_count INT,
    additional_info VARCHAR,
    status VARCHAR
);
-- Заполнение таблиц
INSERT INTO restaurants (restaurant_id, name, opening_time, closing_time, floor_count)
VALUES
(1, 'Restaurant A', '08:00:00', '22:00:00', NULL),
(2, 'Restaurant B', '09:00:00', '23:00:00', NULL);

INSERT INTO floors (floor_id, restaurant_id, name)
VALUES
(1, 1, 'First Floor'),
(2, 1, 'Second Floor'),
(3, 2, 'Terrace'),
(4, 2, 'VIP Zone');

INSERT INTO tables (table_id, restaurant_id, floor_id, capacity)
VALUES
(1, 1, 1, 4),
(2, 1, 1, 6),
(3, 1, 2, 8),
(4, 2, 3, 10),
(5, 2, 4, 12); 

INSERT INTO users (user_id, full_name, email, phone_number)
VALUES
(1, 'John Doe', 'john.doe@example.com', '123-456-7890'),
(2, 'Jane Smith', 'jane.smith@example.com', '987-654-3210');

INSERT INTO reservations (reservation_id, restaurant_id, user_id, table_id, reservation_date, start_time, end_time, reason, guests_count, additional_info, status)
VALUES
(1, 1, 1, 1, '2024-11-25', '12:00:00', '14:00:00', 'REGULAR_VISIT', 4, 'Window seat preferred', 'CONFIRMED'),
(2, 1, 2, 2, '2024-11-26', '18:00:00', '20:00:00', 'REGULAR_VISIT', 2, 'Celebration', 'WAITING_FOR_CONFIRMATION'),
(3, 2, 1, 4, '2024-11-27', '13:00:00', '14:30:00', 'TECHNICAL_REASON', 10, 'Maintenance required', 'CONFIRMED');

-- Вывод всех бронирований:
SELECT 
    res.reservation_id,
    res.reservation_date,
    res.start_time,
    res.end_time,
    res.guests_count,
    res.reason,
    res.status,
    res.additional_info,
    u.full_name AS user_name,
    u.email AS user_email,
    u.phone_number AS user_phone,
    r.name AS restaurant_name,
    f.name AS floor_name,
    t.table_id AS table_number,
    t.capacity AS table_capacity
FROM reservations res
JOIN users u ON res.user_id = u.user_id
JOIN tables t ON res.table_id = t.table_id
JOIN restaurants r ON res.restaurant_id = r.restaurant_id
LEFT JOIN floors f ON t.floor_id = f.floor_id
ORDER BY res.reservation_date, res.start_time;

-- Поиск свободных столиков на определенную дату и время:
SELECT t.*
FROM tables t
LEFT JOIN reservations r ON t.table_id = r.table_id 
    AND r.reservation_date = '2024-11-25'
    AND '12:00:00' BETWEEN r.start_time AND r.end_time
WHERE r.reservation_id IS NULL;