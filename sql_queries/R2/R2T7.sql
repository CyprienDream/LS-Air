USE LSAIR;
DROP TABLE IF EXISTS MechanicsFirings;
CREATE TABLE MechanicsFirings(
    name VARCHAR(255),
    surename VARCHAR(255),
    birthdate DATE,
    firingReason VARCHAR(255)
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger2 $$
CREATE TRIGGER trigger2 BEFORE DELETE
ON MECHANIC
FOR EACH ROW BEGIN
	
    INSERT INTO MechanicsFirings
    SELECT p.name, p.surname, p.born_date, "Retirement"
    FROM PERSON As p 
    WHERE p.personID = OLD.mechanicID AND current_date() - p.born_date >= 65;
    
    INSERT INTO MechanicsFirings(name, surename, birthdate, firingReason)
    SELECT p.name, p.surname, p.born_date, "Evaluation period not completed"
    FROM PERSON As p 
    JOIN MAINTENANCE As m ON m.mechanicID = p.personID
    WHERE p.personID = OLD.mechanicID AND current_date() - p.born_date < 65
    GROUP BY m.mechanicID
    HAVING SUM(m.duration) < 10;
    
    INSERT INTO MechanicsFirings(name, surename, birthdate, firingReason)
    SELECT p.name, p.surname, p.born_date, "No reason"
    FROM PERSON As p 
    JOIN MAINTENANCE As m ON m.mechanicID = p.personID
    WHERE p.personID = OLD.mechanicID AND current_date() - p.born_date < 65
    GROUP BY m.mechanicID
    HAVING SUM(m.duration) >= 10;
    
    
    DELETE FROM PieceMaintenance WHERE maintenanceID IN (SELECT maintenanceID FROM MAINTENANCE WHERE mechanicID = OLD.mechanicID);
    DELETE FROM MAINTENANCE WHERE mechanicID = OLD.mechanicID;
END $$
DELIMITER ;
