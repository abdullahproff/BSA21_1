-- Создание таблицы Users
CREATE TABLE Users (
    user_ID SERIAL PRIMARY KEY,
    user_login VARCHAR NOT NULL UNIQUE,
    user_name VARCHAR,
    user_surname VARCHAR,
    kadry_online BOOLEAN,
    kadry_full_settings BOOLEAN DEFAULT FALSE
);

-- Создание таблицы Kadri_online_tax_plan
CREATE TABLE Kadri_online_tax_plan (
    tax_plan_ID SERIAL PRIMARY KEY,
    tax_name VARCHAR,
    tax_cost INT,
    tax_period INT
);

-- Создание таблицы Kadri_online_access_period
CREATE TABLE Kadri_online_access_period (
    access_period_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    tax_plan_ID INT,
    access_period_start DATE,
    access_period_off DATE,
    CONSTRAINT fk_period_plan FOREIGN KEY (user_ID) REFERENCES Users(user_ID),
    CONSTRAINT fk_period_users FOREIGN KEY (tax_plan_ID) REFERENCES Kadri_online_tax_plan(tax_plan_ID)
);

-- Создание таблицы Kadri_online_settings
CREATE TABLE Kadri_online_settings (
    settings_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    setting_year INT CHECK (setting_year >= 1900 AND setting_year <= 2100), -- Ограничение на год
    date_advance INT CHECK (date_advance BETWEEN 1 AND 31), -- Ограничение на диапазон
    date_salary INT CHECK (date_salary BETWEEN 1 AND 31),
    reserv_money BOOLEAN,
    month_off INT CHECK (month_off BETWEEN 1 AND 31),
    date_send_pers INT CHECK (date_send_pers BETWEEN 1 AND 31),
    date_send_6_ndfl INT CHECK (date_send_6_ndfl BETWEEN 1 AND 31),
    date_send_efc_1 INT CHECK (date_send_efc_1 BETWEEN 1 AND 31),
    date_send_rsv INT CHECK (date_send_rsv BETWEEN 1 AND 31),
    CONSTRAINT fk_settings_users FOREIGN KEY (user_ID) REFERENCES Users(user_ID)
);

-- Функция для обновления поля kadry_full_settings в таблице Users
CREATE OR REPLACE FUNCTION update_kadry_full_settings()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Users
    SET kadry_full_settings = NOT EXISTS (
        SELECT 1
        FROM Kadri_online_settings
        WHERE user_ID = NEW.user_ID
          AND (
            setting_year IS NULL OR
            date_advance IS NULL OR
            date_salary IS NULL OR
            reserv_money IS NULL OR
            month_off IS NULL OR
            date_send_pers IS NULL OR
            date_send_6_ndfl IS NULL OR
            date_send_efc_1 IS NULL OR
            date_send_rsv IS NULL
          )
    )
    WHERE user_ID = NEW.user_ID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для обновления kadry_full_settings при изменении Kadri_online_settings
CREATE TRIGGER update_kadry_full_settings_trigger
AFTER INSERT OR UPDATE ON Kadri_online_settings
FOR EACH ROW
EXECUTE FUNCTION update_kadry_full_settings();

-- Функция для вычисления access_period_off в таблице Kadri_online_access_period
CREATE OR REPLACE FUNCTION update_access_period_off()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tax_plan_ID IS NOT NULL THEN
        NEW.access_period_off := NEW.access_period_start + INTERVAL '1 day' * (
            SELECT tax_period
            FROM Kadri_online_tax_plan
            WHERE tax_plan_ID = NEW.tax_plan_ID
        );
    ELSE
        RAISE WARNING 'tax_plan_ID is NULL, cannot calculate access_period_off';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для обновления access_period_off
CREATE OR REPLACE TRIGGER update_access_period_off_trigger
BEFORE INSERT OR UPDATE ON Kadri_online_access_period
FOR EACH ROW
EXECUTE FUNCTION update_access_period_off();

-- Вставка данных в таблицу Users
INSERT INTO Users (user_login, user_name, user_surname, kadry_online) VALUES
    ('loginDD', 'Dima', 'Dubov', true),
    ('loginNN', 'Nikolay', 'Nikolaev', true),
    ('loginBB', 'Boris', 'Borisov', false);

-- Вставка данных в таблицу Kadri_online_tax_plan
INSERT INTO Kadri_online_tax_plan (tax_name, tax_cost, tax_period) VALUES
    ('1_year', 12000, 365),
    ('30_days', 2000, 30),
    ('free', 0, 14);

-- Вставка данных в таблицу Kadri_online_access_period
INSERT INTO Kadri_online_access_period (user_ID, tax_plan_ID, access_period_start) VALUES
    (1, 1, '2024-10-23'), -- Используем существующий tax_plan_ID (например, 1_year)
    (2, 2, '2024-11-01'); -- Используем существующий tax_plan_ID (например, 30_days)

-- Вставка данных в таблицу Kadri_online_settings
INSERT INTO Kadri_online_settings (
    user_ID, 
    setting_year, 
    date_advance, 
    date_salary, 
    reserv_money, 
    month_off, 
    date_send_pers, 
    date_send_6_ndfl, 
    date_send_efc_1, 
    date_send_rsv
) 
VALUES (1, 2024, 25, 10, true, 5, 7, 7, 8, 8);

INSERT INTO Kadri_online_settings (
    user_ID, 
    setting_year, 
    date_advance, 
    date_salary, 
    reserv_money, 
    month_off, 
    date_send_pers, 
    date_send_6_ndfl
) 
VALUES (2, 2024, 25, 10, false, 5, 7, 7);
