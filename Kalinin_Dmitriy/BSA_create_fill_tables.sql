
------------- Создание таблиц

CREATE TABLE Users (
    user_id BIGSERIAL PRIMARY KEY,
	user_name VARCHAR(30) NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Economy_sectors (
    economy_sector_id BIGSERIAL PRIMARY KEY,
	economy_sector VARCHAR(30) NOT NULL
);

CREATE TABLE Issuers (
    issuer_id BIGSERIAL PRIMARY KEY,
	issuer_name VARCHAR(30) NOT NULL,
	economy_sector_id BIGINT,
	FOREIGN KEY (economy_sector_id) REFERENCES Economy_sectors(economy_sector_id)
);

CREATE TABLE Shares (
    share_id BIGSERIAL PRIMARY KEY,
	share_name  VARCHAR(30) NOT NULL,
	last_price NUMERIC(20,10) NOT NULL,
	issuer_id BIGINT NOT NULL,
	FOREIGN KEY (issuer_id) REFERENCES Issuers(issuer_id)
);

CREATE TABLE Lists (
    list_id BIGSERIAL PRIMARY KEY,
	list_name VARCHAR(20) NOT NULL,
	user_id BIGINT NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	economy_sector_id BIGINT NOT NULL,
	daily_turnover_from NUMERIC(20,5) NOT NULL,
	daily_turnover_to NUMERIC(20,5),
	number_of_items INT,
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (economy_sector_id) REFERENCES Economy_sectors(economy_sector_id)
);

CREATE TABLE List_items (
    list_items_id BIGSERIAL PRIMARY KEY,
	list_id BIGINT NOT NULL,
	share_id BIGINT NOT NULL,
	FOREIGN KEY (list_id) REFERENCES Lists(list_id),
	FOREIGN KEY (share_id) REFERENCES Shares(share_id)
);

CREATE TABLE Transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	seller_id BIGINT NOT NULL,
	buyer_id BIGINT NOT NULL,
	share_id BIGINT NOT NULL,
	price NUMERIC(20,10) NOT NULL,
	number_of_shares BIGINT NOT NULL,
	volume NUMERIC(25,10) NOT NULL,
	
	FOREIGN KEY (seller_id) REFERENCES Users(user_id),
	FOREIGN KEY (buyer_id) REFERENCES Users(user_id),
	FOREIGN KEY (share_id) REFERENCES Shares(share_id)
);

------ Заполнение таблиц

INSERT INTO Users (user_name) VALUES ('user1');
INSERT INTO Users (user_name) VALUES ('user2');
INSERT INTO Users (user_name) VALUES ('user3');


INSERT INTO Economy_sectors (economy_sector) VALUES ('Retail');
INSERT INTO Economy_sectors (economy_sector) VALUES ('IT');
INSERT INTO Economy_sectors (economy_sector) VALUES ('Energy');
INSERT INTO Economy_sectors (economy_sector) VALUES ('Financial');


INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Sberbank', 4);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Yandex', 2);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Magnit', 1);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('VTB', 4);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Rosneft', 3);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Gazprom', 3);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Ozon', 1);
INSERT INTO Issuers (issuer_name, economy_sector_id) VALUES ('Rostelecom', 2);


INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('Сбербанк', 236.55, 1);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('ЯНДЕКС', 3465.00, 2);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('Магнит ао', 4440.05, 3);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('ВТБ ао', 75.56, 4);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('Роснефть', 450.12, 5);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('ГАЗПРОМ ао', 121.78, 6);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('OZON-адр', 3144.00, 7);
INSERT INTO Shares (share_name, last_price, issuer_id) VALUES ('Ростел -ао', 57.64, 8);



INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 2, 1, 236.55, 230, 236.55*230);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (2, 3, 2, 3465.00, 70, 3465.00*70);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 3, 2, 3465.00, 90, 3465.00*90);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (3, 2, 1, 236.55, 190, 236.55*190);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 2, 4, 75.56, 990, 75.56*990);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (2, 3, 2, 3465.00, 310, 3465.00*310);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (3, 2, 6, 121.78, 1210, 121.78*1210);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (3, 2, 1, 236.55, 310, 236.55*310);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 2, 4, 75.56, 1440, 75.56*1440);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (2, 1, 2, 3465.00, 210, 3465.00*210);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 2, 6, 121.78, 590, 121.78*590);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (3, 1, 1, 236.55, 1000, 236.55*1000);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 2, 7, 3144.00, 220, 3144.00*220);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (2, 1, 4, 75.56, 900, 75.56*900);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (1, 3, 2, 3465.00, 310, 236.55*310);
INSERT INTO Transactions (seller_id, buyer_id, share_id, price, number_of_shares, volume) VALUES (3, 1, 5, 450.12, 230, 450.12*230);

SELECT * FROM Users;
SELECT * FROM Economy_sectors;
SELECT * FROM Issuers;
SELECT * FROM Shares;
SELECT * FROM Transactions;

