SELECT * 
FROM Users
LEFT JOIN Kadri_online_access_period 
    ON Users.user_ID = Kadri_online_access_period.user_ID
LEFT JOIN Kadri_online_settings 
    ON Users.user_ID = Kadri_online_settings.user_ID;
