DROP DATABASE IF EXISTS MyDuoLingoTestBase;
CREATE DATABASE MyDuoLingoTestBase;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'public') THEN
        CREATE SCHEMA public;
    END IF;
END $$;

CREATE TABLE public.users (
    user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    progress TEXT
);

CREATE TABLE public.languages (
    language_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    language_name VARCHAR(255) NOT NULL
);

CREATE TABLE public.user_languages (
    user_language_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    language_id INT NOT NULL REFERENCES public.languages(language_id) ON DELETE CASCADE
);

CREATE TABLE public.lessons (
    lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lesson_name VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    status VARCHAR(50) CHECK (status IN ('in progress', 'completed')) DEFAULT 'in progress',
    language_id INT NOT NULL REFERENCES public.languages(language_id),
    ai_initial_message TEXT -- Поле для инициализирующего сообщения от системы
);

CREATE TABLE public.lesson_progress (
    progress_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    lesson_id INT NOT NULL REFERENCES public.lessons(lesson_id) ON DELETE CASCADE,
    result VARCHAR(50) CHECK (result IN ('success', 'failure')) NOT NULL,
    xp INT NOT NULL,
    completion_date TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.dialogs (
    dialog_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
    lesson_id INT NOT NULL REFERENCES public.lessons(lesson_id) ON DELETE CASCADE,
    initialization_time TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.audio_messages (
    audio_message_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author VARCHAR(50) CHECK (author IN ('system', 'author')) NOT NULL,
    file_path VARCHAR(255),
    message_time TIMESTAMPTZ DEFAULT NOW(),
    duration_seconds INT,
    dialog_id INT NOT NULL REFERENCES public.dialogs(dialog_id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION insert_initial_ai_message()
RETURNS TRIGGER AS $$
DECLARE
    initial_message TEXT;
BEGIN
    -- Получаем инициализирующее сообщение из lessons
    SELECT ai_initial_message INTO initial_message
    FROM public.lessons
    WHERE lesson_id = NEW.lesson_id;

    -- Если сообщение существует, вставляем его в audio_messages
    IF initial_message IS NOT NULL THEN
        INSERT INTO public.audio_messages (author, file_path, duration_seconds, dialog_id)
        VALUES ('system', 'ai_initial_message.mp3', 5, NEW.dialog_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для вставки инициализирующего сообщения при создании диалога
CREATE TRIGGER after_dialog_insert
AFTER INSERT ON public.dialogs
FOR EACH ROW
EXECUTE FUNCTION insert_initial_ai_message();

-- Вставка данных
-- Создаем языки
INSERT INTO public.languages (language_name) VALUES 
('English'),
('Spanish'),
('French'),
('German');

-- Создаем пользователей
INSERT INTO public.users (username, progress) VALUES 
('JohnDoe', 'Intermediate'),
('JaneSmith', 'Beginner'),
('AlexBrown', 'Advanced');

-- Связь пользователей языков
INSERT INTO public.user_languages (user_id, language_id) VALUES 
(1, 1), -- JohnDoe -> English
(1, 2), -- JohnDoe -> Spanish
(2, 3), -- JaneSmith -> French
(3, 4), -- AlexBrown -> German
(3, 1); -- AlexBrown -> English

-- Создаем уроки
INSERT INTO public.lessons (lesson_name, topic, status, language_id, ai_initial_message) VALUES 
('Basics 1', 'Greetings', 'in progress', 1, 'Welcome to English! Let’s start with greetings.'),
('Basics 2', 'Numbers', 'in progress', 1, 'Now, let’s learn numbers.'),
('Conversational', 'Daily Life', 'in progress', 2, 'Let’s talk about daily routines in Spanish.'),
('Travel', 'Directions', 'in progress', 3, 'Learn how to ask for directions in French.');

-- Создаем прогресс уроков
INSERT INTO public.lesson_progress (user_id, lesson_id, result, xp) VALUES 
(1, 1, 'success', 50), -- JohnDoe завершил "Basics 1"
(2, 4, 'failure', 30), -- JaneSmith провалила "Travel"
(3, 2, 'success', 70); -- AlexBrown завершил "Basics 2"

-- Создаем диалоги
INSERT INTO public.dialogs (user_id, lesson_id) VALUES 
(1, 1), -- JohnDoe начинает диалог в "Basics 1"
(2, 4); -- JaneSmith начинает диалог в "Travel"

-- Проверочные SELECT-запросы
-- Все языки
SELECT * FROM public.languages;

-- Все пользователи
SELECT * FROM public.users;

-- Связь пользователей и языков
SELECT 
    u.username, 
    l.language_name 
FROM 
    public.user_languages ul
JOIN 
    public.users u ON ul.user_id = u.user_id
JOIN 
    public.languages l ON ul.language_id = l.language_id;

-- Уроки для языка English
SELECT 
    l.lesson_name, 
    l.topic, 
    lg.language_name 
FROM 
    public.lessons l
JOIN 
    public.languages lg ON l.language_id = lg.language_id
WHERE 
    lg.language_name = 'English';

-- Прогресс уроков
SELECT 
    u.username, 
    ls.lesson_name, 
    lp.result, 
    lp.xp, 
    lp.completion_date 
FROM 
    public.lesson_progress lp
JOIN 
    public.users u ON lp.user_id = u.user_id
JOIN 
    public.lessons ls ON lp.lesson_id = ls.lesson_id;

-- Инициализирующее сообщение от системы
SELECT 
    a.audio_message_id, 
    a.author, 
    a.file_path, 
    a.dialog_id, 
    d.initialization_time,
    l.lesson_name
FROM 
    public.audio_messages a
JOIN 
    public.dialogs d ON a.dialog_id = d.dialog_id
JOIN 
    public.lessons l ON d.lesson_id = l.lesson_id
WHERE 
    a.author = 'system';
