DROP TABLE IF EXISTS Accounts, Categories, Categories_MCC, Counterparties, Counterparties_Names, Transactions CASCADE;

-- Создаем таблицу счетов
CREATE TABLE Accounts (
    account_id INTEGER PRIMARY KEY,
    account_number INT8 UNIQUE NOT NULL,
    balance DECIMAL NOT NULL,
    currency VARCHAR NOT NULL
);

-- Создаем таблицу категорий
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    description TEXT
);

-- Создаем таблицу связи MCC-кодов с категориями
CREATE TABLE Categories_MCC (
    mcc_id INTEGER PRIMARY KEY,
    mcc INTEGER UNIQUE NOT NULL,
    category_id INTEGER REFERENCES Categories(category_id)
);

-- Создаем таблицу контрагентов
CREATE TABLE Counterparties (
    counterparty_id INTEGER PRIMARY KEY,
    title VARCHAR UNIQUE NOT NULL, -- Основное название контрагента
    type VARCHAR NOT NULL,         -- Тип контрагента (например, организация, банкомат)
    mcc INTEGER                    -- MCC-код
);

-- Создаем таблицу возможных названий контрагентов
CREATE TABLE Counterparties_Names (
    name_id INTEGER PRIMARY KEY,
    possible_name VARCHAR UNIQUE NOT NULL,   -- Возможное название контрагента
    counterparty_id INTEGER REFERENCES Counterparties(counterparty_id)
);

-- Создаем таблицу транзакций
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES Accounts(account_id),
    date DATE NOT NULL,
    amount DECIMAL NOT NULL,
    type VARCHAR NOT NULL CHECK (type IN ('income', 'expense')),
    counterparty_id INTEGER REFERENCES Counterparties_Names(name_id),
    mcc_id INTEGER REFERENCES Categories_MCC(mcc_id)
);


-----------

INSERT INTO Accounts (account_id, account_number, balance, currency) VALUES
(1, '1234567890', 150000.00, 'RUB'),
(2, '9876543210', 50000.00, 'USD');

INSERT INTO Categories (category_id, name, description) VALUES
(1, 'Супермаркеты', 'Покупки в супермаркетах'),
(2, 'Развлечения', 'Кино, театры, концерты'),
(3, 'Транспорт', 'Общественный транспорт и такси'),
(4, 'Снятие наличных', 'Операции в банкоматах'),
(5, 'Переводы', 'Денежные переводы другим людям');


INSERT INTO Categories_MCC (mcc_id, mcc, category_id) VALUES
(1, 5411, 1), -- Супермаркеты
(2, 5812, 2), -- Развлечения
(3, 4121, 3), -- Транспорт
(4, 4789, 3), -- Транспорт
(5, 6011, 4), -- Снятие наличных
(6, 4829, 5); -- Переводы



INSERT INTO Counterparties (counterparty_id, title, type, mcc) VALUES
(1, 'Четверочка', 'organization', 5411),
(2, 'МосМетро', 'organization', 4789),
(3, 'ЯТакси', 'organization', 4121),
(4, 'Банкомат Сбербанка', 'atm', 6011),
(5, 'Перевод на Иванова И.И.', 'individual', 4829),
(6, 'Пятёрочка', 'organization', 5411),
(7, 'Кафе Ромашка', 'organization', 5812);



INSERT INTO Counterparties_Names (name_id, possible_name, counterparty_id) VALUES
(1, 'Четверочка', 1),
(2, 'Четверочка доставка', 1),
(3, 'Metro', 2),
(4, 'МосМетро', 2),
(5, 'Taxi', 3),
(6, 'ЯТакси', 3),
(7, 'Банкомат Сбербанка', 4),
(8, 'Перевод на Иванова И.И.', 5),
(9, 'Пятёрочка', 6),
(10, 'Кафе Ромашка', 7);

INSERT INTO Transactions (transaction_id, account_id, date, amount, type, counterparty_id, mcc_id) VALUES
-- Покупки
(1, 1, '2024-11-01', -1200.00, 'expense', 1, 1), -- Четверочка
(2, 1, '2024-11-05', -3000.00, 'expense', 9, 1), -- Пятёрочка
-- Развлечения
(3, 1, '2024-11-08', -1500.00, 'expense', 10, 2), -- Кафе Ромашка
-- Транспорт
(4, 1, '2024-11-10', -1000.00, 'expense', 3, 4), -- Метро
(5, 1, '2024-11-12', -600.00, 'expense', 5, 3), -- Такси
-- Переводы
(6, 1, '2024-11-13', -5000.00, 'expense', 8, 6), -- Перевод на Иванова И.И.
-- Снятие наличных
(7, 1, '2024-11-18', -2500.00, 'expense', 7, 5); -- Банкомат Сбербанка
-------------------------------

----Разбивка транзакций на категории и суммы
SELECT c.name AS category, SUM(t.amount) AS total_spent
FROM Transactions t
LEFT JOIN Categories_MCC cm ON t.mcc_id = cm.mcc_id
LEFT JOIN Categories c ON cm.category_id = c.category_id
WHERE t.type = 'expense'
GROUP BY c.name
ORDER BY total_spent DESC;

----Разбивка транзакций по контрагентам
SELECT cp.title AS counterparty, SUM(t.amount) AS total_spent
FROM Transactions t
JOIN Counterparties_Names cn ON t.counterparty_id = cn.name_id
JOIN Counterparties cp ON cn.counterparty_id = cp.counterparty_id
GROUP BY cp.title
ORDER BY total_spent DESC;

----Транзакции за определенный период
SELECT t.date, t.amount, cp.title AS counterparty, c.name AS category
FROM Transactions t
LEFT JOIN Counterparties_Names cn ON t.counterparty_id = cn.name_id
LEFT JOIN Counterparties cp ON cn.counterparty_id = cp.counterparty_id
LEFT JOIN Categories_MCC cm ON t.mcc_id = cm.mcc_id
LEFT JOIN Categories c ON cm.category_id = c.category_id
WHERE t.date BETWEEN '2024-11-01' AND '2024-11-30'
ORDER BY t.date ASC;
