CREATE TYPE navigation_type AS ENUM ('walk', 'auto', 'metro');


CREATE TABLE users (
    name VARCHAR(100) NOT NULL,
    mail VARCHAR(100) NOT NULL UNIQUE,
    user_id SERIAL PRIMARY KEY
);


CREATE TABLE route_info (
	route_time REAL NOT NULL,
	route_length INTEGER NOT NULL,
	changes_count INTEGER NOT NULL,
	route_info_id SERIAL PRIMARY KEY
);



CREATE TABLE navigation_requests_history (
	current_location VARCHAR(100) NOT NULL,
	destination_location VARCHAR(100) NOT NULL,
	navigation_type navigation_type NOT NULL,
	route_info_id INT UNIQUE NOT NULL,
	FOREIGN KEY (route_info_id) REFERENCES route_info(route_info_id),
	user_id INT REFERENCES users(user_id)
);

