CREATE TABLE clients
(
    client_id      INT PRIMARY KEY,
    tel_number_client    VARCHAR(50) UNIQUE CHECK (tel_number_client ~ '^\+?[0-9]{2,}$'),
    name_client        VARCHAR(150),
    surname_client        VARCHAR(150),
    patronymic_client        VARCHAR(150),
    city_client            VARCHAR(150),
    email_client          VARCHAR(255) UNIQUE CHECK (email_client ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE photographers
(
    photographer_id    INT PRIMARY KEY,
    tel_number_ph      VARCHAR(50) UNIQUE CHECK (tel_number_ph ~ '^\+?[0-9]{2,}$'),
    name_ph            VARCHAR(150),
    surname_ph         VARCHAR(150),
    patronymic_ph      VARCHAR(150),
    main_city_ph       VARCHAR(150),
    email_ph           VARCHAR(255) UNIQUE CHECK (email_ph ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    type_ph            TEXT[],  -- Массив текстовых значений
    price_list         VARCHAR(100),
    calendar_ph        VARCHAR(100),
    style_ph           TEXT[],  -- Массив текстовых значений
    portfolio          VARCHAR(100),
    rating_ph          INT
);

CREATE TABLE orders
(
    order_id          INT PRIMARY KEY,
    client_id         INT,
    photographer_id    INT,
    time_date         TIMESTAMP WITH TIME ZONE,
    order_location    TEXT,
    duration          INTERVAL,
    type_order        VARCHAR(50),
    style_order       VARCHAR(50),
    summary_price     DECIMAL(10, 2),
    prepayment        DECIMAL(10, 2),
    CONSTRAINT fk_orders_clients FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT fk_orders_photographers FOREIGN KEY (photographer_id) REFERENCES photographers(photographer_id)
);

CREATE TABLE locations
(
	loc_id	INT PRIMARY KEY,
    photographer_id INT,
    ph_country VARCHAR(100) NOT NULL,
    ph_city VARCHAR(100),
    ph_street VARCHAR(100),
    ph_building VARCHAR(50),
    ph_latitude DECIMAL(8, 6) NOT NULL,
    ph_longitude DECIMAL(8, 6) NOT NULL,
    CONSTRAINT fk_locations_photographers FOREIGN KEY (photographer_id) REFERENCES photographers(photographer_id)
);
