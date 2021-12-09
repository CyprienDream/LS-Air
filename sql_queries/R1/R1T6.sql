-- This query finds those tickets that were bought after a flight had departed. This is implemented with a trigger after insert
-- on the flighttickets table which added an overdate ticket to a table called TicketError or, in case the ticket wasn’t overdue,
-- added it to flighttickets.

DROP TABLE IF EXISTS TicketError;
CREATE TABLE TicketError(
	ticketID bigint UNSIGNED,
	personID bigint UNSIGNED,
    name VARCHAR(255),
    surname VARCHAR(255),
    flightID bigint UNSIGNED,
    dateOfFlight DATE,
    PRIMARY KEY (ticketID)
);

DELIMITER $$
DROP TRIGGER IF EXISTS R1T6 $$
CREATE TRIGGER R1T6 AFTER INSERT
ON FLIGHTTICKETS
FOR EACH ROW
BEGIN

    IF NEW.date_of_purchase > (SELECT F.date FROM PERSON as P
    JOIN FLIGHT as F ON F.flightID = N.flightID
    WHERE NEW.passengerID = P.personID) THEN

    INSERT INTO TicketError SELECT NEW.flightTicketID, P.personID, P.name, P.surname, NEW.flightID, F.date
    FROM PERSON as P
    JOIN FLIGHT as F ON F.flightID = N.flightID
    WHERE NEW.passengerID = P.personID;

    DELETE FROM CHECKIN WHERE flightTicketID = NEW.flightTicketID;
    DELETE FROM FLIGHTTICKETS WHERE flightTicketID = NEW.flightTicketID;

    END IF;

END $$
DELIMITER ;
