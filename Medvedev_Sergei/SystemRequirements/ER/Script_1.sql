DROP TABLE IF EXISTS Shoes, Users, Favourites CASCADE;

CREATE TABLE Shoes (
	ShoesId SERIAL PRIMARY KEY NOT NULL,
	SaleStatus BOOLEAN,
	ProductInStock BOOLEAN,
	Price INT CHECK (Price >= 0),
	Discount INT CHECK (Discount >= 0 AND Discount <= 100),
	DiscountStartDate TIMESTAMP,
	DiscountEndDate TIMESTAMP CHECK (DiscountEndDate > DiscountStartDate),
	ShoesSize DECIMAL CHECK (ShoesSize > 0),
	TypeSize VARCHAR(5),
	Material VARCHAR(50)
);

CREATE TABLE Users (
	UserId SERIAL PRIMARY KEY NOT NULL,
	UserName VARCHAR(20),
	UserSurname VARCHAR(20),
	UserOld INT CHECK (UserOld > 0 AND UserOld <= 100),
	RegistrationDate TIMESTAMP
);

CREATE TABLE Favourites (
	FavouritesId SERIAL PRIMARY KEY NOT NULL,
	UserId INT NOT NULL,
	ShoesId INT NOT NULL,
	FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
	FOREIGN KEY (ShoesId) REFERENCES Shoes(ShoesId) ON DELETE CASCADE,
	UNIQUE (UserId, ShoesId)
);

INSERT INTO Shoes (SaleStatus, ProductInStock, Price, Discount, DiscountStartDate, DiscountEndDate, ShoesSize, TypeSize, Material)
VALUES 
  (TRUE, TRUE, 1000, 50, '2024-11-26', '2025-01-15', 9.5, 'UK', 'Leather'),
  (FALSE, FALSE, 800, 30, '2024-12-25', '2025-02-28', 10.1, 'UK', 'Synthetic'),
  (TRUE, TRUE, 1200, 75, '2025-01-01', '2025-03-31', 8.2, 'RUS', 'Mesh'),
  (FALSE, TRUE, 900, 40, '2024-12-15', '2025-04-30', 9.2, 'US', 'Canvas');

INSERT INTO Users (UserName, UserSurname, UserOld, RegistrationDate)
VALUES 
	('John', 'Doe', 30, '2024-11-26'),
	('Jane', 'Smith', 25, '2024-11-27'),
	('Bob', 'Johnson', 35, '2024-11-28'),
	('Alice', 'Brown', 28, '2024-11-29');

INSERT INTO Favourites (UserId, ShoesId)
VALUES 
	(1, 2),
	(2, 3),
	(3, 1);

SELECT * FROM Shoes;
SELECT * FROM Users;
SELECT * FROM Favourites;


SELECT ShoesSize, TypeSize FROM Shoes WHERE Price >= 1000 GROUP BY TypeSize, ShoesSize, Price ORDER BY Price DESC;
