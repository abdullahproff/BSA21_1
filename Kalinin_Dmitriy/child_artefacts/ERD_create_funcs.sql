
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
	
-- 	IF (SELECT l.number_of_items FROM Lists l WHERE l.user_id = user_id_ AND l.list_name = list_name_) = 0 THEN
--     	RAISE EXCEPTION 'Список пустой';
-- 	END IF;	
	
	RETURN QUERY
	SELECT s.share_name, s.last_price FROM Shares s
	JOIN List_items li ON s.share_id = li.share_id
	JOIN Lists l ON l.list_id = li.list_id
	WHERE l.user_id = user_id_ AND l.list_id = (SELECT list_id FROM Lists WHERE list_name = list_name_ AND user_id = user_id_);
	
END; $$
LANGUAGE plpgsql;


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


SELECT ('Functions created') AS Message;

-------------------------------
-- Обновление списков раз в день

CREATE OR REPLACE FUNCTION update_lists_every_day()
RETURNS void AS $$
BEGIN

	DROP TABLE IF EXISTS temp_list_items;
	CREATE TEMP TABLE temp_list_items
	(
		list_items_id BIGSERIAL PRIMARY KEY,
		list_id BIGINT NOT NULL,
		share_id BIGINT NOT NULL
	-- 	FOREIGN KEY (list_id) REFERENCES Lists(list_id),
	-- 	FOREIGN KEY (share_id) REFERENCES Shares(share_id)
	);
	
	INSERT INTO temp_list_items(list_id, share_id)
	(
		SELECT 
			l.list_id,  -- Идентификатор списка из таблицы List
			t.share_id   -- Идентификатор акции
		FROM 
			Lists l
		JOIN 
			Shares s ON s.issuer_id IN (SELECT issuer_id FROM Issuers WHERE economy_sector_id = l.economy_sector_id)
		JOIN 
			Transactions t ON t.share_id = s.share_id
		WHERE 
			CAST(t.created_at AS date) = current_date - 1  -- Дата предыдущего торгового дня
	-- 		CAST(t.created_at AS date) = TO_DATE('2024-11-25', 'YYYY-MM-DD')  -- Дата транзакции
		GROUP BY 
			l.list_id, t.share_id
		HAVING 
			SUM(t.volume) >= l.daily_turnover_from AND SUM(t.volume) <= l.daily_turnover_to  -- Объем из списка
			AND l.economy_sector_id = l.economy_sector_id  -- Фильтрация по сектору экономики
	);

	-- Запись обновленного количества акций в Списки	
	LOCK TABLE Lists IN SHARE MODE;  -- https://sql-ex.ru/blogs/?/PostgreSQL_kak_obnovlJat_bolshie_tablicy.html
	UPDATE Lists l
	SET number_of_items = COALESCE(t.share_count, 0)
	FROM (
		SELECT l.list_id, COUNT(t.share_id) AS share_count
		FROM Lists l
		LEFT JOIN temp_list_items t ON l.list_id = t.list_id
		GROUP BY l.list_id
	) t
	WHERE l.list_id = t.list_id;

	-- удаление данных в list_items
	TRUNCATE list_items;
	-- изменение list_items
	LOCK TABLE List_items IN SHARE MODE;
	INSERT INTO List_items
	SELECT * FROM temp_list_items; -- обратная вставка строк

END; $$
LANGUAGE plpgsql;






