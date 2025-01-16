
-- Создание, удаление и переключение на создаваемую схему.

DROP SCHEMA bsa21lecture_7 CASCADE;

CREATE SCHEMA bsa21lecture_7;

SET search_path TO bsa21lecture_7;

-- Создание таблиц: пользователя, задач, напоминаний.

CREATE TABLE "users" (
    user_id INT PRIMARY KEY,
    username VARCHAR (100) NOT NULL,
    device VARCHAR (40),
    email VARCHAR (150) NOT NULL UNIQUE
);

CREATE TABLE "task" (
    task_id INT PRIMARY KEY,
    creator_id INT,
    taskname VARCHAR (100) NOT NULL,
    description TEXT,
    priority VARCHAR (30),
    status VARCHAR (30),
    category VARCHAR (30),
    tags VARCHAR (30),
    reminders BOOL,
    text_comments TEXT,
    changes BOOL,
    datetowork TIMESTAMP WITH TIME ZONE,
    periodexecution DATE,
    FOREIGN KEY (creator_id) REFERENCES "users" (user_id) ON DELETE CASCADE
);

CREATE TABLE "responsibles" (
    responsible_id SERIAL PRIMARY KEY, 
    user_id INT NOT NULL,                
    task_id INT NOT NULL,                
    UNIQUE (user_id, task_id),           
    FOREIGN KEY (user_id) REFERENCES "users" (user_id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES "task" (task_id) ON DELETE CASCADE
);

CREATE TABLE "notification" (
    notification_id INT PRIMARY KEY,
    responsible_id INT NOT NULL,
    datetowork TIMESTAMP WITH TIME ZONE,
    datescheduled TIMESTAMP WITH TIME ZONE,
    periodexecution DATE,
    notificationtext TEXT,
    status VARCHAR (30),
    priority VARCHAR (30),
    reminder BOOLEAN DEFAULT FALSE,     
    trigger BOOLEAN DEFAULT FALSE,      
    FOREIGN KEY (responsible_id) REFERENCES "responsibles" (responsible_id) ON DELETE CASCADE
);

-- Вводимые данные в таблицы. Комменты не добавлялись.

INSERT INTO "users" (user_id, username, device, email) VALUES
(1, 'nikolay_viasov', 'laptop', 'nik@example.com'),
(2, 'anna_petrov', 'desktop', 'anna@example.com'),
(3, 'ivan_sidorov', 'tablet', 'ivan@example.com'),
(4, 'olga_ivanova', 'smartphone', 'olga@example.com'),
(5, 'sergey_kovalev', 'laptop', 'sergey@example.com'),
(6, 'maria_smirnova', 'desktop', 'maria@example.com');

INSERT INTO "task" (task_id, creator_id, taskname, description, priority, status, category, tags, reminders, 
text_comments, changes, datetowork, periodexecution) VALUES
(1, 1, 'Complete Project Report', 'Finalize and submit the project report by end of the week.', 'High', 'In Progress', 'Work', 'report, project', TRUE, '', FALSE, '2023-10-15 10:00:00-00', '2023-10-20'),
(2, 1, 'Prepare Presentation', 'Create a presentation for the upcoming team meeting.', 'Medium', 'Not Started', 'Work', 'presentation, meeting', TRUE, '', FALSE, '2023-10-18 10:00:00-00', '2023-10-25'),
(3, 2, 'Design Website', 'Create a new design for the company website.', 'High', 'In Progress', 'Design', 'website, design', TRUE, '', FALSE, '2023-10-20 10:00:00-00', '2023-10-30'),
(4, 3, 'Write Blog Post', 'Draft a blog post about the latest trends in technology.', 'Medium', 'Not Started', 'Content', 'blog, technology', TRUE, '', FALSE, '2023-10-22 10:00:00-00', '2023-10-29'),
(5, 4, 'Client Feedback', 'Gather feedback from the client on the recent project.', 'High', 'In Progress', 'Client', 'feedback, client', TRUE, '', FALSE, '2023-10-21 10:00:00-00', '2023-10-28'),
(6, 5, 'Team Meeting', 'Discuss project updates and next steps.', 'Medium', 'Scheduled', 'Work', 'meeting, project', TRUE, '', FALSE, '2023-10-19 10:00:00-00', '2023-10-19'),
(7, 6, 'Conduct User Research', 'Gather user feedback for the new product.', 'Medium', 'Not Started', 'Research', 'user, research', TRUE, '', FALSE, '2023-10-25 10:00:00-00', '2023-10-30'),
(8, NULL, 'Complete Team Project', 'Collaborate with the team to complete the project.', 'High', 'Not Started', NULL, 'team, project', TRUE, '', FALSE, '2023-10-30 10:00:00-00', '2023-10-30');

INSERT INTO "responsibles" (user_id, task_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(1, 8),
(2, 8),
(3, 8),
(4, 8),
(5, 8),
(6, 8);

INSERT INTO "notification" 
(notification_id, responsible_id, datetowork, datescheduled, periodexecution, notificationtext, status, priority, reminder, trigger) VALUES
(1, 1, '2023-10-15 10:00:00-00', '2023-10-14 09:00:00-00', '2023-10-20', 'Reminder: Complete Project Report is due tomorrow.', 'Pending', 'High', TRUE, FALSE),
(2, 1, '2023-10-15 10:00:00-00', '2023-10-16 09:00:00-00', '2023-10-20', 'Follow-up: Project Report submission.', 'Pending', 'Medium', FALSE, FALSE),
(3, 2, '2023-10-20 10:00:00-00', '2023-10-19 09:00:00-00', '2023-10-30', 'Reminder: Design Website is due soon.', 'Pending', 'High', TRUE, FALSE),
(4, 3, '2023-10-22 10:00:00-00', '2023-10-21 09:00:00-00', '2023-10-29', 'Reminder: Write Blog Post is due soon.', 'Pending', 'Medium', TRUE, FALSE),
(5, 4, '2023-10-21 10:00:00-00', '2023-10-20 09:00:00-00', '2023-10-28', 'Reminder: Gather Client Feedback.', 'Pending', 'High', TRUE, FALSE),
(6, 5, '2023-10-19 10:00:00-00', '2023-10-18 09:00:00-00', '2023-10-19', 'Reminder: Team Meeting is scheduled for today.', 'Pending', 'Medium', TRUE, FALSE),
(7, 1, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE),
(8, 2, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE),
(9, 3, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE),
(10, 4, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE),
(11, 5, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE),
(12, 6, '2023-10-30 10:00:00-00', '2023-10-29 09:00:00-00', '2023-10-30', 'Reminder: Complete Team Project is due today.', 'Pending', 'High', TRUE, FALSE);

-- Запросы которые проверил на этих данных.

select* from "users";
select* from "task";
SELECT * FROM responsibles;
select* from "notification";

-- 1. Запрос, который выводит дату уведомления, текст уведомления, исполнителя задачи

SELECT 
    n.datetowork AS notification_date,
    n.notificationtext AS notification_text,
    u.username AS executor
FROM 
    notification n
JOIN 
    responsibles r ON n.responsible_id = r.responsible_id
JOIN 
    users u ON r.user_id = u.user_id;

-- 2. Запрос, который выводит дату уведомления, текст уведомления, текст задачи, исполнителя задачи, время выполнения

SELECT 
    n.datetowork AS notification_date,
    n.notificationtext AS notification_text,
    t.taskname AS task_text,
    u.username AS executor,
    t.datetowork AS execution_time
FROM 
    notification n
JOIN 
    responsibles r ON n.responsible_id = r.responsible_id
JOIN 
    task t ON r.task_id = t.task_id
JOIN 
    users u ON r.user_id = u.user_id;

-- 3. Запрос, который выводит текст уведомления, текст задачи, время задачи, исполнителя задачи

SELECT 
    n.notificationtext AS notification_text,
    t.taskname AS task_text,
    t.datetowork AS task_time,
    u.username AS executor
FROM 
    notification n
JOIN 
    responsibles r ON n.responsible_id = r.responsible_id
JOIN 
    task t ON r.task_id = t.task_id
JOIN 
    users u ON r.user_id = u.user_id;

-- 4. Запрос для получения имени пользователя, текста уведомления, даты уведомления, названия задачи и описания задачи

SELECT 
    u.username,
    n.notificationtext,
    n.datescheduled,
    t.taskname,
    t.description
FROM 
    "users" u
JOIN 
    "responsibles" r ON u.user_id = r.user_id  
JOIN 
    "notification" n ON r.responsible_id = n.responsible_id 
JOIN 
    "task" t ON r.task_id = t.task_id
ORDER BY
    n.datescheduled ASC;

-- 5. Запрос для получения названия задачи, описания задачи, текста уведомления, даты уведомления и времени выполнения задачи

SELECT 
    t.taskname,
    t.description,
    n.notificationtext,
    n.datescheduled,
    t.periodexecution
FROM 
    "task" t
JOIN 
    "responsibles" r ON t.task_id = r.task_id 
JOIN 
    "notification" n ON r.responsible_id = n.responsible_id
ORDER BY
    n.datescheduled ASC;
    
-- 6. Запрос для получения идентификатора создателя, имени пользователя, названия задачи, описания задачи, текста уведомления, даты уведомления и времени выполнения задачи

SELECT 
    u.user_id AS creator_id,
    u.username,
    t.taskname,
    t.description,
    n.notificationtext,
    n.datescheduled,
    t.periodexecution
FROM 
    "task" t
JOIN 
    "responsibles" r ON t.task_id = r.task_id
JOIN 
    "notification" n ON r.responsible_id = n.responsible_id  
JOIN 
    "users" u ON t.creator_id = u.user_id;

















