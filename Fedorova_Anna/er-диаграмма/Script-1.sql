INSERT INTO myfirstschema.posts (user_id, datetime, image_url, video_url, views_count)
VALUES
(1, now(), 'https://example.com/image1.jpg', 'https://example.com/video1.mp4', 100),
(2, now(), 'https://example.com/image2.jpg', NULL, 200),
(3, now(), NULL, 'https://example.com/video2.mp4', 150);


INSERT INTO myfirstschema.reels (user_id, duration, datetime, views_count, thumbnail_url, format)
VALUES
(1, 120, now(), 300, 'https://example.com/thumbnail1.jpg', 'MP4'),
(2, 90, now(), 500, 'https://example.com/thumbnail2.jpg', 'MKV'),
(3, 60, now(), 200, 'https://example.com/thumbnail3.jpg', 'MP4');

INSERT INTO myfirstschema.content (user_id, post_id, reels_id)
VALUES
(1, 1, NULL),  -- Связан с постом
(2, 2, NULL),  -- Связан с постом
(3, NULL, 1),  -- Связан с рилсом
(1, NULL, 2);  -- Связан с рилсом


INSERT INTO myfirstschema.view_history (
   user_id, post_id, reels_id, datetime_reels, datetime_posts,
   user_post_datetime, user_reels_datetime, duration_watched_reels, watch_count_post, watch_count_reels
)
VALUES
(1, 1, NULL, NULL, now(), now(), NULL, NULL, 10, NULL),  -- Просмотр поста
(2, NULL, 1, now(), NULL, NULL, now(), 60, NULL, 20),   -- Просмотр рилса
(3, 2, NULL, NULL, now(), now(), NULL, NULL, 5, NULL),  -- Просмотр поста
(1, NULL, 2, now(), NULL, NULL, now(), 45, NULL, 15);   -- Просмотр рилса


SELECT * FROM myfirstschema.users;
SELECT * FROM myfirstschema.posts;
SELECT * FROM myfirstschema.reels;
SELECT * FROM myfirstschema.content;
SELECT * FROM myfirstschema.view_history;
