
CREATE TABLE Users (
    name VARCHAR(255) PRIMARY KEY,
    groups JSONB,  -- Массив имен групп, хранится в формате JSONB
    is_premium BOOLEAN,
    email VARCHAR(255),
    phone VARCHAR(20)
);

CREATE TABLE Groups (
    group_name VARCHAR(255) PRIMARY KEY,
    group_users JSONB, -- Массив имен пользователей
    super_users JSONB, -- Массив имен админов
    group_description TEXT,
    group_invited JSONB, -- Массив приглашенных пользователей
    group_blocked JSONB  -- Массив заблокированных пользователей
);


INSERT INTO Users (name, groups, is_premium, email, phone) VALUES 
('Alice676', '["Group1", "Group2"]', true, 'alice@example.com', '123456789'),
('Bob44', '["Group1"]', false, 'bob@example.com', '987654321'),
('Charlie55', '[]', true, 'charlie@example.com', '555555555');

INSERT INTO Groups (group_name, group_users, super_users, group_description, group_invited, group_blocked) VALUES 
('Group1', '["Alice676", "Bob44"]', '["Alice676"]', 'Description of Group 1', '[]', '[]'),
('Group2', '["Alice676"]', '["Alice676"]', 'Description of Group 2', '["Bob44"]', '[]');



--Вывод списка групп первого пользователя
SELECT groups::text AS user_groups FROM Users WHERE name = 'Alice676';

--Вывод списка админов одной группы
SELECT super_users::text AS group_admins FROM Groups WHERE group_name = 'Group1';

