INSERT INTO myfirstschema.users (username, full_name, created_at, description)
VALUES
('userlog', 'User Logout', now(), 'Test user account'),
('fedann', 'Fedorova Anna', now(), 'Administrator account'),
('marurant', 'Maria Urant', now(), 'General user'),
('ilya_style2007', 'Ilya Smolensky', now(), 'Moderator'),
('alkasenter', 'Alex Grechko', now(), 'New user with basic privileges');

ALTER TABLE myfirstschema.users
ADD CONSTRAINT pk_user_id PRIMARY KEY (user_id);


CREATE TABLE myfirstschema.reels (
    reels_id SERIAL PRIMARY KEY,           -- Уникальный идентификатор рилса
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    duration INTEGER,                      -- Продолжительность (в секундах)
    datetime TIMESTAMP DEFAULT now(),      -- Дата и время публикации
    views_count INTEGER DEFAULT 0,         -- Количество просмотров
    thumbnail_url TEXT,                    -- Ссылка на превью
    format VARCHAR(10),                    -- Формат видео (например, MP4, MKV)
    CONSTRAINT fk_reels_user FOREIGN KEY (user_id) REFERENCES myfirstschema.users(user_id)


CREATE TABLE myfirstschema.posts (
    post_id SERIAL PRIMARY KEY,            -- Уникальный идентификатор поста
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    datetime TIMESTAMP DEFAULT now(),      -- Дата и время публикации
    image_url TEXT,                        -- Ссылка на картинку
    video_url TEXT,                        -- Ссылка на видео
    views_count INTEGER DEFAULT 0,         -- Количество просмотров
    CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES myfirstschema.users(user_id)
);

CREATE TABLE myfirstschema.content (
    content_id SERIAL PRIMARY KEY,         -- Уникальный идентификатор контента
    user_id INTEGER NOT NULL,              -- ID пользователя (Foreign Key)
    post_id INTEGER,                       -- ID поста (Foreign Key)
    reels_id INTEGER,                      -- ID рилса (Foreign Key)
    CONSTRAINT fk_content_user FOREIGN KEY (user_id) REFERENCES myfirstschema.users(user_id),
    CONSTRAINT fk_content_post FOREIGN KEY (post_id) REFERENCES myfirstschema.posts(post_id),
    CONSTRAINT fk_content_reels FOREIGN KEY (reels_id) REFERENCES myfirstschema.reels(reels_id)
);

CREATE TABLE myfirstschema.view_history (
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
    CONSTRAINT fk_view_user FOREIGN KEY (user_id) REFERENCES myfirstschema.users(user_id),
    CONSTRAINT fk_view_post FOREIGN KEY (post_id) REFERENCES myfirstschema.posts(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_view_reels FOREIGN KEY (reels_id) REFERENCES myfirstschema.reels(reels_id) ON DELETE CASCADE
);

