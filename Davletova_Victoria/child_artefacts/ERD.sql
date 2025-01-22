-- Создание таблицы пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15)
);

-- Создание таблицы треков
CREATE TABLE tracks (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist VARCHAR(255) NOT NULL,
    album VARCHAR(255),
    genre VARCHAR(100),
    duration DECIMAL(5, 2) NOT NULL
);

-- Создание таблицы истории прослушивания
CREATE TABLE listening_histories (
    history_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    track_id INT NOT NULL,
    listening_date TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT fk_histories_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_histories_tracks FOREIGN KEY (track_id) REFERENCES tracks(track_id) ON DELETE CASCADE
);

-- Добавление данных в таблицу пользователей
INSERT INTO users (first_name, last_name, email, phone_number)
VALUES 
('Vicktor', 'Voronov', 'viktor.voronov@example.ru', '1234567890'),
('Zoya', 'Voronova', 'zoya.voronova@example.ru', '0987654321'); 

-- Добавление данных в таблицу треков
INSERT INTO tracks (title, artist, album, genre, duration)
VALUES 
('No Pole', 'Don Toliver', 'No Pole', 'Hip-Hop', 3.22),
('Wanted, Pt.2', 'Nevelle Viracocha', 'Astral Hour', 'Hip-Hop', 3.35);

-- Добавление данных в таблицу истории прослушивания
INSERT INTO listening_histories (user_id, track_id, listening_date)
VALUES 
(1, 1, '2024-11-15 10:00:00+00'),
(1, 2, '2024-11-16 11:00:00+00'),
(2, 1, '2024-11-16 12:00:00+00');

-- Запрос всех пользователей
SELECT * FROM users;

-- Запрос всех треков
SELECT * FROM tracks;

-- Запрос записей истории прослушивания с возможностью фильтрации от новых к старым
SELECT * FROM listening_histories
ORDER BY listening_date DESC NULLS LAST;

-- Запрос истории прослушивания для конкретных пользователей
SELECT lh.history_id, u.first_name, u.last_name, t.title, t.artist, lh.listening_date
FROM listening_histories lh
JOIN users u ON lh.user_id = u.user_id
JOIN tracks t ON lh.track_id = t.track_id
WHERE u.user_id IN (1, 2)
ORDER BY lh.listening_date DESC;
