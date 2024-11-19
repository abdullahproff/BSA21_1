SELECT name, surname, inn, widget_name,widget_type, Position_x, Position_y, Width, Height, Color_scheme, Widget_size, source_name, api_endpoint, method, params 
FROM settings s
JOIN users u ON s.user_id = u.user_id
JOIN widgets w ON s.widget_id = w.widget_id
JOIN datasources dt ON w.data_source_id = dt.data_source_id
WHERE u.user_id = 1;