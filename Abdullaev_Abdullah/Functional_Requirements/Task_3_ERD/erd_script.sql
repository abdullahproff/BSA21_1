CREATE DATABASE DuoLingo;

CREATE TABLE Пользователь (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    user_progress VARCHAR(255)
);

CREATE TABLE Язык (
    id SERIAL PRIMARY KEY,
    language VARCHAR(255) NOT NULL,
    user_id INT NOT NULL REFERENCES Пользователь(id)
);

CREATE TABLE Урок (
    id SERIAL PRIMARY KEY,
    lesson VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    lesson_status VARCHAR(50) CHECK (lesson_status IN ('в процессе', 'завершен')) DEFAULT 'в процессе',
    user_id INT NOT NULL REFERENCES Пользователь(id), -- Добавляем связь с Пользователь
    language_id INT NOT NULL REFERENCES Язык(id)
);

CREATE TABLE Диалог (
    id SERIAL PRIMARY KEY,
    initialization_time TIMESTAMP NOT NULL,
    message_type VARCHAR(50) CHECK (message_type IN ('клиент', 'система')) NOT NULL,
    lesson_id INT NOT NULL REFERENCES Урок(id)
);

CREATE TABLE Аудиосообщение (
    id SERIAL PRIMARY KEY,
    message_author VARCHAR(50) CHECK (message_author IN ('система', 'автор')) NOT NULL,
    message_file VARCHAR(255),
    message_time TIMESTAMP,
    message_duration INT,
    dialog_id INT NOT NULL REFERENCES Диалог(id)
);

CREATE TABLE Прогресс_урока (
    id SERIAL PRIMARY KEY,
    result VARCHAR(50) CHECK (result IN ('успешно', 'неудачно')) NOT NULL,
    xp INT NOT NULL,
    user_id INT NOT NULL REFERENCES Пользователь(id), -- Добавляем связь с Пользователь
    lesson_id INT NOT NULL REFERENCES Урок(id)
);
