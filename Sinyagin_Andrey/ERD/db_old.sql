CREATE TABLE "user" (
	name TEXT(100) NOT NULL,
	mail TEXT(100) NOT NULL,
	user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	CONSTRAINT user_pk PRIMARY KEY (user_id)
);

CREATE TABLE route_info (
	route_time INTEGER NOT NULL,
	route_length INTEGER NOT NULL,
	changes_count INTEGER NOT NULL,
	route_info_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);

CREATE TABLE navigation_requests_history (
	current_location TEXT(100) NOT NULL,
	destination_location TEXT(100) NOT NULL,
	navigation_type TEXT(5) NOT NULL,
	navigation_requests_history_id INTEGER NOT NULL,
	CONSTRAINT navigation_requests_history_user_FK FOREIGN KEY (navigation_requests_history_id) REFERENCES "user"(user_id),
	CONSTRAINT navigation_requests_history_route_info_FK FOREIGN KEY (navigation_requests_history_id) REFERENCES route_info(route_info_id)
);