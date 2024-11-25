-- Создание таблицы users
CREATE TABLE test.users (
    user_id SERIAL PRIMARY KEY,            -- Уникальный идентификатор пользователя
    username VARCHAR(50) NOT NULL,         -- Никнейм пользователя
    full_name VARCHAR(150) NOT NULL,       -- Полное имя (ФИО)
    created_at TIMESTAMP DEFAULT now(),    -- Дата и время создания профиля
    description TEXT                       -- Краткая информация о профиле
);

-- Создание таблицы reels
CREATE TABLE test.reels (
    reels_id SERIAL PRIMARY KEY,           -- Уникальный идентификатор рилса
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    duration INTEGER,                      -- Продолжительность (в секундах)
    datetime TIMESTAMP DEFAULT now(),      -- Дата и время публикации
    views_count INTEGER DEFAULT 0,         -- Количество просмотров
    thumbnail_url TEXT,                    -- Ссылка на превью
    format VARCHAR(10),                    -- Формат видео (например, MP4, MKV)
    CONSTRAINT fk_reels_user FOREIGN KEY (user_id) REFERENCES test.users(user_id) ON DELETE CASCADE
);

-- Создание таблицы posts
CREATE TABLE test.posts (
    post_id SERIAL PRIMARY KEY,            -- Уникальный идентификатор поста
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    datetime TIMESTAMP DEFAULT now(),      -- Дата и время публикации
    image_url TEXT,                        -- Ссылка на картинку
    video_url TEXT,                        -- Ссылка на видео
    views_count INTEGER DEFAULT 0,         -- Количество просмотров
    CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES test.users(user_id) ON DELETE CASCADE
);

-- Создание таблицы content
CREATE TABLE test.content (
    content_id SERIAL PRIMARY KEY,         -- Уникальный идентификатор контента
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    post_id INTEGER,                       -- ID поста (Foreign Key)
    reels_id INTEGER,                      -- ID рилса (Foreign Key)
    CONSTRAINT fk_content_user FOREIGN KEY (user_id) REFERENCES test.users(user_id),
    CONSTRAINT fk_content_post FOREIGN KEY (post_id) REFERENCES test.posts(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_content_reels FOREIGN KEY (reels_id) REFERENCES test.reels(reels_id) ON DELETE CASCADE
);

-- Создание таблицы view_history
CREATE TABLE test.view_history (
    history_id SERIAL PRIMARY KEY,              -- Уникальный идентификатор записи
    user_id INTEGER NOT NULL,                   -- ID пользователя (FK на таблицу users)
    post_id INTEGER,                            -- ID поста (FK на таблицу posts)
    reels_id INTEGER,                           -- ID рилса (FK на таблицу reels)
    datetime_reels TIMESTAMP,                   -- Дата и время публикации рилса
    datetime_posts TIMESTAMP,                   -- Дата и время публикации поста
    user_post_datetime TIMESTAMP,               -- Дата и время просмотра поста
    user_reels_datetime TIMESTAMP,              -- Дата и время просмотра рилса
    duration_watched_reels INTEGER,             -- Длительность просмотра рилса
    watch_count_post INTEGER DEFAULT 0,         -- Счётчик просмотров поста
    watch_count_reels INTEGER DEFAULT 0,        -- Счётчик просмотров рилса
    CONSTRAINT fk_view_user FOREIGN KEY (user_id) REFERENCES test.users(user_id),
    CONSTRAINT fk_view_post FOREIGN KEY (post_id) REFERENCES test.posts(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_view_reels FOREIGN KEY (reels_id) REFERENCES test.reels(reels_id) ON DELETE CASCADE
);

-- Заполнение таблицы users
INSERT INTO test.users (username, full_name, created_at, description)
VALUES
('userlog', 'User Logout', now(), 'Test user account'),
('fedann', 'Fedorova Anna', now(), 'Administrator account'),
('marurant', 'Maria Urant', now(), 'General user'),
('ilya_style2007', 'Ilya Smolensky', now(), 'Moderator'),
('alkasenter', 'Alex Grechko', now(), 'New user with basic privileges');

COMMIT;

-- Заполнение таблицы posts
INSERT INTO test.posts (user_id, datetime, image_url, video_url, views_count)
VALUES
(1, now(), 'https://example.com/image1.jpg', 'https://example.com/video1.mp4', 100),
(2, now(), 'https://example.com/image2.jpg', NULL, 200),
(3, now(), NULL, 'https://example.com/video2.mp4', 150);

-- Заполнение таблицы reels
INSERT INTO test.reels (user_id, duration, datetime, views_count, thumbnail_url, format)
VALUES
(1, 120, now(), 300, 'https://example.com/thumbnail1.jpg', 'MP4'),
(2, 90, now(), 500, 'https://example.com/thumbnail2.jpg', 'MKV'),
(3, 60, now(), 200, 'https://example.com/thumbnail3.jpg', 'MP4');

-- Заполнение таблицы content
INSERT INTO test.content (user_id, post_id, reels_id)
VALUES
(1, 1, NULL),  -- Связан с постом
(2, 2, NULL),  -- Связан с постом
(3, NULL, 1),  -- Связан с рилсом
(1, NULL, 2);  -- Связан с рилсом

-- Заполнение таблицы view_history
INSERT INTO test.view_history (
   user_id, post_id, reels_id, datetime_reels, datetime_posts,
   user_post_datetime, user_reels_datetime, duration_watched_reels, watch_count_post, watch_count_reels
)
VALUES
(1, 1, NULL, NULL, now(), now(), NULL, NULL, 10, NULL),  -- Просмотр поста
(2, NULL, 1, now(), NULL, NULL, now(), 60, NULL, 20),   -- Просмотр рилса
(3, 2, NULL, NULL, now(), now(), NULL, NULL, 5, NULL),  -- Просмотр поста
(1, NULL, 2, now(), NULL, NULL, now(), 45, NULL, 15);   -- Просмотр рилса



-- Проверка данных
SELECT * FROM test.users;
SELECT * FROM test.posts;
SELECT * FROM test.reels;
SELECT * FROM test.content;
SELECT * FROM test.view_history;
