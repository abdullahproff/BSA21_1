-- Просмотр пользователей
SELECT * FROM users;

-- Просмотр всех треков с указанием их альбомов
SELECT 
    tracks.id AS track_id, 
    tracks.title AS track_title, 
    albums.title AS album_title, 
    tracks.duration 
FROM 
    tracks
JOIN 
    albums ON tracks.album_id = albums.id;

-- Список всех артистов с их жанрами
SELECT 
    id AS artist_id, 
    name AS artist_name, 
    genre 
FROM 
    artists;

-- Список альбомов с артистами, выпустившими эти альбомы
SELECT 
    albums.id AS album_id, 
    albums.title AS album_title, 
    artists.name AS artist_name, 
    albums.release_date 
FROM 
    albums
JOIN 
    artists ON albums.artist_id = artists.id;
