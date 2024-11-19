-- ============================
-- 1. Создание таблиц
-- ============================

-- Таблица пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Таблица исполнителей
CREATE TABLE artists (
    artist_id SERIAL PRIMARY KEY,
    artist_name VARCHAR(255) UNIQUE NOT NULL,
    bio_artist TEXT
);

-- Таблица альбомов
CREATE TABLE albums (
    album_id SERIAL PRIMARY KEY,
    title_album VARCHAR(255) NOT NULL,
    artist_id INT NOT NULL,
    release_date DATE,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

-- Таблица треков
CREATE TABLE tracks (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist_id INT NOT NULL,
    album_id INT,
    duration TIME,
    genre VARCHAR(100),
    text TEXT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE SET NULL
);

-- Таблица транскрибаций
CREATE TABLE transcriptions (
    transcription_id SERIAL PRIMARY KEY,
    track_id INT NOT NULL,
    user_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (track_id) REFERENCES tracks(track_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ============================
-- 2. Внесение данных
-- ============================

-- Очистка данных в таблицах
-- TRUNCATE TABLE transcriptions RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE tracks RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE albums RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE artists RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE users RESTART IDENTITY CASCADE;

-- Вставка данных в таблицу исполнителей
INSERT INTO artists (artist_name, bio_artist) VALUES
('Artist One', 'A talented musician known for vibrant performances.'),
('Artist Two', 'Famous for intricate compositions in multiple genres.'),
('Artist Three', 'An emerging artist redefining contemporary music.');

-- Вставка данных в таблицу альбомов
INSERT INTO albums (title_album, artist_id, release_date) VALUES
('First Album', 1, '2023-01-01'),
('Second Album', 2, '2023-05-15'),
('Third Album', 3, '2024-02-20');

-- Вставка данных в таблицу треков
INSERT INTO tracks (title, artist_id, album_id, duration, genre, text) VALUES
('Track One', 1, 1, '00:03:45', 'Pop', 'Lyrics of Track One'),
('Track Two', 2, 2, '00:04:20', 'Rock', 'Lyrics of Track Two'),
('Track Three', 3, 3, '00:05:00', 'Electronic', 'Lyrics of Track Three');

-- Вставка данных в таблицу пользователей
INSERT INTO users (username, email) VALUES
('UserOne', 'userone@example.com'),
('UserTwo', 'usertwo@example.com'),
('UserThree', 'userthree@example.com');

-- Вставка данных в таблицу транскрибаций
INSERT INTO transcriptions (track_id, user_id, type, description) VALUES
(1, 1, 'Chords', 'Am Bm F Dm'),
(1, 1,'Notes', '4/4 Emin |: D2| dAFD FDAD'),
(2, 2, 'Notes', '4/4 Emin |: D2| FDAD dAFD'),
(2, 2, 'Chords', 'Error'),
(3, 3, 'Chords', 'Am F C Dm'),
(3, 3, 'Notes', 'Error');

-- ============================
-- 3. Запрос данных
-- ============================

-- Запрос для получения информации о транскрибаций, запрошенных пользователями
SELECT 
    u.username AS user_name,
    t.title AS track_title,
    a.artist_name AS artist_name,
    al.title_album AS album_title,
    tr.type AS transcription_type,
    tr.description AS transcription_description
FROM 
    transcriptions tr
JOIN 
    tracks t ON tr.track_id = t.track_id
JOIN 
    artists a ON t.artist_id = a.artist_id
JOIN 
    albums al ON t.album_id = al.album_id
JOIN 
    users u ON tr.user_id = u.user_id
ORDER BY 
    u.username;



-- Пользователь выбирает трек с ID = 1 и запрашивает тип транскрибации "Chords".
SELECT 
    u.username AS user_name,
    t.title AS track_title,
    a.artist_name AS artist_name,
    al.title_album AS album_title,
    tr.type AS transcription_type,
    tr.description AS transcription_description
FROM 
    transcriptions tr
JOIN 
    tracks t ON tr.track_id = t.track_id
JOIN 
    artists a ON t.artist_id = a.artist_id
JOIN 
    albums al ON t.album_id = al.album_id
JOIN 
    users u ON tr.user_id = u.user_id
WHERE 
    t.track_id = 1  -- Запрашиваемый трек
    AND tr.type = 'Chords'  -- Запрашиваемый тип транскрибации
ORDER BY 
    u.username
LIMIT 1;  

-- Пользователь выбирает трек с ID = 1 и запрашивает тип транскрибации "Notes".

SELECT 
    u.username AS user_name,
    t.title AS track_title,
    a.artist_name AS artist_name,
    al.title_album AS album_title,
    tr.type AS transcription_type,
    tr.description AS transcription_description
FROM 
    transcriptions tr
JOIN 
    tracks t ON tr.track_id = t.track_id
JOIN 
    artists a ON t.artist_id = a.artist_id
JOIN 
    albums al ON t.album_id = al.album_id
JOIN 
    users u ON tr.user_id = u.user_id
WHERE 
    t.track_id = 1   -- Запрашиваемый трек
    AND tr.type = 'Notes'-- Запрашиваемый тип транскрибации
ORDER BY 
    u.username
LIMIT 1;
