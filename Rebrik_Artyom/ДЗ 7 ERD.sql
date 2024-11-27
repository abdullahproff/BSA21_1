-- Создание таблиц
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    opening_time VARCHAR(8) NOT NULL,
    closing_time VARCHAR(8) NOT NULL,
    floor_count INT
);
CREATE TABLE floors (
    floor_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE tables (
    table_id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    floor_id INT REFERENCES floors(floor_id),
    capacity INT NOT NULL CHECK (capacity > 0)
);
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    table_id INT NOT NULL REFERENCES tables(table_id) ON DELETE CASCADE,
    reservation_date DATE NOT NULL,
    start_time VARCHAR(8) NOT NULL,
    end_time VARCHAR(8) NOT NULL,
    reason VARCHAR(50) NOT NULL CHECK (reason IN ('REGULAR_VISIT', 'TECHNICAL_REASON')),
    guests_count INT NOT NULL CHECK (guests_count > 0),
    additional_info TEXT,
    status VARCHAR(50) NOT NULL CHECK (status IN ('WAITING_FOR_CONFIRMATION', 'CONFIRMED', 'CANCELLED'))
);
-- Заполнение таблиц
INSERT INTO restaurants (name, opening_time, closing_time)
VALUES
('Restaurant A', '08:00:00', '22:00:00'),
('Restaurant B', '09:00:00', '23:00:00');
INSERT INTO floors (restaurant_id, name)
VALUES
(1, 'First Floor'),
(1, 'Second Floor'),
(2, 'Terrace'),
(2, 'VIP Zone');
INSERT INTO tables (restaurant_id, floor_id, capacity)
VALUES
(1, 1, 4),
(1, 1, 6),
(1, 2, 8),
(2, 3, 10),
(2, 4, 12);
INSERT INTO users (full_name, email, phone_number)
VALUES
('John Doe', 'john.doe@example.com', '123-456-7890'),
('Jane Smith', 'jane.smith@example.com', '987-654-3210');
INSERT INTO reservations (restaurant_id, user_id, table_id, reservation_date, start_time, end_time, reason, guests_count, additional_info, status)
VALUES
(1, 1, 1, '2024-11-25', '12:00:00', '14:00:00', 'REGULAR_VISIT', 4, 'Window seat preferred', 'CONFIRMED'),
(1, 2, 2, '2024-11-26', '18:00:00', '20:00:00', 'REGULAR_VISIT', 2, 'Celebration', 'WAITING_FOR_CONFIRMATION'),
(2, 1, 4, '2024-11-27', '13:00:00', '14:30:00', 'TECHNICAL_REASON', 10, 'Maintenance required', 'CONFIRMED');
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