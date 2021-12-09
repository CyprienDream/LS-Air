-- This trigger takes care of communicating to customers in the event where their flight has been cancelled.
-- For that purpose, it creates two new tables in which to insert details related to the
-- passenger and the flight that has been cancelled. Additionally, the amount the
-- passenger will be refunded after the incident is also generated.

DROP TABLE IF EXISTS CancelledFlightsMails;
CREATE TABLE CancelledFlightsMails(
	flightID bigint (20) UNSIGNED,
    personID bigint UNSIGNED,
    namePerson VARCHAR(255),
    emailPerson VARCHAR(255),
    priceOfTicket int(11) DEFAULT NULL,
    isBusinessTicket tinyint(1) DEFAULT NULL,
    commission bigint UNSIGNED,
    PRIMARY KEY (flightID)
);

DROP TABLE IF EXISTS CancellationCost;
CREATE TABLE CancellationCost(
	flightID bigint (20) UNSIGNED,
    refund bigint UNSIGNED,
    PRIMARY KEY (flightID)
);


DELIMITER $$
DROP TRIGGER IF EXISTS R1T8 $$
CREATE TRIGGER R1T8 BEFORE DELETE
ON FLIGHT
FOR EACH ROW
BEGIN

    INSERT INTO CancelledFlightsMails SELECT OLD.flightID, P.personID, P.name, P.email, FT.price, FT.business, datediff(OLD.date, curdate())
    FROM PERSON as P
    JOIN FLIGHTTICKETS as FT ON FT.passengerID = P.personID
    WHERE OLD.flightID = FT.flightID;

    INSERT INTO CancellationCost SELECT OLD.flightID, (CFM.commission+1)*POWER(FT.price, 2)
    FROM CancelledFlightsMails as CFM
    JOIN FLIGHTTICKETS as FT ON FT.flightID = CFM.flightID;


END $$
DELIMITER ;
