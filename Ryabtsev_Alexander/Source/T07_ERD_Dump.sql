DROP SCHEMA IF EXISTS redavero CASCADE;

CREATE SCHEMA redavero;

SET SEARCH_PATH TO redavero;


-- СОЗДАНИЕ СУЩНОСТЕЙ
CREATE TABLE addresses
(
    address_id      SERIAL PRIMARY KEY,
    name            VARCHAR(127),
    postcode        VARCHAR(31),
    city            VARCHAR(127) NOT NULL,
    street          VARCHAR(127),
    building_number VARCHAR(127),
    entryway        VARCHAR(31),
    floor           VARCHAR(31),
    apartment       VARCHAR(31),
    intercom        VARCHAR(31)
);

CREATE TABLE users
(
    user_id             SERIAL PRIMARY KEY,
    username            VARCHAR(127) UNIQUE                                                             NOT NULL,
    surname             VARCHAR(127),
    name                VARCHAR(127),
    patronymic          VARCHAR(127),
    birth_date          DATE,
    gender              VARCHAR(1) CHECK ( gender IN ('M', 'F') ),
    phone_number        VARCHAR(31) CHECK ( phone_number ~ '^\+?[0-9]{2,}$' ),
    email               VARCHAR(255) CHECK ( email ~ '^[A-Za-z0-9_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' ) NOT NULL,
    shipping_address_id INT,
    CONSTRAINT fk_users_addresses FOREIGN KEY (shipping_address_id) REFERENCES addresses (address_id) ON DELETE SET NULL
);

CREATE TABLE products
(
    product_id  SERIAL PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    unit        VARCHAR(31)    NOT NULL,
    price       DECIMAL(17, 4) NOT NULL,
    photo       VARCHAR(255),
    description TEXT,
    category    VARCHAR(255) -- TODO: Иерархическая структура
);

