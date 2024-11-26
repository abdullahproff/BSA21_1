
-----------------
-- Создание и сохранение нового списка

CREATE OR REPLACE FUNCTION create_new_list(
    user_id_ BIGINT,
    list_name_ VARCHAR,
    economy_sect VARCHAR,
    vol_from numeric,
    vol_to numeric,
	trans_date VARCHAR
)
RETURNS TABLE(share_name VARCHAR, last_price numeric) AS $$
DECLARE
    list_id_ BIGINT; -- Переменная для хранения ID списка
	count_shares INTEGER; -- Переменная для хранения количества найденных акций
BEGIN
    -- Проверка на существование списка
    IF EXISTS (SELECT list_id FROM Lists l WHERE l.user_id = user_id_ AND l.list_name = list_name_) THEN
        RAISE EXCEPTION 'Список с таким именем уже существует';
    END IF;
	
	-- Удаляем временную таблицу, если она существует, перед созданием новой
	-- Наверное, правильнее добавлять уникальный идинтификатор к названию временной таблицы при создании и в конце ее удалять.
    DROP TABLE IF EXISTS temp_found_shares;

	CREATE TEMP TABLE temp_found_shares AS 
		  SELECT s.share_id, s.share_name, s.last_price 
		  FROM Transactions tr
		  JOIN Shares s ON s.share_id = tr.share_id
		  JOIN Issuers i ON s.issuer_id = i.issuer_id
		  JOIN Economy_sectors es ON i.economy_sector_id = es.economy_sector_id
		  WHERE CAST(tr.created_at AS date) = to_date(trans_date, 'YYYY-MM-DD')
		  GROUP BY s.share_id, s.share_name, s.last_price, es.economy_sector
		  HAVING SUM(tr.volume) >= vol_from AND SUM(tr.volume) <= vol_to
		  AND es.economy_sector = economy_sect;

		-- Получаем количество найденных акций
		SELECT COUNT(*) INTO count_shares FROM temp_found_shares;
    -- Проверяем наличие акций
    IF count_shares = 0 THEN
        RAISE EXCEPTION 'Нет акций по этим параметрам';
    END IF;

    -- Создаем новый список и получаем его ID
    INSERT INTO Lists (user_id, list_name, economy_sector_id, daily_turnover_from, daily_turnover_to, number_of_items) 
	VALUES (
		user_id_,
		list_name_,
		(SELECT economy_sector_id FROM Economy_sectors AS ec WHERE economy_sector = economy_sect),
		vol_from,
		vol_to,
		count_shares)
    RETURNING list_id INTO list_id_;

    -- Вставляем найденные акции в List_items
    INSERT INTO List_items (list_id, share_id)
    SELECT list_id_, share_id FROM temp_found_shares;

RETURN QUERY SELECT temp_found_shares.share_name, temp_found_shares.last_price FROM temp_found_shares; -- Возвращаем найденные акции
END; $$
LANGUAGE plpgsql;



-- !!!! Перед запросами исправить даты на текущие !!!!

SELECT * FROM create_new_list(1, 'List_1', 'Financial', 150000, 2000000, '2024-11-25');
SELECT * FROM create_new_list(1, 'List_1', 'Financial', 150000, 2000000, '2024-11-25');  -- Проверка ошибки "Список уже существует"
SELECT * FROM create_new_list(1, 'List_2', 'Financial', 140000, 3000000, '2023-11-25');  -- Проверка ошибки "Пустой список"
SELECT * FROM create_new_list(1, 'List_2', 'IT', 140000, 3000000, '2024-11-25');
SELECT * FROM create_new_list(1, 'List_3', 'Retail', 150000, 2000000, '2024-11-25');  -- создание списков с одинаковым именем у разных пользователей
SELECT * FROM create_new_list(3, 'List_3', 'Retail', 150000, 2000000, '2024-11-25');

SELECT * FROM Users;
SELECT * FROM Economy_sectors;
SELECT * FROM Issuers;
SELECT * FROM Shares;
SELECT * FROM Lists;
SELECT * FROM List_items;
SELECT * FROM Transactions;


------------------
-- Получение уже созданного списка по названию

CREATE OR REPLACE FUNCTION get_shares_by_list_name(
    user_id_ BIGINT,
    list_name_ VARCHAR
)
RETURNS TABLE(share_name VARCHAR, last_price numeric) AS $$
DECLARE

BEGIN
	IF NOT EXISTS (SELECT l.list_name FROM Lists l WHERE l.user_id = user_id_ AND l.list_name = list_name_) THEN
    	RAISE EXCEPTION 'Списока с таким именем не существует';
	END IF;	
	
	RETURN QUERY
	SELECT s.share_name, s.last_price FROM Shares s
	JOIN List_items li ON s.share_id = li.share_id
	JOIN Lists l ON l.list_id = li.list_id
	WHERE l.user_id = user_id_ AND l.list_id = (SELECT list_id FROM Lists WHERE list_name = list_name_ AND user_id = user_id_);
	
END; $$
LANGUAGE plpgsql;

SELECT * FROM get_shares_by_list_name(1, 'List_1');
SELECT * FROM get_shares_by_list_name(1, 'List_2');
SELECT * FROM get_shares_by_list_name(2, 'List_2');  -- Проверка ошибки "Список не существует"
SELECT * FROM get_shares_by_list_name(1, 'List_3');  -- Два списка с одинаковым именем у разных пользователей
SELECT * FROM get_shares_by_list_name(3, 'List_3');


-------------------------------
-- Получение информации о списке

CREATE OR REPLACE FUNCTION get_list_info(
    user_id_ BIGINT,
    list_name_ VARCHAR
)
RETURNS TABLE(economy_sector VARCHAR, daily_turnover_from numeric, daily_turnover_to numeric, number_of_items INT) AS $$
DECLARE

BEGIN
	IF NOT EXISTS (SELECT l.list_name FROM Lists l WHERE l.user_id = user_id_ AND l.list_name = list_name_) THEN
    	RAISE EXCEPTION 'Списока с таким именем не существует';
	END IF;	
	
	RETURN QUERY
	SELECT es.economy_sector, l.daily_turnover_from, l.daily_turnover_to, l.number_of_items
	FROM Lists l
	JOIN Economy_sectors es ON l.economy_sector_id = es.economy_sector_id
	WHERE l.user_id = user_id_ AND l.list_id = (SELECT list_id FROM Lists WHERE list_name = list_name_ AND user_id = user_id_);
	
END; $$
LANGUAGE plpgsql;

SELECT * FROM get_list_info(1, 'List_1');
SELECT * FROM get_list_info(1, 'List_44');  -- Проверка ошибки "Список не существует"


-------------------------------

CREATE OR REPLACE FUNCTION get_shares_by_sector(ec_sec VARCHAR)
RETURNS TABLE(share_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT s.share_name
    FROM Shares s
    JOIN Issuers i ON s.issuer_id = i.issuer_id
    JOIN Economy_sectors es ON i.economy_sector_id = es.economy_sector_id
    WHERE es.economy_sector = ec_sec;
END; $$
LANGUAGE plpgsql;

SELECT * FROM get_shares_by_sector('IT');

