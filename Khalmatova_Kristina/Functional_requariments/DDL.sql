-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;
-- public.albums определение

-- Drop table

-- DROP TABLE public.albums;

CREATE TABLE public.albums (
	album_id int4 NOT NULL,
	album_title varchar NOT NULL,
	cover varchar NULL,
	release_year int4 NULL,
	CONSTRAINT pk_albums PRIMARY KEY (album_id)
);


-- public.artists определение

-- Drop table

-- DROP TABLE public.artists;

CREATE TABLE public.artists (
	artist_id int4 NOT NULL,
	artist_name varchar NOT NULL,
	CONSTRAINT artists_pk PRIMARY KEY (artist_id),
	CONSTRAINT artists_unique UNIQUE (artist_name)
);


-- public.tracks определение

-- Drop table

-- DROP TABLE public.tracks;

CREATE TABLE public.tracks (
	track_id int4 NOT NULL,
	song_title varchar NOT NULL,
	duration time NULL,
	cover varchar NULL,
	CONSTRAINT pk_tracks PRIMARY KEY (track_id)
);


-- public.users определение

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	user_id int4 NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	email varchar NOT NULL,
	phone varchar NOT NULL,
	CONSTRAINT users_email_unique UNIQUE (email),
	CONSTRAINT users_phone_unique UNIQUE (phone),
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
);


-- public.album_track определение

-- Drop table

-- DROP TABLE public.album_track;

CREATE TABLE public.album_track (
	album_id int4 NOT NULL,
	track_id int4 NOT NULL,
	CONSTRAINT album_track_pk PRIMARY KEY (album_id, track_id),
	CONSTRAINT fk_album_track_albums FOREIGN KEY (album_id) REFERENCES public.albums(album_id),
	CONSTRAINT fk_album_track_tracks FOREIGN KEY (track_id) REFERENCES public.tracks(track_id)
);


-- public.artist_album определение

-- Drop table

-- DROP TABLE public.artist_album;

CREATE TABLE public.artist_album (
	artist_id int4 NOT NULL,
	album_id int4 NOT NULL,
	CONSTRAINT artist_album_pk PRIMARY KEY (artist_id, album_id),
	CONSTRAINT artist_album_albums_fk FOREIGN KEY (album_id) REFERENCES public.albums(album_id),
	CONSTRAINT artist_album_artists_fk FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id)
);


-- public.artist_track определение

-- Drop table

-- DROP TABLE public.artist_track;

CREATE TABLE public.artist_track (
	artist_id int4 NOT NULL,
	track_id int4 NOT NULL,
	CONSTRAINT artist_track_pk PRIMARY KEY (artist_id, track_id),
	CONSTRAINT artist_track_artists_fk FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id),
	CONSTRAINT artist_track_tracks_fk FOREIGN KEY (track_id) REFERENCES public.tracks(track_id)
);


-- public.favorite_playlists определение

-- Drop table

-- DROP TABLE public.favorite_playlists;

CREATE TABLE public.favorite_playlists (
	playlist_id int4 NOT NULL,
	created_at timestamptz NOT NULL,
	user_id int4 NOT NULL,
	CONSTRAINT favorite_playlists_pk PRIMARY KEY (playlist_id),
	CONSTRAINT favorite_playlists_unique UNIQUE (user_id),
	CONSTRAINT fk_favorite_playlists_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);


-- public.playlist_track определение

-- Drop table

-- DROP TABLE public.playlist_track;

CREATE TABLE public.playlist_track (
	playlist_id int4 NOT NULL,
	track_id int4 NOT NULL,
	added_at timestamptz NULL,
	CONSTRAINT playlist_track_pk PRIMARY KEY (playlist_id, track_id),
	CONSTRAINT fk_favorite_playlists_playlist_track FOREIGN KEY (playlist_id) REFERENCES public.favorite_playlists(playlist_id) ON DELETE CASCADE,
	CONSTRAINT fk_playlist_track_tracks FOREIGN KEY (track_id) REFERENCES public.tracks(track_id) ON DELETE CASCADE
);


-- public.subscriptions определение

-- Drop table

-- DROP TABLE public.subscriptions;

CREATE TABLE public.subscriptions (
	subscriptions_id int4 NOT NULL,
	status bool NOT NULL,
	activation_date timestamptz NULL,
	exp_date timestamptz NULL,
	user_id int4 NOT NULL,
	CONSTRAINT subscribtions_pkey PRIMARY KEY (subscriptions_id),
	CONSTRAINT subscribtions_user_id_key UNIQUE (user_id),
	CONSTRAINT fk_sub_users FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);


