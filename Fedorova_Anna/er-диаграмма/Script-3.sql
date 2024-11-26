-- Создание таблицы users
CREATE TABLE newtest.users (
    user_id SERIAL PRIMARY KEY,            
    username VARCHAR(50) NOT NULL UNIQUE,  -- Уникальный никнейм
    full_name VARCHAR(150) NOT NULL,       
    created_at TIMESTAMP DEFAULT now(),    
    description TEXT                       
);

-- Создание таблицы reels
CREATE TABLE newtest.reels (
    reels_id SERIAL PRIMARY KEY,           
    user_id INTEGER NOT NULL,              
    duration INTEGER,                      
    datetime TIMESTAMP DEFAULT now(),      
    views_count INTEGER DEFAULT 0,         
    thumbnail_url TEXT,                    
    -- удален формат видео
    content_type VARCHAR(50) DEFAULT 'reels',
    CONSTRAINT fk_reels_user FOREIGN KEY (user_id) REFERENCES newtest.users(user_id) ON DELETE CASCADE
);

-- Создание таблицы posts
CREATE TABLE newtest.posts (
    post_id SERIAL PRIMARY KEY,            
    user_id INTEGER NOT NULL,              
    datetime TIMESTAMP DEFAULT now(),      
    image_url TEXT,                        
    video_url TEXT,                        
    views_count INTEGER DEFAULT 0,         
    content_type VARCHAR(50) DEFAULT 'post', -- Добавлен тип контента
    CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES newtest.users(user_id) ON DELETE CASCADE
);

-- Создание таблицы view_history
CREATE TABLE newtest.view_history (
    history_id SERIAL PRIMARY KEY,              
    user_id INTEGER NOT NULL,                   
    post_id INTEGER,                            
    reels_id INTEGER,                           
    view_datetime TIMESTAMP DEFAULT now(),      -- Объединено в одно поле
    duration_watched INTEGER,                   -- Длительность просмотра
    watch_count INTEGER DEFAULT 0,              -- Счётчик просмотров
    CONSTRAINT fk_view_user FOREIGN KEY (user_id) REFERENCES newtest.users(user_id),
    CONSTRAINT fk_view_post FOREIGN KEY (post_id) REFERENCES newtest.posts(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_view_reels FOREIGN KEY (reels_id) REFERENCES newtest.reels(reels_id) ON DELETE CASCADE,
    CONSTRAINT chk_post_or_reels CHECK (post_id IS NULL OR reels_id IS NULL) -- Проверка на коллизию
);


-- Заполнение таблицы users
INSERT INTO newtest.users (username, full_name, created_at, description)
VALUES
('userlog', 'User Logout', now(), 'Test user account'),
('fedann', 'Fedorova Anna', now(), 'Administrator account'),
('marurant', 'Maria Urant', now(), 'General user'),
('ilya_style2007', 'Ilya Smolensky', now(), 'Moderator'),
('alkasenter', 'Alex Grechko', now(), 'New user with basic privileges');
-- Заполнение таблицы posts
INSERT INTO newtest.posts (user_id, datetime, image_url, video_url, views_count)
VALUES
(1, now(), 'https://example.com/image1.jpg', 'https://example.com/video1.mp4', 100),
(2, now(), 'https://example.com/image2.jpg', NULL, 200),
(3, now(), NULL, 'https://example.com/video2.mp4', 150);

-- Заполнение таблицы reels
INSERT INTO newtest.reels (user_id, duration, datetime, views_count, thumbnail_url, content_type)
VALUES
(1, 120, now(), 300, 'https://example.com/thumbnail1.jpg', 'reels'),
(2, 90, now(), 500, 'https://example.com/thumbnail2.jpg', 'reels'),
(3, 60, now(), 200, 'https://example.com/thumbnail3.jpg', 'reels');

-- Заполнение таблицы view_history
INSERT INTO newtest.view_history (user_id, post_id, reels_id, view_datetime, duration_watched, watch_count)
VALUES
(1, 1, NULL, now(), NULL, 10),  -- Просмотр поста
(2, NULL, 1, now(), 60, 20),    -- Просмотр рилса
(3, 2, NULL, now(), NULL, 5),   -- Просмотр поста
(1, NULL, 2, now(), 45, 15);    -- Просмотр рилса




-- Проверка данных
SELECT * FROM newtest.users;
SELECT * FROM newtest.posts;
SELECT * FROM newtest.reels;
SELECT * FROM newtest.view_history;

-- Добавление нового пользователя
INSERT INTO newtest.users (username, full_name, created_at, description)
VALUES
('your_comrade', 'Ulyana Matveeva', now(), 'New user for testing');


-- Заполнение таблицы reels
INSERT INTO newtest.reels (user_id, duration, datetime, views_count, thumbnail_url, content_type)
VALUES
(8, 500, now(), 700, 'https://example.com/thumbnail1.jpg', 'reels');

-- Заполнение таблицы view_history
INSERT INTO newtest.view_history (user_id, post_id, reels_id, view_datetime, duration_watched, watch_count)
VALUES
(8, NULL, 2, now(), 45, 1000);  -- Просмотр рилса




SELECT 
    u.username,
    u.full_name,
    COUNT(r.reels_id) AS total_reels,                    -- Общее количество рилсов
    SUM(r.views_count) AS total_views,                  -- Общее количество просмотров
    MAX(r.datetime) AS last_published_reels            -- Дата последнего рилса
FROM 
    newtest.users u
JOIN 
    newtest.reels r ON u.user_id = r.user_id           -- Соединение таблицы users и reels
WHERE 
    r.views_count > 200                                -- Только рилсы с более чем 200 просмотров
GROUP BY 
    u.username, u.full_name                            -- Группировка по пользователю
ORDER BY 
    total_views DESC;                                  -- Сортировка по общему количеству просмотров


--SELECT * 
--FROM newtest.reels r
--JOIN newtest.users u ON r.user_id = u.user_id;

