-- Создание таблиц

-- Таблица пользователей
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR,
    email VARCHAR,
    phone_number VARCHAR,
    address VARCHAR
);

-- Таблица продуктов
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR,
	description TEXT,
    price DECIMAL,
    available_stock INT
);

-- Таблица заказов
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_name VARCHAR,
	main_order INT,
    order_status VARCHAR,
    total_amount DECIMAL,
	delivery_status VARCHAR,
    delivery_date TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Таблица товаров в заказах
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Заполнение таблицы Products (продукты)
INSERT INTO Products (product_id, product_name, price, available_stock) VALUES
(1, 'Молоко 2.5%', 100, 10),
(2, 'Вода питьевая', 100, 5),
(3, 'Груша сезонная', 100, 10),
(4, 'Огурцы', 200, 5),
(5, 'Томаты', 200, 80),
(6, 'Молоко 3.2%', 100, 120),
(7, 'Вода минеральная', 100, 60),
(8, 'Яблоко сезонное', 100, 75),
(9, 'Кабачки', 200, 89),
(10, 'Киви', 200, 78);

-- Заполнение таблицы Users (пользователи)
INSERT INTO Users (user_id, user_name, email, phone_number, address) VALUES
(1, 'Иван Иванов', 'ivan@mail.ru', '+7 909-456-78-98', 'Минская 2ж'),
(2, 'Ирина Иванова', 'irina@mail.ru', '+7 909-456-78-98', 'Минская 2ж'),
(3, 'Игорь Иванов', 'igor@mail.ru', '+7 909-457-78-987', 'Минская 37ж'),
(4, 'Игнат Иванов', 'ignat@mail.ru', '+7 909-445-78-88', 'Минская 7ж');

-- Создание заказов

-- Создание основного заказа
INSERT INTO Orders (order_id, user_id, order_name, order_status, total_amount, delivery_date,  delivery_status) VALUES
(121253, 1, 'Основной заказ', 'в процессе сборки', 300, '2024-11-27 21:00:00', 'В процессе сборки'),
(121257, 1, 'Основной заказ', 'передан на доставку', 300, '2024-11-27 21:00:00', 'В процессе доставки'),
(121258, 1, 'Основной заказ', 'передан на доставку', 300, '2024-11-27 21:00:00', 'В процессе доставки'),
(121259, 1, 'Основной заказ', 'передан на доставку', 300, '2024-11-27 21:00:00','В процессе доставки');

-- Заполнение товаров в основной заказ
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, price) VALUES
(1, 121253, 1, 1, 100),  -- Молоко 2.5%
(2, 121253, 2, 1, 100),  -- Вода питьевая
(3, 121253, 3, 1, 100);  -- Груша сезонная

-- Создание дополнительного заказа
INSERT INTO Orders (order_id, user_id, order_name, order_status, total_amount, delivery_date, main_order) VALUES
(121253 + 1000, 1, 'Дополнительный заказ', 'в процессе сборки', 500, '2024-11-27 22:00:00', 121253);

-- Заполнение позиций дополнительного заказа
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, price) VALUES
(4, 121253 + 1000, 1, 1, 100),  -- Молоко 2.5%
(5, 121253 + 1000, 4, 1, 200),  -- Огурцы
(6, 121253 + 1000, 5, 1, 200);  -- Томаты


-- Вывод данных о заказах, их статусе и общей сумме, а также связи с основным заказом
SELECT o.order_id, 
       o.order_name, 
       o.order_status, 
       o.total_amount,
	   o.delivery_status,
       main_order.order_id AS main_order_id
FROM Orders o
LEFT JOIN Orders main_order ON o.main_order = main_order.order_id;  
