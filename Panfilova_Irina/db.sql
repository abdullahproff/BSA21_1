-- Создание таблицы Users

CREATE TABLE Users (

    user_id INT PRIMARY KEY,
    name_lastname VARCHAR,
    e_mail VARCHAR NOT NULL UNIQUE,
    gender VARCHAR CHECK (gender IN ('Male', 'Female')),
    tag_id INT,
    note_id INT
);

-- Создание таблицы Notes
CREATE TABLE Notes (
    note_id INT PRIMARY KEY,
    date DATE NOT NULL,
    first_line VARCHAR,
    tag_id INT,
    user_id INT,
    content TEXT not NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)  -- Установка внешнего ключа на user_id
);

-- Создание таблицы Tags
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR not NULL,
    color VARCHAR CHECK (color IN ('red', 'green', 'blue', 'yellow', 'orange')) not NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)  -- Установка внешнего ключа на user_id
);


ALTER TABLE Notes
ADD CONSTRAINT fk_tag_notes FOREIGN KEY (tag_id) REFERENCES Tags(tag_id);


INSERT INTO Users (user_id, name_lastname, e_mail, gender) VALUES
(1, 'Alise Smirnova','alice@example.com', 'Female'),
(2, 'Alex Ivanov', 'alex@example.com', 'Male'),
(3, 'Edem Tef', 'edem@example.com', 'Male'),
(4, 'Diana Amirova','diana@example.com', 'Female');


INSERT INTO Tags (tag_id, color, user_id, tag_name) VALUES
('1', 'blue', 1, 'work'),  
('2', 'red', 1, 'art'),  
('3', 'yellow', 2, 'study'),  
('4', 'blue', 3, 'work'),
('5', 'blue', 4, 'work');


INSERT INTO Notes (note_id, date, first_line, tag_id, user_id, content) VALUES
(1, '2024-01-01','позвонить Виктории', '1', 1, 'позвонить Виктории, передать Грише, что он завтра работает'),
(2, '2024-01-02','Уж убран с поля','2', 1, 'Уж убран с поля начисто турнепс и вывезены свекла и капуста.'),
(3, '2024-01-03', 'phone','3', 3, '89169173345 - Kostya'),
(4, '2024-01-04', 'song','4', 4, 'Some song for Christmas and solo for Holiday'),
(5, '2024-01-04', 'СРОЧНО','5', 4, 'Необходимо переделать');


-- выбор тега
select * from tags 
where color = 'red';

-- поиск заметок по цвету тега
select content from notes 
join tags on tags.tag_id = notes.tag_id
where tags.color = 'red';

-- поиск заметок по названию тега
select content from notes 
join tags on tags.tag_id = notes.tag_id
where tags.tag_name = 'work';

-- добавление тега

INSERT INTO Tags (tag_id, tag_name, color, user_id) 
VALUES ('6', 'personal', 'green', 2);

select * from tags
