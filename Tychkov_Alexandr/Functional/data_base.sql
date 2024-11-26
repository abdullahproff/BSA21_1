CREATE TABLE tracks (
	track_id int4 NOT NULL,
	song_title varchar NOT NULL,
	artist_name varchar NOT NULL,
	CONSTRAINT pk_tracks PRIMARY KEY (track_id)
);

CREATE TABLE users (
	user_id int4 NOT NULL,
	login varchar NOT NULL,
	email varchar NOT NULL,
	CONSTRAINT users_email_unique UNIQUE (email),
	CONSTRAINT users_login_unique UNIQUE (login),
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

CREATE TABLE playlists (
	playlist_id int4 NOT NULL,
	user_id int4 NOT NULL,
	playlist_title varchar NOT NULL,
	CONSTRAINT fk_playlists_users FOREIGN KEY (user_id) REFERENCES users(user_id),
	CONSTRAINT playlists_pkey PRIMARY KEY (playlist_id)
);

CREATE TABLE playlist_tracks (
	playlist_id int4 NOT NULL,
	track_id int4 NOT NULL,
	CONSTRAINT playlist_track_pk PRIMARY KEY (playlist_id, track_id),
	CONSTRAINT fk_playlist_playlist_tracks FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id),
	CONSTRAINT fk_playlist_track_tracks FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);


-- Вставка треков
INSERT INTO tracks (track_id, song_title, artist_name) VALUES
(1, 'Song 1', 'Artist A'),
(2, 'Song 2', 'Artist B'),
(3, 'Song 3', 'Artist C');

-- Вставка пользователей
INSERT INTO users (user_id, login, email) VALUES
(1, 'user1', 'user1@example.com'),
(2, 'user2', 'user2@example.com'),
(3, 'user3', 'user3@example.com');

-- Вставка плейлистов
INSERT INTO playlists (playlist_id, user_id, playlist_title) VALUES
(1, 1,'relax'),
(2, 2, 'aim'),
(3, 3, 'swim');

-- Вставка треков в плейлисты
INSERT INTO playlist_tracks (playlist_id, track_id) VALUES
(1, 1),  -- Плейлист 1 содержит трек 1
(1, 2),  -- Плейлист 1 также содержит трек 2
(2, 2),  -- Плейлист 2 содержит трек 2
(2, 3),  -- Плейлист 2 также содержит трек 3
(3, 1);  -- Плейлист 3 содержит трек 1


SELECT pl.playlist_title, t.song_title, t.artist_name
FROM playlist_tracks pt
JOIN playlists pl ON pt.playlist_id = pl.playlist_id
JOIN tracks t ON pt.track_id = t.track_id;
