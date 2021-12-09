USE LSAIR;
DROP TABLE IF EXISTS RoutesCancelled;
CREATE TABLE RoutesCancelled(
    destinationName VARCHAR(255),
    originName 	VARCHAR(255),
    numAirlines int,
    deletionDate DATE
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger1 $$
CREATE TRIGGER trigger1 BEFORE DELETE
ON ROUTE
FOR EACH ROW BEGIN
	
    INSERT INTO RoutesCancelled
    SELECT A1.name, A2.name, COUNT(RA.airlineID), current_date()
    FROM ROUTE AS R
    JOIN AIRPORT AS A1 ON R.destination_airportID = A1.airportID
    JOIN AIRPORT AS A2 ON R.departure_airportID = A2.airportID
    JOIN RouteAirline AS RA ON RA.routeID = R.routeID
    WHERE R.routeID = OLD.routeID;
    
    
    DELETE FROM REFUND WHERE flightTicketID IN (SELECT flightTicketID FROM FLIGHTTICKETS WHERE flightID IN (SELECT flightID FROM FLIGHT WHERE routeID = OLD.routeID));
    DELETE FROM FLIGHTTICKETS WHERE flightID IN (SELECT flightID FROM FLIGHT WHERE routeID = OLD.routeID);
    DELETE FROM FLIGHT WHERE routeID = OLD.routeID;
    DELETE FROM RouteAirline WHERE routeID = OLD.routeID;
    
END $$
DELIMITER ;

