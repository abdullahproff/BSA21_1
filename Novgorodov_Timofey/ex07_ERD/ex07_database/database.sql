CREATE TYPE edu_status_enum AS ENUM ('enrolled', 'on_leave', 'dismissed');

CREATE TYPE task_status_enum AS ENUM ('done', 'in_progress', 'pending');

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    personal_email VARCHAR(100) UNIQUE,
    corp_email VARCHAR(100) UNIQUE,
    edu_status edu_status_enum NOT NULL,
    last_login_date TIMESTAMPTZ
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    workload INT NOT NULL
);

CREATE TABLE tasks (
    task_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    title VARCHAR(255) NOT NULL,
    task_status task_status_enum NOT NULL,
    priority INT CHECK (priority BETWEEN 1 AND 3) NOT NULL,
    deadline DATE check (deadline >= CURRENT_DATE),
    description TEXT,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE SET NULL,
    CONSTRAINT fk_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE SET NULL
);

CREATE OR REPLACE FUNCTION check_student_status()
RETURNS TRIGGER AS
    $$
DECLARE
    student_name VARCHAR(255);
BEGIN
    SELECT name INTO student_name
    FROM students
    WHERE student_id = NEW.student_id
      AND (edu_status != 'enrolled');
    IF FOUND THEN
        RAISE EXCEPTION 'Студент % отчислен и не может создавать задачи', student_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_student_status
BEFORE INSERT OR UPDATE
ON tasks
FOR EACH ROW
EXECUTE FUNCTION check_student_status();

INSERT INTO students (student_id, name, personal_email, corp_email, edu_status, last_login_date)
VALUES
    (1, 'Новгородов Тимофей Игоревич', 'tnovgorodoff@gmail.com', 'novgorodovti@university.com', 'enrolled', CURRENT_TIMESTAMP),
    (2, 'Шамрай Александра Константиновна', 'aleksashka@mail.ru', 'shamrayak@university.com', 'enrolled', CURRENT_TIMESTAMP - INTERVAL '7 days'),
    (3, 'Алекесанян Александр Нурикович', 'mafioznik@ya.ru', NULL, 'dismissed', CURRENT_TIMESTAMP - INTERVAL '10 days');

INSERT INTO subjects (subject_id, title, workload)
VALUES
    (1, 'Математический анализ', 10),
    (2, 'Дифференциальные уравнения', 7),
    (3, 'ТФКП', 4),
    (4, 'Физика', 8);

INSERT INTO tasks (task_id, student_id, subject_id, title, task_status, priority, deadline, description)
VALUES
    (1, 1, 1, 'Подготовка к семинару', 'done', 1, CURRENT_DATE, 'Сделать 1-3 задачи'),
    (2, 1, 2, 'Сделать доклад', 'in_progress', 2, CURRENT_DATE + INTERVAL '2 day', 'Подготовить доклад про методы решениия систем дифференциальных уравнений, сделать презентацию'),
    (3, 2, 1, 'Подготовиться к коллоквиуму', 'in_progress', 3, CURRENT_DATE + INTERVAL '3 days', 'Повторить темы 1-5 лекций'),
    (4, 2, 4, 'Решить задачи', 'done', 3, CURRENT_DATE + INTERVAL '5 days', 'Сделать 1-3 задачи'),
    (5, 1, 3, 'Повториить материалы лекции', 'done', 1, CURRENT_DATE + INTERVAL '2 days', 'Повторить лекуцию №4'),
    (6, 2, 2, 'Решить задачу', 'pending', 1, CURRENT_DATE, 'Уже не актуально');

INSERT INTO tasks (task_id, student_id, subject_id, title, task_status, priority, deadline, description)
VALUES (7, 3, 1, 'Не отчислиться', 'pending', 3, CURRENT_DATE + INTERVAL '3 days', 'А все, а уже все, а надо было раньше');

SELECT
    students.name AS student_name,
    subjects.title AS subject_title,
    tasks.title AS task_title,
    tasks.task_status,
    tasks.priority,
    tasks.deadline,
    tasks.description
FROM tasks
JOIN students ON tasks.student_id = students.student_id
JOIN subjects ON tasks.subject_id = subjects.subject_id
ORDER BY tasks.deadline;