DROP SCHEMA S21_SA_TASK7 CASCADE;
CREATE SCHEMA S21_SA_TASK7;
SET search_path TO S21_SA_TASK7;

-- создание таблиц
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL, 
    email VARCHAR(100),
    phone VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE planetary_systems (
    system_id INT PRIMARY KEY,
    system_name VARCHAR(500) NOT NULL,
    description VARCHAR(2000), 
    details TEXT,
    author_id INT,
    created_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users(user_id)
);

CREATE TABLE planets (
    planet_id INT PRIMARY KEY,
    planet_name VARCHAR(500) NOT NULL,
    description VARCHAR(2000), 
    details TEXT,
    author_id INT,
    planet_system_id INT,
    created_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users(user_id),
    CONSTRAINT fk_planet_system_id FOREIGN KEY (planet_system_id) REFERENCES planetary_systems(planet_system_id)
);

-- наполнение данными
INSERT INTO users(
                user_id
                , first_name
                , last_name
                , email
                , phone
            ) 
VALUES
(1, 'Pinco', 'Pallino', 'pinco.pallino@gmail.com', '+41000077786'),
(2, 'Punto', 'Lavoro', 'punto.lavoro@gmail.com', '+41000088786'),
(3, 'Pinocchio', 'Sanchez', 'inocchio.sanchez@gmail.com', '+41000099786');

INSERT INTO planetary_systems(
                system_id
                , system_name
                , description
                , details
                , author_id
            ) 
VALUES
(   1
    , 'Солнечная система'
    , 'Местное межзвёздное облако, Местный пузырь, рукав Ориона, Млечный Путь, Местная группа галактик'
    , 'Планетная система, включающая в себя центральную звезду Солнце и все естественные космические объекты на гелиоцентрических орбитах'
    , 1
),
(   2
    , 'Альфа Центавра'
    , 'Тройная звёздная система в созвездии Центавра'
    , 'Две главные звезды α Центавра А и α Центавра B принадлежат главной последовательности и близки по характеристикам к Солнцу.'
    , 2
);


INSERT INTO planets(
                planet_id
                , planet_name
                , description
                , details
                , author_id
                , planet_system_id
            ) 
VALUES
(   1
    , 'Меркурий'
    , 'Первая планета от Солнца'
    , 'Наименьшая планета Солнечной системы и самая близкая к Солнцу. Названа в честь древнеримского Бога торговли — быстрого Меркурия, поскольку она движется по небу быстрее других планет.'
    , 3
    , 1
),
(   2
    , 'Венера'
    , 'Вторая планета от Солнца'
    , 'Вторая по удалённости от Солнца и шестая по размеру планета Солнечной системы, наряду с Меркурием, Землёй и Марсом принадлежащая к семейству планет земной группы.'
    , 2
    , 1
),
(   3
    , 'Земля'
    , 'Третья планета от Солнца'
    , 'Самая плотная, пятая по диаметру и массе среди всех планет Солнечной системы и крупнейшая среди планет земной группы, в которую входят также Меркурий, Венера и Марс. Единственное известное человеку в настоящее время тело во Вселенной, населённое живыми организмами.'
    , 1
    , 1
),
(   4
    , 'Альфа Центавра A b'
    , 'Кандидат в экзопланеты в системе звезды Альфа Центавра А'
    , 'вторая по удалённости от Солнца и шестая по размеру планета Солнечной системы, наряду с Меркурием, Землёй и Марсом принадлежащая к семейству планет земной группы.'
    , 3
    , 2
),
(   5
    , 'Альфа Центавра B b'
    , 'Обращается вокруг более тусклого компонента двойной системы Альфа Центавра, звезды Альфа Центавра B'
    , 'Известно об этом кандидате в экзопланеты пока мало, однако некоторые его характеристики из проведённых наблюдений всё же можно извлечь.'
    , 2
    , 2
);


-- извлечение данных

-- список пользователей
SELECT *
FROM users

-- список планет
SELECT planet_name
FROM planets

-- список планетных систем
SELECT system_name
FROM planetary_systems

-- список планет через название id планетарной системы
SELECT *
FROM planets
WHERE planet_system_id = 1

-- список планет через название планеты
SELECT *
FROM planets
WHERE planet_name = 'Венера'


DROP TABLE users, planetary_systems, planets
