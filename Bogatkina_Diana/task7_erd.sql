DROP TABLE IF EXISTS users, locations, lists, favourites CASCADE;

CREATE TABLE users (
 user_id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 username VARCHAR(30) NOT NULL,
 email VARCHAR(100)
);

CREATE TABLE lists (
 list_id SERIAL PRIMARY KEY,
 category_name VARCHAR(20) NOT NULL,
 locations_number INT,
 user_id INT,
 FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE locations (
 location_id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 description VARCHAR(100),
 create_date TIMESTAMP WITH TIME ZONE,
 list_id INT,
 FOREIGN KEY (list_id) REFERENCES lists(list_id) ON DELETE CASCADE
);

CREATE TABLE favourites (
 user_id INT,
 list_id INT,
 location_id INT,
 PRIMARY KEY (user_id, list_id, location_id),
 FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
 FOREIGN KEY (list_id) REFERENCES lists(list_id) ON DELETE CASCADE,
 FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

INSERT INTO users (name, username, email)
VALUES
('Алексей', 'alex', 'alex@example.com'),
('Мария', 'masha', 'masha@example.com');

INSERT INTO locations (name, description, create_date)
VALUES
('Павлин Пицца', 'Лучшая пицца на вынос', '2023-10-01'),
('Мармеладница', 'За десертом - к нам', '2024-01-20'),
('Диски', 'Магазин у дома', '2010-06-30');

INSERT INTO lists (category_name) 
VALUES
    ('кафе'),
    ('магазины');
 
INSERT INTO favourites (user_id, list_id, location_id) VALUES 
    (1, 1, 1),
    (1, 1, 2), 
    (2, 2, 3);

-- Проверка пользователей и их избранных мест
SELECT u.name AS user_name, l.category_name, loc.name AS location_name, loc.description
FROM favourites f
JOIN users u ON f.user_id = u.user_id
JOIN lists l ON f.list_id = l.list_id
JOIN locations loc ON f.location_id = loc.location_id;

-- Проверка всех пользователей и сколько локаций они добавили в избранное
SELECT u.name AS user_name, COUNT(f.location_id) AS favourite_count
FROM users u
LEFT JOIN favourites f ON u.user_id = f.user_id
GROUP BY u.user_id;

-- Подсчитать количество локаций в таблице lists и обновить соответствующую запись в таблице
UPDATE lists l
SET locations_number = subquery.locations_number
FROM (
    SELECT f.list_id, COUNT(f.location_id) AS locations_number
    FROM favourites f
    GROUP BY f.list_id
) AS subquery
WHERE l.list_id = subquery.list_id;

SELECT * FROM lists;
