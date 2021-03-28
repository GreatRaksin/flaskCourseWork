-- 5.1. Разработать запросы на языке SQL для создания базы данных, указать место хранения, размер и названия файлов базы данных.
CREATE DATABASE course_work;
-- 5.2. Разработать запросы на языке SQL для создания всех таблиц (с учетом ограничений целостности данных, ограничений на значения, значений по умолчанию и т.п.).

CREATE TABLE IF NOT EXISTS public.countries
(
    id   integer NOT NULL,
    name character varying(255)
);

CREATE TABLE IF NOT EXISTS public.genres
(
    id   integer NOT NULL,
    name character varying(255)
);

CREATE TABLE IF NOT EXISTS public.bands
(
    id          integer NOT NULL,
    date_of_est date,
    name        character varying(255),
    country_id  integer,
    genre_id    integer
);

CREATE TABLE IF NOT EXISTS public.songs
(
    id               integer NOT NULL,
    date_of_creation date,
    name             character varying(255),
    band_id          integer NOT NULL,
    album_id         integer NOT NULL,
    price            numeric(19, 2)
);

CREATE TABLE IF NOT EXISTS public.albums
(
    id               integer NOT NULL,
    name             character varying(255),
    date_of_creation date,
    band_id          integer,
    genre_id         integer NOT NULL
);

CREATE TABLE IF NOT EXISTS public.customers
(
    id            integer NOT NULL,
    date_of_birth date,
    email         character varying(255),
    full_name     character varying(255),
    phone         character varying(255)
);

CREATE TABLE IF NOT EXISTS public.orders
(
    id          integer NOT NULL,
    created_at  timestamp without time zone,
    description character varying(255),
    issued_at   timestamp without time zone,
    customer_id integer
);

CREATE TABLE IF NOT EXISTS public.ordered_songs
(
    order_id integer NOT NULL,
    song_id  integer NOT NULL
);

-- 5.3. Разработать запросы на языке SQL для создания индексов и ограничений для таблиц БД.
CREATE SEQUENCE IF NOT EXISTS band_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS album_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS song_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS genre_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS country_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS customer_seq START 1 INCREMENT 1;
CREATE SEQUENCE IF NOT EXISTS order_seq START 1 INCREMENT 1;

