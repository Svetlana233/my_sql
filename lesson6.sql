-- Пусть задан некоторый пользователь.
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

SELECT to_user_id, count(to_user_id) as number_of_messages
FROM messages
WHERE from_user_id = 30 and to_user_id in
(select initiator_user_id from friend_requests WHERE target_user_id = 30)
group by to_user_id order by number_of_messages desc;



-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.


SELECT COUNT(*) FROM likes WHERE media_id IN
(SELECT id FROM media WHERE user_id in
(select user_id from (select user_id, birthday from profiles order by birthday desc limit 10) as T));



-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
select (SELECT COUNT(*) FROM likes WHERE user_id in (SELECT user_id FROM profiles WHERE gender = 'M')) as male_likes,
(SELECT COUNT(*) FROM likes WHERE user_id in (SELECT user_id FROM profiles WHERE gender = 'F')) as female_likes
from users limit 1;


-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.


select A,  SUM(B) from
(
(SELECT user_id as A, count(user_id)as B FROM media group by user_id)
union all (SELECT user_id as A, count(user_id) as B FROM users_communities group by user_id)
union all (SELECT user_id as A, count(user_id) as B FROM likes group by user_id)
) as Z
GROUP BY A order by SUM(B) limit 10;