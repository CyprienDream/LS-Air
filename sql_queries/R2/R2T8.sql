USE LSAIR;
DROP TABLE IF EXISTS EnviromentalReductions;
CREATE TABLE EnviromentalReductions(
    originDestination VARCHAR(255),
    petrolDifference INT,
    date DATE
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger3 $$
CREATE TRIGGER trigger3 AFTER UPDATE
ON ROUTE /*Ask about when the trigger is triggered (minimum_petrol)*/ 
FOR EACH ROW BEGIN

	if(NEW.minimum_petrol <> OLD.minimum_petrol)
		THEN
        INSERT INTO EnviromentalReductions
		SELECT concat(A2.name," --> ", A1.name), abs(OLD.minimum_petrol - NEW.minimum_petrol), current_date()
		FROM ROUTE AS R
		JOIN AIRPORT AS A1 ON R.destination_airportID = A1.airportID
		JOIN AIRPORT AS A2 ON R.departure_airportID = A2.airportID
        WHERE R.routeID = NEW.routeID; 
	END IF;
END $$
DELIMITER ;