CREATE TABLE carts
(
    cart_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    CONSTRAINT fk_carts_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE cart_items
(
    cart_id       INT                                         NOT NULL,
    product_id    INT                                         NOT NULL,
    item_quantity DECIMAL(17, 4) CHECK ( item_quantity >= 0 ) NOT NULL,
    CONSTRAINT fk_cart_items_carts FOREIGN KEY (cart_id) REFERENCES carts (cart_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT pk_cart_items PRIMARY KEY (cart_id, product_id)
);

CREATE TABLE warehouses
(
    warehouse_id SERIAL PRIMARY KEY,
    address_id   INT                 NOT NULL,
    name         VARCHAR(255) UNIQUE NOT NULL,
    CONSTRAINT fk_warehouses_addresses FOREIGN KEY (address_id) REFERENCES addresses (address_id) ON DELETE SET NULL
);

CREATE TYPE reservation_status_enum AS ENUM ('active', 'paid', 'cancelled', 'expired');

CREATE TABLE warehouse_stocks
(
    warehouse_stock_id   SERIAL PRIMARY KEY,
    cart_id              INT,
    product_id           INT                                               NOT NULL,
    warehouse_id         INT                                               NOT NULL,
    operation_type       VARCHAR(1) CHECK ( operation_type IN ('+', '-') ) NOT NULL,
    operation_quantity   DECIMAL(17, 4)                                    NOT NULL,
    updated_at           TIMESTAMPTZ DEFAULT NOW()                         NOT NULL,
    reservation_status   reservation_status_enum,
    reservation_interval INTERVAL,
    CONSTRAINT fk_warehouse_stocks_carts FOREIGN KEY (cart_id) REFERENCES carts (cart_id) ON DELETE NO ACTION,
    CONSTRAINT fk_warehouse_stocks_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT fk_warehouse_stocks_warehouses FOREIGN KEY (warehouse_id) REFERENCES warehouses (warehouse_id) ON DELETE NO ACTION
);


-- ДОБАВЛЕНИЕ КОРТЕЖЕЙ
INSERT INTO users (username, surname, name, patronymic, gender, phone_number, email)
VALUES ('user1', 'Р.', 'Александр', 'Анатольевич', 'M', '+98765432109', 'user1@mail.ru'),
       ('user2', NULL, NULL, NULL, NULL, NULL, 'user2@mail.ru'),
       ('user3', NULL, NULL, NULL, NULL, NULL, 'user3@mail.ru');

INSERT INTO products(name, unit, price, description, category)
VALUES ('Кефир', 'шт', 50, '500 гр', 'Продукты / Молочные'),
       ('Полбатона', 'шт', 20, '200 гр', 'Продукты / Хлеб'),
       ('Икарус', 'шт', 3333, '1 шт', 'Игрушки / Транспорт'),
       ('Кефир', 'шт', 80, '900 гр', 'Продукты / Молочные');

INSERT INTO addresses(name, postcode, city)
VALUES ('Основной', '101000', 'г. Москва');

INSERT INTO warehouses(address_id, name)
VALUES (1, 'МегаМаркет');

INSERT INTO warehouse_stocks(product_id, warehouse_id, operation_type, operation_quantity)
VALUES (1, 1, '+', 1),
       (2, 1, '+', 2),
       (3, 1, '+', 3);

INSERT INTO carts(user_id)
VALUES (1),
       (2),
       (3);


-- ФУНКЦИЯ ПРОВЕРКИ АКТУАЛЬНОСТИ РЕЗЕРВА
CREATE OR REPLACE PROCEDURE status_check(p_id INT, wh_id INT)
AS
$$
BEGIN
    UPDATE warehouse_stocks
    SET reservation_status = 'expired'
    WHERE product_id = p_id
      AND warehouse_id = wh_id
      AND reservation_status = 'active'
      AND (updated_at + reservation_interval) < NOW();

END;
$$ LANGUAGE plpgsql;


-- ФУНКЦИЯ ПРОВЕРКИ НАЛИЧИЯ ТОВАРА НА СКЛАДЕ
CREATE OR REPLACE FUNCTION availability_check(p_id INT, wh_id INT, required_qty DECIMAL)
    RETURNS BOOLEAN AS
$$
DECLARE
    available_qty DECIMAL;
BEGIN
    SELECT SUM(operation_quantity)
    INTO available_qty
    FROM warehouse_stocks
    WHERE product_id = p_id
      AND warehouse_id = wh_id
      AND (reservation_status IS NULL OR reservation_status NOT IN ('cancelled', 'expired'));

    IF available_qty IS NOT NULL AND available_qty >= required_qty THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- ФУНКЦИЯ РЕЗЕРВИРОВАНИЯ НА СКЛАДЕ
CREATE OR REPLACE FUNCTION handle_reserve_cart()
    RETURNS TRIGGER AS
$$
DECLARE
    wh_stocks_target INT;
    delta_quantity   DECIMAL;
    wh_id            INT      := 1; -- TODO: Добавить логику выбора склада
    res_interval     INTERVAL := INTERVAL '1 hour';
BEGIN
    CALL status_check(OLD.product_id, wh_id);

    IF TG_OP = 'INSERT' THEN
        IF NOT availability_check(NEW.product_id, wh_id, NEW.item_quantity) THEN
            RAISE EXCEPTION 'Not enough product to reserve: Product ID %', NEW.product_id;
        END IF;

        INSERT INTO warehouse_stocks(cart_id, product_id, warehouse_id, operation_type, operation_quantity,
                                     reservation_status, reservation_interval)
        VALUES (NEW.cart_id,
                NEW.product_id,
                wh_id,
                '-',
                NEW.item_quantity * (-1), -- ЗНАК МИНУС, Т.К. СПИСАНИЕ СО СКЛАДА
                'active',
                res_interval);
    END IF;

    IF TG_OP = 'UPDATE' THEN
        IF NEW.item_quantity <> OLD.item_quantity THEN
            SELECT warehouse_stock_id
            INTO wh_stocks_target
            FROM warehouse_stocks
            WHERE cart_id = OLD.cart_id
              AND product_id = OLD.product_id
              AND warehouse_id = wh_id
              AND reservation_status = 'active'
              AND operation_quantity = OLD.item_quantity * (-1);

            IF NEW.item_quantity > OLD.item_quantity THEN
                IF wh_stocks_target IS NOT NULL THEN
                    delta_quantity := NEW.item_quantity - OLD.item_quantity;

                    IF NOT availability_check(NEW.product_id, wh_id, delta_quantity) THEN
                        RAISE EXCEPTION 'Not enough product to reserve: Product ID %', NEW.product_id;
                    END IF;

                    UPDATE warehouse_stocks
                    SET operation_quantity = operation_quantity - delta_quantity, -- УВЕЛИЧЕНИЕ РЕЗЕРВА
                        updated_at         = NOW()
                    WHERE warehouse_stock_id = wh_stocks_target;

                ELSE
                    IF NOT availability_check(NEW.product_id, wh_id, NEW.item_quantity) THEN
                        RAISE EXCEPTION 'Not enough product to reserve: Product ID %', NEW.product_id;
                    END IF;

                    INSERT INTO warehouse_stocks(cart_id, product_id, warehouse_id, operation_type, operation_quantity,
                                                 reservation_status, reservation_interval)
                    VALUES (NEW.cart_id,
                            NEW.product_id,
                            wh_id,
                            '-',
                            NEW.item_quantity * (-1), -- ЗНАК МИНУС, Т.К. СПИСАНИЕ СО СКЛАДА
                            'active',
                            res_interval);
                END IF;

            ELSE
                IF NEW.item_quantity = 0 THEN
                    IF wh_stocks_target IS NOT NULL THEN
                        UPDATE warehouse_stocks
                        SET reservation_status = 'cancelled'
                        WHERE warehouse_stock_id = wh_stocks_target;
                    END IF;

                    DELETE
                    FROM cart_items
                    WHERE cart_id = NEW.cart_id
                      AND product_id = NEW.product_id;

                    RETURN NULL; -- УДАЛЕНИЕ ПОЗИЦИИ КОРЗИНЫ ПРИ УМЕНЬШЕНИИ КОЛИЧЕСТВА ДО НУЛЯ

                ELSE
                    IF wh_stocks_target IS NOT NULL THEN
                        delta_quantity := OLD.item_quantity - NEW.item_quantity;

                        UPDATE warehouse_stocks
                        SET operation_quantity = operation_quantity + delta_quantity, -- ЗНАК ПЛЮС, Т.К. РЕЗЕРВ УМЕНЬШАЕТСЯ
                            updated_at         = NOW()
                        WHERE warehouse_stock_id = wh_stocks_target;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN
        UPDATE warehouse_stocks
        SET reservation_status = 'cancelled'
        WHERE cart_id = OLD.cart_id
          AND product_id = OLD.product_id
          AND warehouse_id = wh_id
          AND reservation_status = 'active';

        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ТРИГГЕР РЕЗЕРВИРОВАНИЯ ТОВАРА ПОСЛЕ ИЗМЕНЕНИЙ В КОРЗИНЕ
CREATE OR REPLACE TRIGGER trigger_reserve_cart
    BEFORE INSERT OR UPDATE OR DELETE
    ON cart_items
    FOR EACH ROW
EXECUTE FUNCTION handle_reserve_cart();


-- ДОБАВЛЕНИЕ ТОВАРОВ В КОРЗИНУ (ПОСЛЕ СОЗДАНИЯ ТРИГГЕРОВ И ФУНКЦИЙ)
INSERT INTO cart_items(cart_id, product_id, item_quantity)
VALUES (1, 1, 1);

INSERT INTO cart_items(cart_id, product_id, item_quantity)
VALUES (1, 2, 1);

INSERT INTO cart_items(cart_id, product_id, item_quantity)
VALUES (2, 3, 1);

UPDATE cart_items
SET item_quantity = item_quantity + 1
WHERE cart_id = 2
  AND product_id = 3;

UPDATE cart_items
SET item_quantity = item_quantity - 1
WHERE cart_id = 2
  AND product_id = 3;

DELETE
FROM cart_items
WHERE cart_id = 2
  AND product_id = 3;


-- ПРОСМОТР КОРЗИНЫ ПОЛЬЗОВАТЕЛЯ
SELECT surname                                                                  AS Фамилия,
       users.name                                                               AS Имя,
       patronymic                                                               AS Отчество,
       email                                                                    AS Эл_почта,
       products.name                                                            AS Товар,
       products.unit                                                            AS Ед_изм,
       item_quantity                                                            AS Количество,
       products.price                                                           AS Цена_за_ед,
       COALESCE(SUM(operation_quantity), 0)::NUMERIC(17, 4)                     AS Свободный_остаток,
       CASE
           WHEN SUM(operation_quantity) IS NULL
               OR SUM(operation_quantity) < 0 THEN 'Нет'
           ELSE 'Да'
           END                                                                  AS Достаточно_для_заказа,
       (products.price * item_quantity)::NUMERIC(17, 4)                         AS Сумма,
       (SUM(cart_items.item_quantity) OVER ())::NUMERIC(17, 4)                  AS Количество_Общее,
       (SUM(products.price * cart_items.item_quantity) OVER ())::NUMERIC(17, 4) AS Сумма_Общая
FROM products
         INNER JOIN cart_items ON products.product_id = cart_items.product_id
         INNER JOIN carts ON cart_items.cart_id = carts.cart_id
         INNER JOIN users ON carts.user_id = users.user_id
         LEFT JOIN warehouse_stocks ON products.product_id = warehouse_stocks.product_id
         LEFT JOIN warehouses ON warehouse_stocks.warehouse_id = warehouses.warehouse_id
WHERE users.user_id = 1           -- ID пользователя
  AND warehouses.warehouse_id = 1 -- ID склада
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 11;
