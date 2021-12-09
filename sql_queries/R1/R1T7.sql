
DROP TABLE IF EXISTS CrimeSuspect;
CREATE TABLE CrimeSuspect(
	passagerID bigint UNSIGNED, 
    name VARCHAR(255),
    surname VARCHAR(255),
    passport VARCHAR (11),
    phone VARCHAR(20),
    PRIMARY KEY (passagerID)
);

DELIMITER $$
DROP TRIGGER IF EXISTS R1T7 $$
CREATE TRIGGER R1T7 AFTER INSERT
ON PASSENGER
FOR EACH ROW 
BEGIN

IF NEW.creditCard IN (SELECT Ps.creditCard FROM passenger as Ps
    WHERE Ps.passengerID != NEW.passengerID) THEN
    
    INSERT INTO CrimeSuspect SELECT NEW.passengerID, P.name, P.surname, P.passport, P.phone_number
    FROM PERSON as P
    WHERE NEW.passengerID = P.personID;
    
    END IF;
    
END $$
DELIMITER ;

