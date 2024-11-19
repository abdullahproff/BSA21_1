CREATE TYPE widget_type AS ENUM (
    'Table',
    'Bar Chart',
    'Line Chart',
    'Pie Chart',
    'Dashboard',
    'Map',
    'Gauge'
);

CREATE TABLE USERS (
    USER_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Surname VARCHAR(100) NOT NULL,
    INN VARCHAR(12) NOT NULL,
    Passport_data VARCHAR(50) NOT NULL
);
CREATE TABLE DATASOURCES (
    Data_Source_id SERIAL PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL,
    Api_endpoint TEXT NOT NULL, 
    Method VARCHAR(10) CHECK (Method IN ('GET', 'POST', 'PUT', 'DELETE')),
    Params TEXT
);
CREATE TABLE WIDGETS (
    widget_id SERIAL PRIMARY KEY,
    widget_name VARCHAR(100) NOT NULL,
    widget_type widget_type NOT NULL, 
    Data_Source_id INT NOT NULL,
    FOREIGN KEY (Data_Source_id) REFERENCES DATASOURCES(Data_Source_id) ON DELETE CASCADE 
);
CREATE TABLE SETTINGS (
    Setting_id SERIAL PRIMARY KEY,
    User_id INT NOT NULL, 
    WIDGET_id INT NOT NULL, 
    Position_x INT NOT NULL,          -- Положение по оси X
    Position_y INT NOT NULL,          -- Положение по оси Y
    Width INT NOT NULL,               -- Ширина виджета
    Height INT NOT NULL,              -- Высота виджета
    Color_scheme VARCHAR(50), 		-- Цветовая гамма (например, "light", "dark", "custom")
	Widget_size VARCHAR(10) NOT NULL CHECK(Widget_size IN('Small', 'Medium', 'Large')),
    FOREIGN KEY (User_id) REFERENCES USERS(USER_id) ON DELETE CASCADE, 
    FOREIGN KEY (WIDGET_id) REFERENCES WIDGETS(widget_id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX unique_user_widget ON SETTINGS (user_id, widget_id);