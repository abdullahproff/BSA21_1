DROP TABLE IF EXISTS Accounts, Categories, Category_MCC, Counterparties, Counterparty_Names, Transactions CASCADE;


-- Создаем таблицу счетов
CREATE TABLE Accounts (
    account_number INT8 PRIMARY KEY,
    balance DECIMAL NOT NULL,
    currency VARCHAR NOT NULL
);

-- Создаем таблицу категорий
CREATE TABLE Categories (
    name VARCHAR PRIMARY KEY,
    description TEXT
);

-- Создаем таблицу связи MCC-кодов с категориями
CREATE TABLE Category_MCC (
    mcc INTEGER PRIMARY KEY,
    category_name VARCHAR REFERENCES Categories(name)
);

-- Создаем таблицу контрагентов
CREATE TABLE Counterparties (
    title VARCHAR PRIMARY KEY, -- Основное название контрагента
    type VARCHAR NOT NULL,     -- Тип контрагента (например, организация, банкомат)
    mcc INTEGER                -- MCC-код
);

-- Создаем таблицу возможных названий контрагентов
CREATE TABLE Counterparty_Names (
    possible_name VARCHAR PRIMARY KEY,   -- Возможное название контрагента
    counterparty_title VARCHAR REFERENCES Counterparties(title)
);

-- Создаем таблицу транзакций
CREATE TABLE Transactions (
    account_number INT8 REFERENCES Accounts(account_number),
    date DATE NOT NULL,
    amount DECIMAL NOT NULL,
    type VARCHAR NOT NULL CHECK (type IN ('income', 'expense')),
    counterparty VARCHAR NOT NULL REFERENCES Counterparty_Names(possible_name), -- Связь с контрагентом через возможные названия
    mcc INTEGER REFERENCES Category_MCC(mcc) -- Привязка к категории через MCC
);


----------------------------------
INSERT INTO Accounts (account_number, balance, currency) VALUES
('1234567890', 150000.00, 'RUB'),
('9876543210', 50000.00, 'USD');


INSERT INTO Categories (name, description) VALUES
('Супермаркеты', 'Покупки в супермаркетах'),
('Развлечения', 'Кино, театры, концерты'),
('Транспорт', 'Общественный транспорт и такси'),
('Снятие наличных', 'Операции в банкоматах'),
('Переводы', 'Денежные переводы другим людям');



INSERT INTO Category_MCC (mcc, category_name) VALUES
(5411, 'Супермаркеты'),
(5812, 'Развлечения'),
(4121, 'Транспорт'),
(4789, 'Транспорт'),
(6011, 'Снятие наличных'),
(4829, 'Переводы');


INSERT INTO Counterparties (title, type, mcc) VALUES
('Четверочка', 'organization', 5411),
('Метро', 'organization', 4789),
('Такси', 'organization', 4121),
('Банкомат Сбербанка', 'atm', 6011),
('Перевод на Иванова И.И.', 'individual', 4829),
('Пятёрочка', 'organization', 5411),
('Кафе Ромашка', 'organization', 5812);


INSERT INTO Counterparty_Names (possible_name, counterparty_title) VALUES
('Четверочка', 'Четверочка'),
('Четверочка доставка', 'Четверочка'),
('Metro', 'Метро'),
('МосМетро', 'Метро'),
('Taxi', 'Такси'),
('ЯТакси', 'Такси'),
('Банкомат Сбербанка', 'Банкомат Сбербанка'),
('Перевод на Иванова И.И.', 'Перевод на Иванова И.И.'),
('Пятёрочка', 'Пятёрочка'),
('Кафе Ромашка', 'Кафе Ромашка');


INSERT INTO Transactions (account_number, date, amount, type, counterparty, mcc) VALUES
-- Покупки
('1234567890', '2024-11-01', -1200.00, 'expense', 'Четверочка', 5411),
('1234567890', '2024-11-05', -3000.00, 'expense', 'Пятёрочка', 5411),
-- Развлечения
('1234567890', '2024-11-08', -1500.00, 'expense', 'Кафе Ромашка', 5812),
-- Транспорт
('1234567890', '2024-11-10', -1000.00, 'expense', 'МосМетро', 4789),
('1234567890', '2024-11-12', -600.00, 'expense', 'ЯТакси', 4121),
-- Переводы
('1234567890', '2024-11-13', -5000.00, 'expense', 'Перевод на Иванова И.И.', 4829),
-- Снятие наличных
('1234567890', '2024-11-18', -2500.00, 'expense', 'Банкомат Сбербанка', 6011);



-----------------
--Разбивка транзакций на категории и сумма
SELECT c.name AS category, SUM(t.amount) AS total_spent
FROM Transactions t
LEFT JOIN Category_MCC cm ON t.mcc = cm.mcc
LEFT JOIN Categories c ON cm.category_name = c.name
WHERE t.type = 'expense'
GROUP BY c.name
ORDER BY total_spent DESC;

--Разбивка транзакций по контрагентам
SELECT c.title AS counterparty, SUM(t.amount) AS total_spent
FROM Transactions t
JOIN Counterparty_Names cn ON t.counterparty = cn.possible_name
JOIN Counterparties c ON cn.counterparty_title = c.title
GROUP BY c.title
ORDER BY total_spent DESC;

---Транзакции за определенный период
SELECT t.date, t.amount, t.counterparty, c.title AS main_counterparty, cat.name AS category
FROM Transactions t
LEFT JOIN Counterparty_Names cn ON t.counterparty = cn.possible_name
LEFT JOIN Counterparties c ON cn.counterparty_title = c.title
LEFT JOIN Category_MCC cm ON t.mcc = cm.mcc
LEFT JOIN Categories cat ON cm.category_name = cat.name
WHERE t.date BETWEEN '2024-11-01' AND '2024-11-30'
ORDER BY t.date ASC;



