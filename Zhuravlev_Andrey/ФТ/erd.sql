CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    user_first_name VARCHAR(100),
    user_last_name VARCHAR(100),
    patronymic VARCHAR(100)
);
CREATE TYPE status_enum AS ENUM ('В сети', 'Отошел', 'Занят');
CREATE TABLE profiles(
    profile_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    birth_date DATE,
    status status_enum DEFAULT 'Отошел',
    CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE 
);
CREATE TABLE photos(
    photo_id SERIAL PRIMARY KEY,
    profile_id INT NOT NULL,
    name VARCHAR(100),
    size DECIMAL,
    pixels VARCHAR(100),
    format VARCHAR(100),
    route VARCHAR(100),
    date_of_creation TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_photos_profiles FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE
);
INSERT INTO users(user_first_name, user_last_name, patronymic ) 
VALUES
('Андрей', 'Журавлёв', 'Александрович'),
('Кристина', 'Тихонова', 'Владимировна'),
('Евгения', 'Никитенкова', 'Ивановна');
INSERT INTO profiles(user_id, birth_date, status) 
VALUES
(1, '1992-10-07', 'В сети'),
(2, '1995-03-30', 'Отошел'),
(3, '1994-06-15', 'Занят');
INSERT INTO photos(profile_id, name, size, pixels, format, route, date_of_creation) 
VALUES
(1, '123', 12, '1795x2551', 'PNG', 'C:/Documents/', '2024-11-14'),
(2, '456', 13, '1795x2551', 'PNG', 'C:/Documents/', '2024-11-14'),
(3, '789', 11, '1795x2551', 'SVG', 'C:/Documents/', '2024-11-14');
SELECT user_first_name AS Имя, user_last_name AS Фамилия, patronymic AS Отчество, birth_date AS Дата_рождения, status AS Статус, name AS Название_файла, size AS Размер_в_МБ, pixels AS Разрешение,format AS Формат_файла, route AS Расположение_файла, date_of_creation AS Дата_создания
FROM users
JOIN profiles ON users.user_id = profiles.user_id
JOIN photos ON profiles.profile_id = photos.profile_id

drop TABLE users,profiles, photos;
drop TYPE status_enum
