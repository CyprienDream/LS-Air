DROP TABLE IF EXISTS AverageSquareMetreValue;
CREATE TABLE AverageSquareMetreValue(
	storeId int,
	valueM2 float
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_shop$$
CREATE TRIGGER trigger_shop AFTER INSERT ON ProductStore
FOR EACH ROW BEGIN

	IF (SELECT COUNT(DISTINCT storeID) FROM AverageSquareMetreValue) <> (SELECT COUNT(DISTINCT storeID) FROM Store) THEN
		
        DELETE FROM AverageSquareMetreValue;
        
        INSERT INTO AverageSquareMetreValue
        SELECT s.storeID, AVG(p.price)/s.surface
        FROM ProductStore As ps
        JOIN Store As s ON s.storeID = ps.storeID
        JOIN Product As p ON p.productID = ps.storeID
        GROUP BY s.storeID;
        
	ELSE 
		UPDATE AverageSquareMetreValue
        SET valueM2 = (SELECT AVG(p.price)/s.surface FROM ProductStore As ps JOIN Store As s ON s.storeID = ps.storeID JOIN Product As p ON p.productID = ps.storeID WHERE s.storeID = NEW.storeID)
        WHERE storeID = NEW.storeID;
        
    END IF;

END $$
DELIMITER ;