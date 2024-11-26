-- Создание таблицы пользователей
CREATE TABLE users (
                       user_id SERIAL PRIMARY KEY NOT NULL,
                       username VARCHAR(50) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       user_password VARCHAR(100) NOT NULL,
                       interests TEXT[],
                       user_city VARCHAR(100),
                       user_street VARCHAR(100),
                       profile_picture TEXT,
                       age INT,
                       gender VARCHAR(10),
                       bio TEXT
);

-- Создание таблицы активностей
CREATE TABLE activities (
                            activity_id SERIAL PRIMARY KEY NOT NULL,
                            creator_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,  -- Внешний ключ на пользователя
                            activity_name VARCHAR(100) NOT NULL,
                            activity_date DATE NOT NULL,
                            activity_time TIME NOT NULL,
                            city VARCHAR(100),
                            street VARCHAR(100),
                            max_participants INT,
                            description TEXT
);

-- Создание таблицы участников
CREATE TABLE users_activities (
                                  activity_id INT REFERENCES activities(activity_id) ON DELETE CASCADE,  -- Внешний ключ на активность
                                  user_id INT REFERENCES users(user_id) ON DELETE CASCADE,              -- Внешний ключ на пользователя
                                  status VARCHAR(20)             -- Статус участия (confirmed, pending, declined)
);


-- Вставка пользователей
INSERT INTO users (username, email, user_password, interests, user_city, user_street, age, gender, bio)
VALUES
    ('john_doe', 'john@example.com', 'password123', ARRAY['велопрогулка', 'фильмы', 'настолки'], 'Москва', 'Арбат 1', 30, 'мужской', 'Я люблю активный отдых!'),
    ('jane_smith', 'jane@example.com', 'securepassword', ARRAY['походы', 'чтение'], 'Санкт-Петербург', 'Невский проспект 5', 28, 'женский', 'Люблю природу и книги.');

-- Вставка активностей
INSERT INTO activities (creator_id, activity_name, activity_date, activity_time, city, street, max_participants, description)
VALUES
(1, 'Велопрогулка в парке', '2024-07-01', '10:00:00', 'Москва', 'Северный парк', 10, 'Присоединяйтесь к увлекательной велопрогулке!'),
(2, 'Киносеанс "Звёздные войны"', '2024-07-02', '19:30:00', 'Санкт-Петербург', 'Кинотеатр "Мир"', 20, 'Посмотрим новый фильм вместе!');

-- Вставка участников
INSERT INTO users_activities (activity_id, user_id, status)
VALUES
    (1, 1, 'confirmed'),
    (1, 2, 'pending'),
    (2, 1, 'confirmed');

-- Выборка по участнику id = 1
SELECT a.*
FROM activities a
         JOIN users_activities ua ON a.activity_id = ua.activity_id
WHERE ua.user_id = 1;