-- Очистка
DROP TABLE IF EXISTS meal_items CASCADE;
DROP TABLE IF EXISTS analytics CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS meal CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS meal_type_enum CASCADE;

-- Создание типа и таблиц
CREATE TYPE meal_type_enum AS ENUM ('Завтрак', 'Обед', 'Ужин', 'Перекус');

CREATE TABLE users (
    user_id 		SERIAL PRIMARY KEY,
    user_name 		VARCHAR(100) NOT NULL,
    user_age 		INT NOT NULL,
    user_height 	INT NOT NULL,
    user_weight		NUMERIC(10, 2) NOT NULL,
    user_goal 		NUMERIC(10, 2),  
    user_email 		VARCHAR(100) UNIQUE NOT NULL CHECK (user_email ~* '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    user_country 	VARCHAR(255),
    daily_proteins 	NUMERIC(10, 2) NOT NULL,
    daily_fats 		NUMERIC(10, 2) NOT NULL,   
    daily_carbos 	NUMERIC(10, 2) NOT NULL   
);

CREATE TABLE meal (
    meal_id 		SERIAL PRIMARY KEY,
    user_id 		INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    meal_date 		DATE NOT NULL,
    meal_time 		TIME NOT NULL,
    meal_type meal_type_enum NOT NULL
);

CREATE TABLE product (
    product_id 			SERIAL PRIMARY KEY,
    product_name 		VARCHAR(100) NOT NULL,
    product_kcal 		NUMERIC(10, 2) NOT NULL,
    product_proteins 	NUMERIC(10, 2) NOT NULL,
    product_fats 		NUMERIC(10, 2) NOT NULL,
    product_carbos 		NUMERIC(10, 2) NOT NULL
);

CREATE TABLE meal_items (
    meal_id 			INT NOT NULL REFERENCES meal(meal_id) ON DELETE CASCADE,
    product_id 			INT NOT NULL REFERENCES product(product_id) ON DELETE CASCADE,
    product_quantity 	NUMERIC(10, 2) NOT NULL
);

CREATE TABLE analytics (
    user_id 		INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    meal_id 		INT NOT NULL REFERENCES meal(meal_id) ON DELETE CASCADE,
    date 			TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    summ_kcal 		NUMERIC(10, 2),
    summ_proteins 	NUMERIC(10, 2),
    summ_fats 		NUMERIC(10, 2),
    summ_carbos 	NUMERIC(10, 2),
    PRIMARY KEY (user_id, meal_id)
);

-- Аналитика КБЖУ
CREATE OR REPLACE FUNCTION recalculate_analytics()
RETURNS VOID AS $$
BEGIN
    DELETE FROM analytics;

    INSERT INTO analytics (user_id, meal_id, date, summ_kcal, summ_proteins, summ_fats, summ_carbos)
    SELECT 
        m.user_id,
        mi.meal_id,
        CURRENT_TIMESTAMP,
        SUM(p.product_kcal * mi.product_quantity / 100),
        SUM(p.product_proteins * mi.product_quantity / 100),
        SUM(p.product_fats * mi.product_quantity / 100),
        SUM(p.product_carbos * mi.product_quantity / 100)
    FROM 
        meal_items mi
    JOIN 
        product p ON mi.product_id = p.product_id
    JOIN 
        meal m ON mi.meal_id = m.meal_id
    GROUP BY 
        m.user_id, mi.meal_id;
END;
$$ LANGUAGE plpgsql;

-- Заполнение таблиц 
INSERT INTO users (user_name, user_age, user_height, user_weight, user_goal, user_email, user_country, daily_proteins, daily_fats, daily_carbos) 
VALUES
('Sarah', 38, 162, 58, 1800, 'sarahhello@gmail.com', 'USA', 100, 70, 250),
('Jessica', 19, 176, 61, 1900, 'whoami@gmail.com', 'New Zealand', 120, 80, 300),
('Parker', 27, 189, 79, 2100, 'parkssquaresandrecreations@gmail.com', 'United Kingdom', 130, 90, 350);

INSERT INTO meal (user_id, meal_date, meal_time, meal_type) 
VALUES
(1, '2024-11-23', '08:00:00', 'Завтрак'),
(2, '2024-11-20', '12:00:00', 'Обед'),
(3, '2024-11-21', '19:00:00', 'Ужин');

INSERT INTO product (product_name, product_kcal, product_proteins, product_fats, product_carbos) 
VALUES
('Авокадо свежее', 160, 2, 14.7, 1.8),
('Гречка отварная', 100.9, 4.2, 1.1, 18.6),
('Курица отварная', 244, 22.6, 17, 0);

INSERT INTO meal_items (meal_id, product_id, product_quantity) 
VALUES
(1, 1, 150), 
(1, 2, 100),
(2, 2, 300),
(3, 3, 200);

-- Пересчет аналитики
SELECT recalculate_analytics();

-- Вывод данных аналитики с расчетом остатка
SELECT
	a.user_id AS "Пользователь (ID)",    
	u.user_name AS "Имя пользователя",
    a.date AS "Дата и время",
    a.summ_kcal AS "Потребленные калории",
    u.user_goal - a.summ_kcal AS "Осталось калорий",
    a.summ_proteins AS "Потребленные белки",
    u.daily_proteins - a.summ_proteins AS "Осталось белков",
    a.summ_fats AS "Потребленные жиры",
    u.daily_fats - a.summ_fats AS "Осталось жиров",
    a.summ_carbos AS "Потребленные углеводы",
    u.daily_carbos - a.summ_carbos AS "Осталось углеводов"
FROM analytics a
JOIN users u ON a.user_id = u.user_id;
