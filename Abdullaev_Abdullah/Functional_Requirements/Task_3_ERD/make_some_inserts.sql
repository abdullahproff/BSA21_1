-- Добавление пользователей
INSERT INTO users (username, progress) VALUES 
('JohnDoe', 'Intermediate'),
('JaneSmith', 'Beginner'),
('AliKhan', 'Advanced');

-- Добавление языков
INSERT INTO languages (language_name, user_id) VALUES 
('Spanish', 1), 
('French', 2),  
('Arabic', 3);

-- Добавление уроков
INSERT INTO lessons (lesson_name, topic, status, user_id, language_id) VALUES 
('Greetings', 'Basic phrases', 'completed', 1, 1), 
('Food and Drinks', 'Vocabulary', 'in progress', 1, 1),
('Introductions', 'Basic phrases', 'completed', 2, 2),
('Travel', 'Vocabulary', 'completed', 3, 3);

-- Добавление диалогов
INSERT INTO dialogs (initialization_time, message_type, lesson_id) VALUES 
('2024-11-01 10:00:00+00', 'client', 1),
('2024-11-01 10:05:00+00', 'system', 1),
('2024-11-02 15:00:00+00', 'client', 4);

-- Добавление аудиосообщений
INSERT INTO audio_messages (author, file_path, message_time, duration_seconds, dialog_id) VALUES 
('author', 'greeting_message.mp3', '2024-11-01 10:00:00+00', 10, 1),
('system', 'response_message.mp3', '2024-11-01 10:01:00+00', 15, 1),
('author', 'travel_tips.mp3', '2024-11-02 15:00:00+00', 20, 3);

-- Добавление прогресса уроков
INSERT INTO lesson_progress (result, xp, user_id, lesson_id) VALUES 
('success', 50, 1, 1),
('failure', 20, 1, 2),
('success', 30, 2, 3),
('success', 70, 3, 4);
