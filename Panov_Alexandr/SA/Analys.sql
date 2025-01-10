

-- Таблица Users
CREATE TABLE Users (
    name VARCHAR(255) PRIMARY KEY,  -- Имя пользователя (ключ)
    is_premium BOOLEAN,               -- Поле для премиум-статуса
    email VARCHAR(255),               -- Поле для email
    phone VARCHAR(20)                 -- Поле для телефона
);

-- Таблица Groups
CREATE TABLE Groups (
    group_name VARCHAR(255) PRIMARY KEY,  -- Имя группы (ключ)
    group_description TEXT,                -- Описание группы
    group_settings TEXT                    -- Настройки группы
);

-- Таблица Relations
CREATE TABLE Relations (
    relation_id SERIAL PRIMARY KEY,        -- Уникальный идентификатор для отношения (ключ)
    user_name VARCHAR(255) REFERENCES Users(name) ON DELETE CASCADE,  -- Внешний ключ на имя пользователя
    group_name VARCHAR(255) REFERENCES Groups(group_name) ON DELETE CASCADE,  -- Внешний ключ на имя группы
    relation_type TEXT   -- Тип отношения
);

-- Вставка пользователей
INSERT INTO Users (name, is_premium, email, phone)
VALUES 
    ('Alice45', TRUE, 'alice@example.com', '123-456-7890'),
    ('Bob45', FALSE, 'bob@example.com', '123-456-7891'),
    ('Charlie44', TRUE, 'charlie@example.com', '123-456-7892');

-- Вставка групп
INSERT INTO Groups (group_name, group_description, group_settings)
VALUES 
    ('Group A', 'Description of Group A', 'Settings A'),
    ('Group B', 'Description of Group B', 'Settings B');

-- Вставка отношений
INSERT INTO Relations (user_name, group_name, relation_type)
VALUES 
    ('Alice45', 'Group A', 'admin'),
    ('Bob45', 'Group A', 'member'),
    ('Charlie44', 'Group B', 'admin'),
    ('Bob45', 'Group B', 'blocked'); 
