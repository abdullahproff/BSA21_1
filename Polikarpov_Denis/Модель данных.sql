CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    phone VARCHAR,
    child_age INT
);

CREATE TABLE psychologists (
    id SERIAL PRIMARY KEY,
    psiholog_name VARCHAR NOT NULL,
    specialization VARCHAR,
    contact_mail VARCHAR
);

CREATE TABLE slots (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    psychologist_id INT REFERENCES psychologists(id),
    slot_time TIMESTAMP NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE waitlist (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    psychologist_id INT REFERENCES psychologists(id)
);
