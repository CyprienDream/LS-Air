DROP TABLE IF EXISTS PriceUpdates;
CREATE TABLE PriceUpdates
 (
    prod_name  VARCHAR (255),
    comp_name VARCHAR (255),
    prev_price INT,
    lat_price INT,
    change_date date,
    Comment VARCHAR (255)
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_historic $$
CREATE TRIGGER trigger_historic BEFORE UPDATE ON Product
FOR EACH ROW BEGIN

	IF NEW.name IN (SELECT prod_name FROM PriceUpdates) AND NEW.price < (SELECT p.price FROM Product as p WHERE p.productID = NEW.productID) AND current_timestamp() <> (SELECT change_date FROM PriceUpdates WHERE prod_name = NEW.name) THEN
        
        UPDATE PriceUpdates
        SET Comment = 'This product has been changing over time, it is possible that it is a strategy of the company'
        WHERE prod_name = (SELECT name FROM Product WHERE productID = NEW.productID);
		
	ELSE 
		
        INSERT INTO PriceUpdates
		SELECT p.name, c.name, p.price, NEW.price, current_timestamp(), ' ' 
		FROM Product AS p
		JOIN Company As c ON p.companyID = c.companyID
		WHERE p.productID = NEW.productID;
    
    END IF;

END $$
DELIMITER ;