-- Создание таблицы users
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    phone VARCHAR
);

-- Создание таблицы products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name_product VARCHAR,
    description TEXT,
    price DECIMAL 
);

-- Создание таблицы baskets
CREATE TABLE baskets (
    basket_id INT PRIMARY KEY,
    total_cost DECIMAL,
    link VARCHAR,
     user_id INT,
     FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Создание таблицы shopping_histories 
CREATE TABLE shopping_histories (
    Orderes_id INT PRIMARY KEY,
    basket_id INT,
    user_id INT,
     FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (basket_id) REFERENCES baskets (basket_id)  
);

   CREATE TABLE basket_items (
       basket_id INTEGER REFERENCES baskets(basket_id),
       product_id INTEGER REFERENCES products(product_id),
       PRIMARY KEY (basket_id, product_id)
   );
  
-- Создание таблицы messages 
CREATE TABLE messages (
messages_id  INT PRIMARY KEY,
    sender INT,
    recipient INT,
    text VARCHAR,
     basket_id INT,
    FOREIGN KEY (sender) REFERENCES users(user_id),
     FOREIGN KEY (basket_id) REFERENCES baskets (basket_id)  
   );  
     
     INSERT INTO users (user_id, name, last_name, email, phone) VALUES
(1, 'Дмитрий', 'Иванов', 'dima@gmail.com', '927-456-7890'),
(2, 'Мария', 'Петрова', 'maria@gmail.com', '993-765-4321'),
(3, 'Алексей', 'Сидоров', 'aleksey@gmail.com', '917-555-5555');


INSERT INTO products  (product_id, name_product, description, price) VALUES
(1, 'молоко', 'пастеризованное, коровье', 75.00),
(2, 'яблоко красное', 'яблоко сезонное', 100.00),
(3, 'сок Я', 'сок мультифрукт', 130.00);


INSERT INTO baskets (basket_id, total_cost, link, user_id) VALUES
(1, 175.00, 'link_to_basket_1', 1),
(2, 230.00, 'link_to_basket_2', 2),
(3, 205.00, 'link_to_basket_3', 3);


INSERT INTO basket_items (basket_id, product_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 1),
(3, 3);


INSERT INTO shopping_histories (Orderes_id, basket_id,  user_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

INSERT INTO messages (messages_id , sender, recipient, text, basket_id) VALUES
(1,1, 2, 'link_to_basket_1', 1),
(2,2,1, 'link_to_basket_2', 2),
(3,3,1, 'link_to_basket_3', 3);

SELECT 
    b.basket_id,
    b.total_cost,
    b.link AS basket_link,
    u.name AS sender_name,
    p.product_id,
    p.name_product,
    p.price
FROM 
    baskets b
JOIN 
    basket_items bi ON b.basket_id = bi.basket_id
JOIN 
    products p ON bi.product_id = p.product_id
JOIN 
    users u ON b.user_id = u.user_id
WHERE 
    b.user_id = 2;
