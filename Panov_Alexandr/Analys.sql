


CREATE TABLE Users (
    name VARCHAR(255) PRIMARY KEY,
    groups TEXT,  -- Список групп, хранится в формате текста
    is_premium BOOLEAN,
    email VARCHAR(255),
    phone VARCHAR(20)
);

CREATE TABLE Groups (
    group_name VARCHAR(255) PRIMARY KEY,
    group_users TEXT, -- Список пользователей, хранится в формате текста
    super_users TEXT, -- Список админов, хранится в формате текста
    group_description TEXT,
    group_invited TEXT, -- Список приглашенных пользователей, хранится в формате текста
    group_blocked TEXT  -- Список заблокированных пользователей, хранится в формате текста
);


INSERT INTO Users (name, groups, is_premium, email, phone)
VALUES 
    ('Alice45', 'group1;group2;group3', TRUE, 'alice@example.com', '123-456-7890'),
    ('Bob54', 'group1;group4', FALSE, 'bob@example.com', '123-456-7891'),
    ('Charlie44', 'group2;group5', TRUE, 'charlie@example.com', '123-456-7892');

INSERT INTO Groups (group_name, group_users, super_users, group_description, group_invited, group_blocked)
VALUES ('group1', 'Alice45;Bob54;Charlie44', 'Alice45', 'Description of group 1', 'Bob54', 'Charlie44');