ALTER TABLE ONLY public.bands
    ADD CONSTRAINT band_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_p_key PRIMARY KEY (id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_p_key PRIMARY KEY (id);

-- 5.4. Создать схему данных (диаграмму), включить в нее необходимые таблицы. Все связи между таблицами должны иметь свойства «Обеспечение целостности данных». Определить свойства «Каскадное обновление», «Каскадное удаление» в соответствии с бизнес-правилами.
ALTER TABLE ONLY public.bands
    ADD CONSTRAINT bfec8a344ef19318d53f3e3b5b9bf0 FOREIGN KEY (country_id)
        REFERENCES public.countries (id) ON DELETE CASCADE,
    ADD CONSTRAINT f7e9360629c1c4730062ededce1607 FOREIGN KEY (genre_id)
        REFERENCES public.genres (id) ON DELETE CASCADE;
ALTER TABLE ONLY public.albums
    ADD CONSTRAINT a18ef6a8465ec46228037f4843011e FOREIGN KEY (band_id)
        REFERENCES public.bands (id) ON DELETE CASCADE,
    ADD CONSTRAINT d4fb578aa0cb5d4431c2cbb44ee11c FOREIGN KEY (genre_id)
        REFERENCES public.genres (id) ON DELETE CASCADE;
ALTER TABLE ONLY public.songs
    ADD CONSTRAINT ff4699083ce51de0dabcfad5edc4c FOREIGN KEY (band_id)
        REFERENCES public.bands (id) ON DELETE CASCADE,
    ADD CONSTRAINT fb773434a2f5f424a808c8f6afaab6 FOREIGN KEY (album_id)
        REFERENCES public.albums (id) ON DELETE CASCADE;
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT ec1f9324753048c0096d036a694f86 FOREIGN KEY (customer_id)
        REFERENCES public.customers (id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ordered_songs
    ADD CONSTRAINT cf6ee109f1745135cdb84a944165a FOREIGN KEY (song_id)
        REFERENCES public.songs (id) ON DELETE CASCADE,
    ADD CONSTRAINT c8420ccbb1fd473c7d99c84b5ef66 FOREIGN KEY (order_id)
        REFERENCES public.orders (id) ON DELETE CASCADE;


CREATE INDEX bands_country_id ON public.bands USING btree (country_id);
CREATE INDEX songs_band_id ON public.songs USING btree (band_id);

-- 5.5. Разработать запросы на языке SQL для заполнения данными таблиц-справочников и таблицы, соответствующей агрегированной сущности. Количество записей в справочниках должно быть не менее 3-4, а в таблице, соответствующей агрегированной сущности, - не менее 10
-- genres
INSERT INTO genres(id, name)
VALUES (1, 'Rock'),
       (2, 'Metal'),
       (3, 'Pop');

-- countries
INSERT INTO countries(id, name)
VALUES (1, 'USA'),
       (2, 'Germany'),
       (3, 'Sweden'),
       (4, 'UK'),
       (5, 'France'),
       (6, 'Finland');

-- bands
INSERT INTO bands(id, date_of_est, name, country_id, genre_id)
VALUES (1, date('1999-12-01'), 'Sabaton', 3, 1),
       (2, date('1994-01-01'), 'Rammstein', 2, 1),
       (3, date('1996-12-01'), 'Nightwish', 6, 2),
       (4, date('2004-07-01'), 'Lafee', 2, 1),
       (5, date('1965-12-01'), 'Scorpions', 2, 1),
       (6, date('1963-02-4'), 'Alice Cooper', 1, 1),
       (7, date('2008-11-12'), 'Noir Désir', 5, 1),
       (8, date('2001-12-01'), 'GIMS', 5, 3);

-- albums
INSERT INTO albums(id, name, date_of_creation, band_id, genre_id)
VALUES (1, 'Coat of arms', date('2010-05-21'), 1, 2),
       (2, 'Primo Victoria', date('2005-03-04'), 1, 2),
       (3, 'Mutter', date('2001-04-02'), 2, 2),
       (4, 'Once', date('2004-06-07'), 3, 2),
       (5, 'Jetzt erst recht', date('2007-06-07'), 4, 1),
       (6, 'Crazy world', date('1990-11-06'), 5, 1),
       (7, 'Trash', date('1989-07-25'), 6, 1),
       (8, 'Des Visages, Des Figures ', date('2001-04-22'), 7, 1),
       (9, 'Subliminal', date('2013-05-20'), 7, 3);

-- songs
INSERT INTO songs(id, date_of_creation, name, band_id, album_id, price)
VALUES (1, date('2020-03-22'), 'Midway', 1, 1, 2.99),
       (2, date('2020-03-22'), 'Uprising', 1, 1, 2.99),
       (3, date('2020-03-22'), 'White death', 1, 1, 2.99),
       (4, date('2020-03-22'), 'Stalingrad', 1, 2, 4.99),
       (5, date('2020-03-22'), 'Counterstrike', 1, 2, 4.99),
       (6, date('2020-03-22'), 'Sonne', 2, 3, 3.99),
       (7, date('2020-03-22'), 'Ich will', 2, 3, 5.49),
       (8, date('2020-03-22'), 'Siren', 3, 4, 0.99),
       (9, date('2020-03-22'), 'Ring Frei', 4, 5, 0.99),
       (10, date('2020-03-22'), 'Lust or Love', 5, 6, 0.99),
       (11, date('2020-03-22'), 'Posion', 6, 7, 3.49),
       (12, date('2020-03-22'), 'Love is a loaded gun', 6, 7, 5.99),
       (13, date('2020-03-22'), 'Bella', 8, 9, 2.99),
       (14, date('2020-03-22'), 'Zombie', 8, 9, 4.99);


-- customers
INSERT INTO customers (id, date_of_birth, email, full_name, phone)
VALUES (1, '2021-03-22', 'email@gmail.com', 'Justin Statem', '+375296666666'),
       (2, '2021-03-23', 'email@gmail.com', 'Justin Zal', '+375331234567'),
       (3, '2021-03-23', 'email@gmail.com', 'Fred Merch', '+37529292929'),
       (4, '2021-03-24', 'email@gmail.com', 'Aaron Salem', '+375333666333'),
       (5, '2021-03-24', 'email@gmail.com', 'Benny Hill', '+375448909090');

-- orders
INSERT INTO orders (id, created_at, description, issued_at, customer_id)
VALUES (1, '2021-03-21 20:25:12.000000', 'first', '2021-03-20 20:25:22.000000', 1),
       (2, '2021-03-22 20:25:35.000000', 'second', '2021-03-21 20:25:40.000000', 2),
       (3, '2021-03-23 20:25:48.000000', 'third', '2021-03-22 20:25:53.000000', 3),
       (4, '2021-03-24 20:25:48.000000', 'fourth', '2021-03-23 20:25:53.000000', 3),
       (5, '2021-03-25 20:25:48.000000', 'fifth', '2021-03-24 20:25:53.000000', 3),
       (6, '2021-03-26 20:25:48.000000', 'sixth', '2021-03-25 20:25:53.000000', 3),
       (7, '2021-03-27 20:25:48.000000', 'seventh', '2021-03-26 20:25:53.000000', 3),
       (8, '2021-03-28 20:25:48.000000', 'eighth', '2021-03-27 20:25:53.000000', 3),
       (9, '2021-03-01 20:25:48.000000', 'ninth', '2021-03-28 20:25:53.000000', 3),
       (10, '2021-03-02 20:25:48.000000', 'tenth', '2021-03-01 20:25:53.000000', 3);

INSERT INTO public.ordered_songs (order_id, song_id)
VALUES (1, 1),
       (1, 2),
       (2, 3),
       (2, 4),
       (2, 5),
       (3, 6);

-- 7. Создание представлений в MS SQL Server
-- 7.1. Разработать запрос на языке SQL для создания представления, включающего все поля таблицы, соответствующей агрегированной сущности, но значения в полях внешнего ключа заменить названиями соответствующих объектов, взятых из таблиц-справочников (по аналогии с запросом 5.3).
CREATE VIEW v_orders AS
SELECT o.id                                              AS order_id,
       o.created_at                                      AS created_at,
       o.description                                     AS order_description,
       o.issued_at                                       AS issued_at,
       s.name                                            AS song_name,
       concat(c.full_name, ' | ', c.phone) AS customer
FROM orders o
         INNER JOIN customers c on c.id = o.customer_id
         INNER JOIN ordered_songs ob on o.id = ob.order_id
         INNER JOIN songs s on s.id = ob.song_id;
-- 8. Создание запросов-действий в MS SQL Server
-- 8.1. Создать новую таблицу, подобную таблице, разработанной в запросе 6.6 с помощью запроса на языке SQL на создание таблицы (условие добавления записей выбрать самостоятельно).
CREATE TABLE IF NOT EXISTS temp_table AS
SELECT o.id,
       o.created_at,
       o.description,
       o.issued_at,
       concat(b.name) AS band,
       concat(c.full_name, ' | ', c.phone) AS customer
FROM orders o
         JOIN customers c on c.id = o.customer_id
         JOIN ordered_songs os on o.id = os.order_id
         JOIN bands b on b.id
ORDER BY o.created_at DESC;
-- 8.2. Обновить структуру созданной таблицы, добавив в нее новое поле.
ALTER TABLE temp_table
    ADD COLUMN temp_column VARCHAR;
-- 8.3. Заполнить новое поле с помощью запроса на обновление данных на языке SQL.
UPDATE temp_table
SET temp_column = 'temp_new';
-- 8.4. Обновить значения в поле с помощью запроса на языке SQL с учетом определенного условия.
UPDATE temp_table
SET temp_column = 'temp_update';
-- 8.6. Составить запрос на языке SQL на удаление записей из созданной таблицы (условие удаления записей выбрать самостоятельно).
DELETE
FROM temp_table
WHERE id = 1;
-- 9. Разработка триггеров, пользовательских функций и хранимых процедур в MS SQL Server
-- 9.1. Разработать хранимые процедуры трех типов для решения актуальных задач (не менее 3) с различным числом и типами данных входных и выходных параметров. Проверить правильность их выполнения с различными исходными данными.
-- 1 --
CREATE PROCEDURE add_song_to_order(orderId integer, songId integer)
LANGUAGE sql
AS
$$
INSERT INTO ordered_songs (order_id, song_id)
VALUES (orderId, songId);
$$;

--CALL add_song_to_order(2, 6);
--CALL add_song_to_order(2, 6);
--CALL add_song_to_order(3, 5);

-- 2 --
CREATE PROCEDURE delete_song_from_order(orderId integer)
LANGUAGE sql
AS
$$
DELETE
FROM ordered_songs
WHERE order_id = orderId;
DELETE
FROM orders
WHERE id = orderId;
$$;
-- CALL delete_book_order(1);
-- CALL delete_book_order(2);
-- CALL delete_book_order(3);

-- 3 --
CREATE PROCEDURE close_orders(p_date date)
LANGUAGE sql
AS
$$
UPDATE orders
SET issued_at = now()
WHERE issued_at IS NULL
  AND date(created_at) < date(p_date)
$$;

CALL close_orders('2021-03-20');
CALL close_orders('2021-03-26');