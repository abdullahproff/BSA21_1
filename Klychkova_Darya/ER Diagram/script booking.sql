DROP TABLE IF EXISTS users, account_settings, properties CASCADE;

-- таблица пользователи
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(15) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- таблица настройки аккаунта
CREATE TABLE account_settings (
  account_setting_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  lang VARCHAR(10), 
  currency VARCHAR(10),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- таблица жильё
CREATE TABLE properties (
  property_id SERIAL PRIMARY KEY,
  owner_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  address VARCHAR(255) NOT NULL,
  price_per_night INT CHECK(price_per_night >= 0) NOT NULL,
  max_guests SMALLINT CHECK(max_guests > 0) NOT NULL, 
  amenities VARCHAR(255),
  status VARCHAR(20) NOT NULL, 
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Заполнение таблицы users
INSERT INTO users (first_name, last_name, phone, email, created_at)
VALUES 
('Александр', 'Пушкин', '89001234567', 'pushka@example.com', NOW()),
('Петр', 'Первый', '89007654321', 'petrthegreat@example.com', NOW()),
('Владимир', 'Солнышко', '89001234568', 'svet@example.com', NOW()),
('Ольга', 'Княгиня', '89007654322', 'olga@example.com', NOW()),
('Александр', 'Гамильтон', '89001234569', 'alexander@example.com', NOW());

-- Заполнение таблицы account_settings
INSERT INTO account_settings (user_id, lang, currency)
VALUES 
(1, 'ru', 'RUB'),
(2, 'en', 'USD'),
(3, 'fr', 'EUR');

-- Заполнение таблицы properties
INSERT INTO properties (owner_id, title, address, price_per_night, max_guests, amenities, status, created_at, updated_at)
VALUES 
(1, 'Уютная квартира', 'Москва, ул. Пушкина, д. 14', 3000, 2, 'Wi-Fi, телевизор', 'available', NOW(), NOW()),
(2, 'Светлые апартаменты', 'Санкт-Петербург, ул. Ленина, д. 2', 5000, 4, 'Wi-Fi, телевизор, парковка', 'available', NOW(), NOW()),
(3, 'Домик у моря', 'Сочи, ул. Черноморская, д. 3', 5500, 3, 'Wi-Fi, кондиционер', 'available', NOW(), NOW()),
(4, 'Гостевой дом', 'Казань, ул. Баумана, д. 4', 2500, 5, 'Wi-Fi, завтрак включен', 'booked', NOW(), NOW());

-- запрос выводит инф о пользователе и жилье, сортирует по цене и имени в убывании
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.phone,
    u.email,
    a.lang,
    a.currency,
    p.property_id,
    p.title,
    p.address,
    p.price_per_night,
    p.max_guests,
    p.amenities,
    p.status
FROM 
    users u
LEFT JOIN 
    account_settings a ON u.user_id = a.user_id
LEFT JOIN 
    properties p ON u.user_id = p.owner_id
    ORDER BY 
    p.price_per_night, u.first_name DESC;
