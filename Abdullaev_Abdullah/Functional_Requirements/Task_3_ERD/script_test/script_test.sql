-- Добавление пользователей
INSERT INTO Пользователь (user_name, user_progress)
VALUES 
('Ivan', 'А1'),
('Anna', 'B2');

-- Добавление языков
INSERT INTO Язык (language, user_id)
VALUES
('Английский', 1),
('Испанский', 2);

-- Добавление уроков
INSERT INTO Урок (lesson, topic, lesson_status, user_id, language_id)
VALUES 
('Введение в английский', 'Грамматика', 'в процессе', 1, 1),
('Введение в испанский', 'Лексика', 'завершен', 2, 2);

-- Добавление диалогов
INSERT INTO Диалог (initialization_time, message_type, lesson_id)
VALUES 
(NOW(), 'клиент', 1),
(NOW(), 'система', 2);

-- Добавление аудиосообщений
INSERT INTO Аудиосообщение (message_author, message_file, message_time, message_duration, dialog_id)
VALUES 
('автор', 'audio1.mp3', NOW(), 60, 1),
('система', 'audio2.mp3', NOW(), 45, 2);

-- Добавление прогресса уроков
INSERT INTO Прогресс_урока (result, xp, user_id, lesson_id)
VALUES 
('успешно', 100, 1, 1),
('неудачно', 50, 2, 2);
