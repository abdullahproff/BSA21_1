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
