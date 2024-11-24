-- Создание таблицы пользователей
CREATE TABLE users (
    id INT PRIMARY KEY,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20)
);

-- Создание таблицы треков
CREATE TABLE tracs (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    album_id INT,
    duration TIME,
    FOREIGN KEY (album_id) REFERENCES albums(id)
);

-- Создание таблицы альбомов
CREATE TABLE albums (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    release_date DATE,
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);

-- Создание таблицы истории прослушиваний
CREATE TABLE histories_listening (
    id INT PRIMARY KEY,
    listening_date DATETIME,
    user_id INT,
    track_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (track_id) REFERENCES tracs(id)
);

-- Создание таблицы артистов
CREATE TABLE artists (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    genre VARCHAR(255)
);

-- Создание таблицы связи артистов и треков
CREATE TABLE artists_tracks (
    artist_id INT,
    track_id INT,
    PRIMARY KEY (artist_id, track_id),
    FOREIGN KEY (artist_id) REFERENCES artists(id),
    FOREIGN KEY (track_id) REFERENCES tracs(id)
);

-- Вставка данных в таблицу пользователей
INSERT INTO users (id, last_name, first_name, email, phone_number) VALUES
(1, 'Smith', 'John', 'john.smith@example.com', '1234567890'),
(2, 'Doe', 'Jane', 'jane.doe@example.com', '0987654321'),
(3, 'Иванов', 'Иван', 'ivan.ivanov@example.ru', '89991234567'),
(4, 'Петрова', 'Мария', 'maria.petrova@example.ru', '89997654321'),
(5, 'Taylor', 'James', 'james.taylor@example.com', '1234123412'),
(6, 'Brown', 'Emily', 'emily.brown@example.com', '3214321432');

-- Вставка данных в таблицу артистов
INSERT INTO artists (id, name, genre) VALUES
(1, 'The Beatles', 'Rock'),
(2, 'Adele', 'Pop'),
(3, 'Кино', 'Рок'),
(4, 'Земфира', 'Альтернативная поп-музыка'),
(5, 'The Rolling Stones', 'Rock'),
(6, 'Ariana Grande', 'Pop');

-- Вставка данных в таблицу альбомов
INSERT INTO albums (id, title, release_date, artist_id) VALUES
(1, 'Abbey Road', '1969-09-26', 1),
(2, '25', '2015-11-20', 2),
(3, 'Группа крови', '1988-06-01', 3),
(4, 'Жить в твоей голове', '2013-02-14', 4),
(5, 'Sticky Fingers', '1971-04-23', 5),
(6, 'Sweetener', '2018-08-17', 6);

-- Вставка данных в таблицу треков
INSERT INTO tracs (id, title, album_id, duration) VALUES
(1, 'Come Together', 1, '00:04:19'),
(2, 'Hello', 2, '00:04:55'),
(3, 'Группа крови', 3, '00:04:50'),
(4, 'Жить в твоей голове', 4, '00:05:03'),
(5, 'Brown Sugar', 5, '00:03:49'),
(6, 'No Tears Left to Cry', 6, '00:03:25');

-- Вставка данных в таблицу истории прослушиваний
INSERT INTO histories_listening (id, listening_date, user_id, track_id) VALUES
(1, '2024-11-24 10:00:00', 1, 1),
(2, '2024-11-24 11:00:00', 2, 2),
(3, '2024-11-24 12:00:00', 3, 3),
(4, '2024-11-24 13:00:00', 4, 4),
(5, '2024-11-24 14:00:00', 5, 5),
(6, '2024-11-24 15:00:00', 6, 6);

-- Вставка данных в таблицу связи артистов и треков
INSERT INTO artists_tracks (artist_id, track_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);
