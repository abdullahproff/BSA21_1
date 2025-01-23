

-- Тестовые запросы, для наглядности нужно запускать по очереди


-----------------
-- Создание и сохранение нового списка


-- !!!! Перед запросами исправить даты на текущие !!!!

SELECT * FROM create_new_list(1, 'List_1', 'Financial', 150000, 2000000, '2024-11-25');
SELECT * FROM create_new_list(1, 'List_1', 'Financial', 150000, 2000000, '2024-11-25');  -- Проверка ошибки "Список уже существует"
SELECT * FROM create_new_list(1, 'List_2', 'Financial', 140000, 3000000, '2023-11-25');  -- Проверка ошибки "Пустой список"
SELECT * FROM create_new_list(1, 'List_2', 'IT', 140000, 3000000, '2024-11-25');
SELECT * FROM create_new_list(1, 'List_3', 'Retail', 150000, 2000000, '2024-11-25');  -- создание списков с одинаковым именем у разных пользователей
SELECT * FROM create_new_list(3, 'List_3', 'Retail', 150000, 2000000, '2024-11-25');

-- Эти для наглядности, можно не запускать
SELECT * FROM Users;
SELECT * FROM Economy_sectors;
SELECT * FROM Issuers;
SELECT * FROM Shares;
SELECT * FROM Lists;
SELECT * FROM List_items;
SELECT * FROM Transactions;


------------------
-- Получение уже созданного списка по названию

SELECT * FROM get_shares_by_list_name(1, 'List_1');
SELECT * FROM get_shares_by_list_name(1, 'List_2');
SELECT * FROM get_shares_by_list_name(2, 'List_2');  -- Проверка ошибки "Список не существует"
SELECT * FROM get_shares_by_list_name(1, 'List_3');  -- Два списка с одинаковым именем у разных пользователей
SELECT * FROM get_shares_by_list_name(3, 'List_3');


-------------------------------
-- Получение информации о списке

SELECT * FROM get_list_info(1, 'List_1');
SELECT * FROM get_list_info(1, 'List_44');  -- Проверка ошибки "Список не существует"


-------------------------------
-- Ежедневное обновление данных

SELECT * FROM update_lists_every_day();

