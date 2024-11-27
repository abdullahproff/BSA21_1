CREATE DATABASE mydatabase;

CREATE TYPE colour_type AS ENUM ('Red', 'Blue', 'Yellow', 'Green', 'White', 'Black'); 
CREATE TYPE style_type AS ENUM ('Classic', 'Sport', 'Casual');
CREATE TYPE season_type AS ENUM ('Winter', 'Summer', 'Off-season');
CREATE TYPE category_type AS ENUM ('Trousers', 'Skirt', 'Blouse', 'Dress'); 
CREATE TYPE size_type AS ENUM ('S', 'M', 'L', 'XL');
CREATE TYPE clothing_size_chart_type AS ENUM ('Russian', 'European', 'Jeans');
CREATE TYPE gender_size_type AS ENUM ('Men', 'Women', 'Children');


CREATE TABLE colours
(
    colour_id integer PRIMARY KEY,
	colour colour_type NOT NULL
);

CREATE TABLE products
(
    product_id 		integer PRIMARY KEY,
	product_name 	varchar(255) NOT NULL,
	style	 		style_type NOT NULL,
	season 			season_type NOT NULL,
	category 		category_type NOT NULL,
	current_color 	integer REFERENCES colours(colour_id)
);

CREATE TABLE sizes
(
    size_id 			integer PRIMARY KEY,
	size 				size_type,
	clothing_size_chart clothing_size_chart_type ,
	gender_size         gender_size_type,
	current_product 	integer REFERENCES products(product_id)
);

INSERT INTO colours (colour_id , colour)
VALUES 
(1, 'Red'),
(2, 'Green'),
(3, 'Blue'),
(4, 'Yellow'),
(5, 'White'),
(6, 'Black');


INSERT INTO products (product_id , product_name, style, season, category, current_color)
VALUES 
('1', 'West jeans', 'Casual', 'Winter', 'Trousers', 2),
('2', 'South jeans', 'Classic', 'Summer', 'Trousers', 5),
('3', 'Mediterranean blouse', 'Casual', 'Summer', 'Blouse', 3),
('4', 'Stylish blouse', 'Casual', 'Winter', 'Blouse', 3);

INSERT INTO sizes (size_id,	size, clothing_size_chart, gender_size, current_product )
VALUES 
('10', 'L', 'Russian', 'Men', 2),
('11', 'M', 'European', 'Men', 2),
('12', 'XL', 'Jeans', 'Children', 3),
('13', 'M', 'European', 'Women', 4);
('14', 'M', 'European', 'Women', 2);