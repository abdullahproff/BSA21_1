PGDMP  /    *            
    |            kanyukov    16.4    16.4     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                        0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16547    kanyukov    DATABASE     |   CREATE DATABASE kanyukov WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE kanyukov;
                postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1259    16581 	   favorites    TABLE     �   CREATE TABLE public.favorites (
    favorites_id integer NOT NULL,
    user_id integer,
    video_id integer,
    number_of_videos integer
);
    DROP TABLE public.favorites;
       public         heap    postgres    false    4            �            1259    16580    favorites_favorites_id_seq    SEQUENCE     �   CREATE SEQUENCE public.favorites_favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.favorites_favorites_id_seq;
       public          postgres    false    4    220                       0    0    favorites_favorites_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.favorites_favorites_id_seq OWNED BY public.favorites.favorites_id;
          public          postgres    false    219            �            1259    16549    users    TABLE     O  CREATE TABLE public.users (
    user_id integer NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    middlename character varying(100),
    username character varying(50),
    gender character varying(10),
    age integer,
    email character varying(100),
    phone_number character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false    4            �            1259    16548    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    216    4                       0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    16556    videos    TABLE     �   CREATE TABLE public.videos (
    video_id integer NOT NULL,
    title character varying(200),
    duration integer,
    format integer,
    preview integer,
    upload_date timestamp with time zone
);
    DROP TABLE public.videos;
       public         heap    postgres    false    4            �            1259    16555    videos_video_id_seq    SEQUENCE     �   CREATE SEQUENCE public.videos_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.videos_video_id_seq;
       public          postgres    false    218    4                       0    0    videos_video_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.videos_video_id_seq OWNED BY public.videos.video_id;
          public          postgres    false    217            \           2604    16584    favorites favorites_id    DEFAULT     �   ALTER TABLE ONLY public.favorites ALTER COLUMN favorites_id SET DEFAULT nextval('public.favorites_favorites_id_seq'::regclass);
 E   ALTER TABLE public.favorites ALTER COLUMN favorites_id DROP DEFAULT;
       public          postgres    false    219    220    220            Z           2604    16552    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    216    215    216            [           2604    16559    videos video_id    DEFAULT     r   ALTER TABLE ONLY public.videos ALTER COLUMN video_id SET DEFAULT nextval('public.videos_video_id_seq'::regclass);
 >   ALTER TABLE public.videos ALTER COLUMN video_id DROP DEFAULT;
       public          postgres    false    218    217    218            �          0    16581 	   favorites 
   TABLE DATA           V   COPY public.favorites (favorites_id, user_id, video_id, number_of_videos) FROM stdin;
    public          postgres    false    220   �!       �          0    16549    users 
   TABLE DATA           u   COPY public.users (user_id, firstname, lastname, middlename, username, gender, age, email, phone_number) FROM stdin;
    public          postgres    false    216   �!       �          0    16556    videos 
   TABLE DATA           Y   COPY public.videos (video_id, title, duration, format, preview, upload_date) FROM stdin;
    public          postgres    false    218   H"                  0    0    favorites_favorites_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.favorites_favorites_id_seq', 4, true);
          public          postgres    false    219                       0    0    users_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_user_id_seq', 2, true);
          public          postgres    false    215                       0    0    videos_video_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.videos_video_id_seq', 2, true);
          public          postgres    false    217            b           2606    16586    favorites favorites_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (favorites_id);
 B   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_pkey;
       public            postgres    false    220            d           2606    16588 (   favorites favorites_user_id_video_id_key 
   CONSTRAINT     p   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_video_id_key UNIQUE (user_id, video_id);
 R   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_user_id_video_id_key;
       public            postgres    false    220    220            ^           2606    16554    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    216            `           2606    16561    videos videos_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (video_id);
 <   ALTER TABLE ONLY public.videos DROP CONSTRAINT videos_pkey;
       public            postgres    false    218            e           2606    16589     favorites favorites_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 J   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_user_id_fkey;
       public          postgres    false    216    4702    220            f           2606    16594 !   favorites favorites_video_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_video_id_fkey FOREIGN KEY (video_id) REFERENCES public.videos(video_id);
 K   ALTER TABLE ONLY public.favorites DROP CONSTRAINT favorites_video_id_fkey;
       public          postgres    false    220    218    4704            �       x�3�4A.# 	�\� H� i?F��� SW      �   �   x�]���@E��_1!��:m�lm&0�d_d����n�ɭNnN\0���9\*�q�D���
��hU��z�7��S3� '#�^ic���@w�\>^>��=���nS�(Ԟ��ޗ��`�V}'[�l�_�<1      �   O   x�E�K
�0����)�K%���,n=��?���@֯�c�d������6Q���U=#�� E�/BG��8w 5��     