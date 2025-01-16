-- I. Удаление зависимых таблиц (если они существуют) 

DROP TABLE IF EXISTS rentals; 
DROP TABLE IF EXISTS inspections; 
DROP TABLE IF EXISTS defect_descriptions; 
DROP TABLE IF EXISTS users; 
DROP TABLE IF EXISTS technicians;
DROP TABLE IF EXISTS scooters; 

-- II. Создание таблиц

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    phone_number VARCHAR,
    subscription BOOL
);

CREATE TABLE scooters (
    scooter_id INT PRIMARY KEY,
    charge_rate INT,
    operational_status VARCHAR
);

CREATE TABLE defect_descriptions (
    defect_id INT PRIMARY KEY,
    scooter_id INT UNIQUE,
    defect_type VARCHAR,
    description TEXT,
    repair_status VARCHAR DEFAULT 'under_review',
    FOREIGN KEY (scooter_id) REFERENCES scooters(scooter_id)
);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    scooter_id INT,
    user_id INT,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    duration INT,
    distance DECIMAL,
    cost DECIMAL,
    date DATE,
    ride_status VARCHAR DEFAULT 'successful',
    payment_decision VARCHAR DEFAULT 'no_penalty',
    FOREIGN KEY (scooter_id) REFERENCES scooters(scooter_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE technicians (
    technician_id INT PRIMARY KEY,
    name VARCHAR,
    department_contact VARCHAR
);

CREATE TABLE inspections (
    inspection_id INT PRIMARY KEY,
    defect_id INT UNIQUE,
    inspection_date DATE,
    inspection_result VARCHAR,
    technician_id INT,
    FOREIGN KEY (defect_id) REFERENCES defect_descriptions(defect_id),
    FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);


-- Функция, которая будет выполнять обновление статуса неисправности, атрибутов поездок и статуса доступности самоката

CREATE OR REPLACE FUNCTION update_status_and_attributes()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.inspection_result = 'defect_confirmed' THEN
        UPDATE defect_descriptions
        SET repair_status = 'confirmed'
        WHERE defect_id = NEW.defect_id;

        UPDATE rentals
        SET payment_decision = 'refund', ride_status = 'defect'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id)
        AND date = CURRENT_DATE;

        UPDATE scooters
        SET operational_status = 'unavailable'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id);

    ELSIF NEW.inspection_result = 'no_defect' THEN
        UPDATE defect_descriptions
        SET repair_status = 'not_confirmed'
        WHERE defect_id = NEW.defect_id;

        UPDATE rentals
        SET payment_decision = 'penalty', ride_status = 'penalty'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id)
        AND date = CURRENT_DATE;

        UPDATE scooters
        SET operational_status = 'available'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id);

    ELSIF NEW.inspection_result = 'repair_completed' THEN
        UPDATE defect_descriptions
        SET repair_status = 'completed'
        WHERE defect_id = NEW.defect_id;

        UPDATE scooters
        SET operational_status = 'available'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id);
        
    ELSEIF NEW.inspection_result = 'under_review' THEN
        UPDATE scooters
        SET operational_status = 'unavailable'
        WHERE scooter_id = (SELECT scooter_id FROM defect_descriptions WHERE defect_id = NEW.defect_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер, который будет срабатывать при вставке данных в таблицу inspections

CREATE TRIGGER update_status_and_attributes_trigger
AFTER INSERT ON inspections
FOR EACH ROW
EXECUTE FUNCTION update_status_and_attributes();



-- III. Заполнение таблиц данными

-- Заполнение таблиц данными
INSERT INTO users (user_id, phone_number, subscription) VALUES 
(1, '123-456-7890', TRUE),
(2, '098-765-4321', FALSE),
(3, '555-555-5555', TRUE);

INSERT INTO technicians (technician_id, name, department_contact) VALUES
(1, 'John Doe', '123-456-7890'),
(2, 'Jane Smith', '123-456-7890'),
(3, 'Alex Brown', '098-765-4321'),
(4, 'Chris Green', '098-765-4321');

INSERT INTO scooters (scooter_id, charge_rate, operational_status) VALUES 
(1, 85, 'available'),
(2, 50, 'available'),
(3, 100, 'available');

INSERT INTO defect_descriptions (defect_id, scooter_id, defect_type, description) VALUES 
(1, 1, 'mechanical', 'Brakes are not functioning properly'),
(2, 2, 'electrical', 'Battery not charging');

INSERT INTO rentals (rental_id, scooter_id, user_id, start_time, end_time, duration, distance, cost, date) VALUES 
(1, 1, 1, '2024-12-03 12:00:00', '2024-12-03 12:30:00', 30, 5.2, 10.00, '2024-12-03'),
(2, 2, 2, '2024-12-03 13:00:00', '2024-12-03 13:45:00', 45, 7.5, 15.00, '2024-12-03'),
(3, 2, 1, '2024-12-04 13:00:00', '2024-12-04 13:30:00', 30, 4.5, 8.00, '2024-12-04'),
(4, 3, 3, '2024-12-03 14:00:00', '2024-12-03 14:20:00', 20, 3.0, 5.00, '2024-12-03');

INSERT INTO inspections (inspection_id, defect_id, inspection_date, inspection_result, technician_id) VALUES 
(1, 1, '2024-12-04', 'defect_confirmed', 1),
(2, 2, '2024-12-05', 'no_defect', 3);


-- IV. Проверка выборок, имитирующих User Story

-- Вывод списка поездок для пользователя с user_id = 1 до добавления поездки с неисправностью
SELECT rental_id, scooter_id, user_id, start_time, end_time, ride_status, payment_decision 
FROM rentals 
WHERE user_id = 1; 

-- Вставка новой поездки с неисправностью 
INSERT INTO rentals (rental_id, scooter_id, user_id, start_time, end_time, duration, distance, cost, date, ride_status, payment_decision) VALUES 
(5, 3, 1, '2024-12-05 14:00:00', '2024-12-05 14:20:00', 20, 3.0, 5.00, '2024-12-05', 'defect', 'refund'); 

-- Вывод списка поездок для пользователя с user_id = 1 после добавления поездки с неисправностью 
SELECT rental_id, scooter_id, user_id, start_time, end_time, ride_status, payment_decision 
FROM rentals 
WHERE user_id = 1;
