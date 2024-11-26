SELECT 
    u.username,
    l.language_name,
    le.lesson_name,
    le.topic,
    le.status
FROM 
    users u
JOIN 
    languages l ON u.user_id = l.user_id
JOIN 
    lessons le ON l.language_id = le.language_id
WHERE 
    u.username = 'JohnDoe';
