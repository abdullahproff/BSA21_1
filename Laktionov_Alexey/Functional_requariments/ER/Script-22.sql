-- Создаем таблицу для пользователей
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,        
  full_name VARCHAR(150) NOT NULL,    
  email VARCHAR(150) NOT NULL,       
  phonenumber VARCHAR(50) NOT NULL,   
  country VARCHAR(50) NOT NULL,     
  city VARCHAR(50) NOT NULL      
);

-- Заполнение таблицы пользователей
INSERT INTO users (full_name, email, phonenumber, country, city) VALUES
('Иван Иванов', 'ivan.ivanov@example.com', '+79161234567', 'Россия', 'Москва'),
('Петр Петров', 'petr.petrov@example.com', '+79269876543', 'Россия', 'Санкт-Петербург'),
('Сидор Сидоров', 'sidr.sidorov@example.com', '+79031234567', 'Россия', 'Новосибирск'),
('Анна Абрамова', 'anna.abramova@example.com', '+79114567890', 'Россия', 'Екатеринбург'),
('Мария Миронова', 'maria.mironova@example.com', '+79501112233', 'Россия', 'Казань'),
('Дмитрий Дмитриев', 'dmitry.dmitriev@example.com', '+79211234567', 'Россия', 'Ростов-на-Дону'),
('Елена Егорова', 'elena.egorova@example.com', '+74951234567', 'Россия', 'Краснодар'),
('Андрей Андреев', 'andrei.andreev@example.com', '+78121234567', 'Россия', 'Нижний Новгород'),
('Ольга Орлова', 'olga.orlova@example.com', '+73431234567', 'Россия', 'Пермь'),
('Сергей Сергеев', 'sergey.sergeev@example.com', '+73831234567', 'Россия', 'Самара');

-- Создаем таблицу для товаров
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  category VARCHAR(255) NOT NULL
);

-- Заполнение таблицы товаров
INSERT INTO products (product_name, description, price, category) VALUES
('Смартфон X10 Pro', 'Флагманский смартфон с мощным процессором', 45000, 'Электроника'),
('Футболка с логотипом', 'Стильная футболка с логотипом', 1500, 'Одежда'),
('Набор ножей', 'Профессиональный набор ножей из нержавеющей стали', 5000, 'Товары для дома'),
('Наушники беспроводные', 'Беспроводные наушники с отличным звуком', 3000, 'Электроника'),
('Кроссовки спортивные', 'Удобные и стильные кроссовки для спорта', 8000, 'Одежда'),
('Кофемолка электрическая', 'Электрическая кофемолка для быстрого помола кофе', 2500, 'Товары для дома'),
('Пылесос робот', 'Роботизированный пылесос для автоматической уборки', 20000, 'Товары для дома'),
('Планшет Y7', 'Мощный планшет с большим экраном', 28000, 'Электроника'),
('Куртка зимняя', 'Теплая и стильная зимняя куртка', 12000, 'Одежда'),
('Сумка дорожная', 'Удобная и вместительная дорожная сумка', 4000, 'Аксессуары');

-- Создаем таблицу для избранного
CREATE TABLE favorites (
  favorite_id SERIAL PRIMARY KEY,
  user_id INT,                                 
  product_id INT,                              
  added_time TIMESTAMP,                        
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Заполнение таблицы избранного
INSERT INTO favorites (user_id, product_id, added_time) VALUES
(1, 1, '2024-03-08 10:00:00'),
(1, 5, '2024-03-08 10:05:00'),
(2, 3, '2024-03-08 11:10:00'),
(2, 7, '2024-03-08 11:15:00'),
(3, 2, '2024-03-08 12:20:00'),
(3, 9, '2024-03-08 12:25:00'),
(1, 10, '2024-03-09 09:00:00'),
(2, 1, '2024-03-09 09:30:00'),
(4, 4, '2024-03-10 10:00:00'),
(4, 6, '2024-03-10 10:15:00');


