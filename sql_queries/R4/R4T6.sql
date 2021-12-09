DROP TABLE IF EXISTS RefundsAlterations;
CREATE TABLE RefundsAlterations(
	personID int,
    ticketID int,
    comment varchar(255)
);

DELIMITER $$
DROP TRIGGER IF EXISTS refund_control $$
CREATE TRIGGER refund_control AFTER UPDATE ON REFUND
FOR EACH ROW BEGIN

	IF ((SELECT SUM(accepted) FROM REFUND WHERE NEW.flightTicketID = flightTicketID GROUP BY flightTicketID) > 0) THEN
		INSERT INTO RefundsAlterations
		SELECT (SELECT ft.passengerID FROM FLIGHTTICKETS  as ft WHERE NEW.flightTicketID = flightTicketID), 
				NEW.flightTicketID, 
				"Refund of a ticket already processed correctly";
	END IF;
    
	IF (SELECT COUNT(flightTicketID) FROM REFUND WHERE flightTicketID = NEW.flightTicketID GROUP BY flightTicketID HAVING SUM(accepted) = 0 >= 3) THEN
		INSERT INTO RefundsAlterations
		SELECT (SELECT ft.passengerID FROM FLIGHTTICKETS  as ft WHERE NEW.flightTicketID = flightTicketID), 
				NEW.flightTicketID, 
				"Excessive Attempts";
	END IF;
    
END $$
DELIMITER ;