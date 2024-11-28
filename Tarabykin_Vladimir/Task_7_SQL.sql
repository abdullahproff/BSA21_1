DROP TABLE IF EXISTS account, category, counterparty, category_mcc, counterparty_names, transaction CASCADE;

-- Создаем таблицу счетов
CREATE TABLE Account (
    account_number VARCHAR PRIMARY KEY,
    balance NUMERIC NOT NULL,
    currency VARCHAR NOT NULL
);

-- Создаем таблицу категорий
CREATE TABLE Category (
    name VARCHAR PRIMARY KEY,
    description TEXT
);

-- Создаем таблицу связи MCC-кодов с категориями
CREATE TABLE Category_MCC (
    mcc INTEGER PRIMARY KEY,
    category_name VARCHAR REFERENCES Category(name)
);

-- Создаем таблицу контрагентов
CREATE TABLE Counterparty (
    title VARCHAR PRIMARY KEY, -- Основное название контрагента
    type VARCHAR NOT NULL,     -- Тип контрагента (например, организация, банкомат)
    mcc INTEGER NOT NULL       -- MCC-код
);

-- Создаем таблицу возможных названий контрагентов
CREATE TABLE Counterparty_Names (
    possible_name VARCHAR PRIMARY KEY,   -- Возможное название контрагента
    counterparty_title VARCHAR REFERENCES Counterparty(title)
);

-- Создаем таблицу транзакций
CREATE TABLE Transaction (
    account_number VARCHAR REFERENCES Account(account_number),
    date DATE NOT NULL,
    amount NUMERIC NOT NULL,
    type VARCHAR NOT NULL CHECK (type IN ('income', 'expense')),
    counterparty VARCHAR NOT NULL REFERENCES Counterparty_Names(possible_name), -- Связь с контрагентом через возможные названия
    mcc INTEGER REFERENCES Category_MCC(mcc) -- Привязка к категории через MCC
);

-----------------------------------------

INSERT INTO Account (account_number, balance, currency) VALUES
('1234567890', 150000.00, 'RUB'),
('9876543210', 50000.00, 'USD');

INSERT INTO Category (name, description) VALUES
('Supermarkets', 'All supermarket purchases'),
('Entertainment', 'Cinema, theaters, etc.'),
('Transport', 'Public transport and taxis');


INSERT INTO Category_MCC (mcc, category_name) VALUES
(5411, 'Supermarkets'),
(7832, 'Entertainment'),
(4121, 'Transport'),
(4789, 'Transport');

INSERT INTO Counterparty (title, type, mcc) VALUES
('Четверочка', 'organization', 5411),
('Метро', 'organization', 4789),
('Такси', 'organization', 4121);

INSERT INTO Counterparty_Names (possible_name, counterparty_title) VALUES
('Четверочка', 'Четверочка'),
('Четверочка доставка', 'Четверочка'),
('Metro', 'Метро'),
('Метро', 'Метро'),
('Taxi', 'Такси'),
('Такси', 'Такси');

INSERT INTO Transaction (account_number, date, amount, type, counterparty, mcc) VALUES
('1234567890', '2024-11-01', -1200.00, 'expense', 'Четверочка', 5411),
('1234567890', '2024-11-02', -800.00, 'expense', 'Четверочка доставка', 5411),
('1234567890', '2024-11-10', -1000.00, 'expense', 'Метро', 4789),
('1234567890', '2024-11-12', -600.00, 'expense', 'Такси', 4121);

-----------------

--------------Разбивка транзакций на категории и суммы по каждой категории
SELECT c.name AS category, SUM(t.amount) AS total_spent
FROM Transaction t
JOIN Category_MCC cm ON t.mcc = cm.mcc
JOIN Category c ON cm.category_name = c.name
WHERE t.type = 'expense'
GROUP BY c.name
ORDER BY total_spent DESC;

-----------Разбивка транзакций по контрагентам и суммы по каждому контрагенту
SELECT c.title AS main_counterparty, SUM(t.amount) AS total_spent
FROM Transaction t
JOIN Counterparty_Names cn ON t.counterparty = cn.possible_name
JOIN Counterparty c ON cn.counterparty_title = c.title
WHERE t.type = 'expense'
GROUP BY c.title
ORDER BY total_spent DESC;

---------Все транзакции за определенный период с детализацией контрагентов
SELECT t.date, t.amount, t.counterparty, c.title AS main_counterparty
FROM Transaction t
JOIN Counterparty_Names cn ON t.counterparty = cn.possible_name
JOIN Counterparty c ON cn.counterparty_title = c.title
WHERE t.date BETWEEN '2024-11-01' AND '2024-11-15'
ORDER BY t.date ASC;



