CREATE TABLE Psychologists (
    id SERIAL PRIMARY KEY,
    psiholog_name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255),
    contact_mail VARCHAR(255) UNIQUE
);

CREATE TABLE Clients (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    child_age INTEGER
);

CREATE TABLE AvailableSlots (
    id SERIAL PRIMARY KEY,
    psychologist_id INTEGER NOT NULL,
    slot_time TIMESTAMP NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (psychologist_id) REFERENCES Psychologists(id)
);

CREATE TABLE BookedClients (
    id SERIAL PRIMARY KEY,
    slot_id INTEGER UNIQUE NOT NULL,
    client_id INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (slot_id) REFERENCES AvailableSlots(id),
    FOREIGN KEY (client_id) REFERENCES Clients(id)
);

CREATE TABLE WaitingList (
    id SERIAL PRIMARY KEY,
    client_id INTEGER UNIQUE NOT NULL,
    psychologist_id INTEGER NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(id),
    FOREIGN KEY (psychologist_id) REFERENCES Psychologists(id)
);

-- Вставка данных в таблицу Psychologists
INSERT INTO Psychologists (psiholog_name, specialization, contact_mail)
VALUES
('Др. Иван Петров', 'Детская психология', 'ivan.petrov@example.com'),
('Др. Мария Смирнова', 'Клиническая психология', 'maria.smirnova@example.com'),
('Др. Алексей Тихонов', 'Когнитивная терапия', 'alexey.tikhonov@example.com');

-- Вставка данных в таблицу Clients
INSERT INTO Clients (user_name, email, phone, child_age)
VALUES
('Анна Иванова', 'anna.ivanova@example.com', '1234567890', 12),
('Борис Петров', 'boris.petrov@example.com', '0987654321', 15),
('Виктор Сидоров', 'viktor.sidorov@example.com', '5678901234', 10);

-- Вставка данных в таблицу AvailableSlots
INSERT INTO AvailableSlots (psychologist_id, slot_time, is_available)
VALUES
(1, '2024-12-11 10:00:00', TRUE),
(1, '2024-12-11 11:00:00', TRUE),
(2, '2024-12-12 09:00:00', TRUE),
(3, '2024-12-13 14:00:00', TRUE);

-- Вставка данных в таблицу BookedClients
INSERT INTO BookedClients (slot_id, client_id)
VALUES
(1, 1),  -- Анна Иванова бронирует слот у Др. Иван Петров
(2, 2);  -- Борис Петров бронирует другой слот у Др. Иван Петров

-- Вставка данных в таблицу WaitingList
INSERT INTO WaitingList (client_id, psychologist_id)
VALUES
(3, 1),  -- Виктор Сидоров добавляется в лист ожидания к Др. Иван Петров
(2, 2);  -- Борис Петров добавляется в лист ожидания к Др. Мария Смирнова
