SELECT * 
FROM Users
LEFT JOIN Kadri_online_access_period 
    ON Users.user_login = Kadri_online_access_period.user_login
LEFT JOIN Kadri_online_settings 
    ON Users.user_login = Kadri_online_settings.user_login;
