-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.


START TRANSACTION
INSERT INTO sample.users SELECT id, name FROM shop.users WHERE id = 1
Delete FROM shop.users WHERE id = 1
commit

-- Создайте представление, которое выводит название name товарной позиции из таблицы products
-- и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW v (name_p, name_c) AS SELECT products.name, catalogs.name
FROM products, catalogs
where products.catalog_id = catalogs.id
SELECT * FROM v

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

select CURTIME()
SELECT FORMAT(cast('07:35' as time), N'hh\:mm')

DROP Function IF EXISTS hello;
CREATE Function hello()
RETURNS varchar(255) DETERMINISTIC
BEGIN
  if (FORMAT(cast('06:00' as time), N'hh\:mm') < FORMAT(cast(CURTIME() as time), N'hh\:mm'))
  and (FORMAT(cast('12:00' as time), N'hh\:mm') > FORMAT(cast(CURTIME() as time), N'hh\:mm')) THEN
	Return 'Доброе утро';
  elseif (FORMAT(cast('12:00' as time), N'hh\:mm') < FORMAT(cast(CURTIME() as time), N'hh\:mm'))
  and (FORMAT(cast('18:00' as time), N'hh\:mm') > FORMAT(cast(CURTIME() as time), N'hh\:mm')) THEN
	Return 'Добрый день';
 elseif (FORMAT(cast('18:00' as time), N'hh\:mm') < FORMAT(cast(CURTIME() as time), N'hh\:mm'))
  and (FORMAT(cast('24:00' as time), N'hh\:mm') > FORMAT(cast(CURTIME() as time), N'hh\:mm')) THEN
	Return 'Добрый вечер';
 else
	Return 'Доброй ночи';

  END IF;
end;

select hello();


-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение
-- NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF exists check_null

CREATE TRIGGER check_null BEFORE INSERT ON products
FOR EACH row
begin
	If ((new.name is null) and (new.description is NULL)) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Хотя бы одно из полей Имя или Описание должно быть заполнено';
	end IF;
end

INSERT INTO products
  (id, price, catalog_id)
VALUES
  (8, 17890.00, 3);

INSERT INTO products
  (id, name, price, catalog_id)
VALUES
  (8, 'Xerox3100', 17890.00, 3);