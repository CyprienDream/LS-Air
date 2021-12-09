-- This trigger simply uses a IF ELSE statement. The first action we take is to compare the number of
-- rows between the Store table and the AverageSquareMetreValue table. If the two numbers are
-- different, it proceeds to delete everything from the AverageSquareMetreValue table and regenerates
-- the data through an insert statement. If the two numbers are the same, it simply updates the
-- AverageSquareMetreValue table at the desired id.

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
