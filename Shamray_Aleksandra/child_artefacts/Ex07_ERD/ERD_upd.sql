DROP SCHEMA S21_BSA_GRENNCOU CASCADE;
CREATE SCHEMA S21_BSA_GRENNCOU;
SET search_path TO S21_BSA_GRENNCOU;

CREATE TYPE auth_stat AS ENUM ('ACTIVE', 'INACTIVE');
CREATE TYPE esim_stat AS ENUM ('PENDING', 'ACTIVE', 'FAILED', 'CANCELLED', 'DEPRECATED');

-- создание таблиц
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    personal_email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    status_auth auth_stat NOT NULL DEFAULT 'INACTIVE'
);

CREATE TABLE eSimTariff (
    eSim_tariff_id SERIAL PRIMARY KEY,
    tariff_name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE eSim (
    esim_id SERIAL PRIMARY KEY,
    user_id INT,
    eSim_tariff_id INT,
    eSim_serial_number VARCHAR(20) UNIQUE NOT NULL,
    eSim_phone_number VARCHAR(12) NOT NULL,
    activation_code VARCHAR(255),
    status_esim esim_stat NOT NULL DEFAULT 'PENDING',
    activation_date TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    CONSTRAINT fk_eSim_tariff_id FOREIGN KEY (eSim_tariff_id) REFERENCES eSimTariff(eSim_tariff_id) ON DELETE SET NULL
);

-- наполнение данными
INSERT INTO Users (user_name, personal_email, phone_number, status_auth) VALUES
('Иван Иванов', 'ivan.ivanov@example.com', '1234567890', 'ACTIVE'),
('Петр Петров', 'petr.petrov@example.com', '9876543210', 'ACTIVE'),
('Александра Шамрай', 'alex.shamray@example.com', '9999999999', 'ACTIVE');

INSERT INTO eSimTariff (tariff_name, description, price) VALUES
('Базовый', 'Базовый тарифный план', 299.00),
('Премиум', 'Премиум тарифный план', 999.00);

INSERT INTO eSim (eSim_serial_number, user_id, eSim_phone_number, activation_code, status_esim, activation_date, eSim_tariff_id) VALUES
( '89ABCDEF1234567890', 1, '9998887744', '12345', 'ACTIVE', NOW(), 1),
( '09FEDCBA1234567890', 1, '7776665522', '67890', 'PENDING', NULL, 2),
( '10FEDCBA1234567899', 3, '6662223333', '99999', 'ACTIVE', NOW(), 1);

-- извлечение данных

-- список пользователей
SELECT * FROM Users;

-- список eSim
SELECT * FROM eSim;

-- список тарифных планов
SELECT * FROM eSimTariff;

-- Примеры запросов для проверки связей:
-- eSim пользователя с user_id = 1
SELECT * FROM eSim WHERE user_id = 1;

-- Тариф eSim с esim_id = 1
SELECT
    us.user_name,
    et.tariff_name,
    e.status_esim,
    e.eSim_phone_number,
    e.activation_date,
    et.price
    FROM eSim e
JOIN eSimTariff et 
ON e.eSim_tariff_id = et.eSim_tariff_id
JOIN  users us
ON e.user_id = us.user_id
WHERE e.user_id = 1;
