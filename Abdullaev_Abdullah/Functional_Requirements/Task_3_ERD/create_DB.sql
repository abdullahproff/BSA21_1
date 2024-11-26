DROP DATABASE IF EXISTS MyDuoLingoTestBase;
CREATE DATABASE MyDuoLingoTestBase;

--DROP TABLE IF EXISTS lesson_progress;
--DROP TABLE IF EXISTS audio_messages;
--DROP TABLE IF EXISTS dialogs;
--DROP TABLE IF EXISTS lessons;
--DROP TABLE IF EXISTS languages;
--DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS LessonProgress;
DROP TABLE IF EXISTS AudioMessages;
DROP TABLE IF EXISTS Dialogs;
DROP TABLE IF EXISTS Lessons;
DROP TABLE IF EXISTS Languages;
DROP TABLE IF EXISTS Users;

CREATE TABLE users (
    user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    progress TEXT
);

CREATE TABLE languages (
    language_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    language_name VARCHAR(255) NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id)
);

CREATE TABLE lessons (
    lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_name VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    status VARCHAR(50) CHECK (status IN ('in progress', 'completed')) DEFAULT 'in progress',
    user_id INT NOT NULL REFERENCES users(user_id),
    language_id INT NOT NULL REFERENCES languages(language_id)
);

CREATE TABLE dialogs (
    dialog_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    initialization_time TIMESTAMPTZ NOT NULL,
    message_type VARCHAR(50) CHECK (message_type IN ('client', 'system')) NOT NULL,
    lesson_id INT NOT NULL REFERENCES lessons(lesson_id)
);

CREATE TABLE audio_messages (
    audio_message_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author VARCHAR(50) CHECK (author IN ('system', 'author')) NOT NULL,
    file_path VARCHAR(255),
    message_time TIMESTAMPTZ,
    duration_seconds INT,
    dialog_id INT NOT NULL REFERENCES dialogs(dialog_id)
);

CREATE TABLE lesson_progress (
    progress_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    result VARCHAR(50) CHECK (result IN ('success', 'failure')) NOT NULL,
    xp INT NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id),
    lesson_id INT NOT NULL REFERENCES lessons(lesson_id)
);
