-- Заполнение таблицы USERS
INSERT INTO USERS (Name, Surname, INN, Passport_data) VALUES
('Иван', 'Иванов', '123456789012', '1234 567890'),
('Мария', 'Петрова', '987654321098', '2345 678901'),
('Алексей', 'Сидоров', '456789123456', '3456 789012'),
('Елена', 'Кузнецова', '321654987321', '4567 890123');

-- Заполнение таблицы DATASOURCES
INSERT INTO DATASOURCES (source_name, Api_endpoint, Method, Params) VALUES
('User API', 'https://api.example.com/users', 'GET', ''),
('Sales Data API', 'https://api.example.com/sales', 'GET', ''),
('Inventory API', 'https://api.example.com/inventory', 'POST', '{"item_id": "int", "quantity": "int"}'),
('Weather API', 'https://api.example.com/weather', 'GET', '{"location": "string"}');

-- Заполнение таблицы WIDGETS
INSERT INTO WIDGETS (widget_name, widget_type, Data_Source_id) VALUES
('Пользователи', 'Table', 1),
('Продажи за месяц', 'Bar Chart', 2),
('Запасы на складе', 'Line Chart', 3),
('Погода в городе', 'Gauge', 4),
('Общий обзор продаж', 'Dashboard', 2);

-- Заполнение таблицы SETTINGS
INSERT INTO SETTINGS (User_id, WIDGET_id, Position_x, Position_y, Width, Height, Color_scheme, Widget_size) VALUES
(1, 1, 0, 0, 300, 200, 'light', 'Medium'),
(1, 2, 0, 220, 300, 200, 'dark', 'Large'),
(2, 3, 320, 0 ,300 ,200 ,'custom' ,'Small'),
(2 ,4 ,320 ,220 ,300 ,200 ,'light' ,'Medium'),
(3 ,5 ,0 ,440 ,640 ,200 ,'dark' ,'Large'),
(4 ,1 ,0 ,660 ,300 ,200 ,'light' ,'Medium');