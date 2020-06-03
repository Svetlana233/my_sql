DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.


INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Светлана', '1990-10-03', null, null),
  ('Василий', '1989-11-12', null, null),
  ('Татьяна', '1957-05-20', null, null);
  
UPDATE users SET created_at = now() WHERE created_at is null;
UPDATE users SET updated_at = now() WHERE updated_at is null;

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
-- и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к 
-- типу DATETIME, сохранив введеные ранее значения..

ALTER TABLE users MODIFY created_at VARCHAR(50);
ALTER TABLE users MODIFY updated_at VARCHAR(50);

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Ирина', '1984-06-07', "20.10.2017 8:10", "20.10.2017 8:10"),
  ('Николай', '1958-11-03', "20.10.2018 18:10", "20.10.2018 18:10"),
  ('Максим', '1982-05-09', "20.10.2019 8:30", "20.10.2019 8:30");
  
ALTER TABLE users ADD COLUMN created_at_new DATETIME;
ALTER TABLE users ADD COLUMN updated_at_new DATETIME;

UPDATE users SET created_at_new=STR_TO_DATE(created_at,'%d.%m.%Y %H:%i') where created_at LIKE '%.%';
UPDATE users SET created_at_new=created_at where created_at_new is null;

UPDATE users SET updated_at_new=STR_TO_DATE(updated_at,'%d.%m.%Y %H:%i') where updated_at LIKE '%.%';
UPDATE users SET updated_at_new=updated_at where updated_at_new is null;

-- 3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким
-- образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться 
-- в конце, после всех записей.

INSERT INTO storehouses (id, name) values
  ('1', 'South'),
  ('2', 'North'),
  ('3', 'West'),
  ('4', 'East');
  
INSERT INTO storehouses_products (id, storehouse_id, product_id, value) values
  (1, 1, 1, 5),
  (2, 1, 1, 10),
  (3, 2, 2, 15),
  (4, 2, 2, 50),
  (5, 3, 3, 3),
  (6, 4, 4, 20),
  (7, 4, 4, 30),
  (8, 25, 1, 40),
  (9, 1, 5, 20),
  (10, 4, 6, 100),
  (11, 2, 6, 0),
  (12, 4, 1, 0),
  (13, 3, 1, 0);
 
select * from storehouses_products WHERE value > 0 ORDER by value;

SELECT id, storehouse_id, product_id, value, created_at, updated_at, IF (value = 0, 2147483647, value) as sort_order 
FROM storehouses_products ORDER BY sort_order asc;

-- Практическое задание теме “Агрегация данных”
-- 1. Подсчитайте средний возраст пользователей в таблице users


select ROUND(AVG(t.age), 2) from (
	SELECT DATE_FORMAT(FROM_DAYS(DATEDIFF(now(), birthday_at)), '%Y')+0 AS age from users
) t;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select days, Count(id) as birthday_count from
(
select id, WEEKDAY(STR_TO_DATE(DATE_FORMAT(birthday_at,'%d.%m.2020'),'%d.%m.%Y')) as days from users 
) t GROUP BY days order by days ;

