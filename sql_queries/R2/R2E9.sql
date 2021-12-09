USE LSAIR;
DROP TABLE IF EXISTS MaintenanceCost;
CREATE TABLE MaintenanceCost(
    planeName VARCHAR(255),
    econimicCost INT
);

DROP EVENT IF EXISTS event1;
DELIMITER $$
CREATE EVENT IF NOT EXISTS event1
ON SCHEDULE EVERY 1 YEAR
DO BEGIN
	DECLARE a float DEFAULT 0;
    DECLARE b varchar(255);
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR SELECT PT.type_name, SUM(Pe.cost) FROM PLANE AS P JOIN PLANETYPE AS PT ON P.planeID = PT.planetypeID JOIN MAINTENANCE AS M ON M.planeID = P.planeID JOIN PieceMaintenance AS PM ON PM.maintenanceID = M.maintenanceID JOIN PIECE AS Pe ON Pe.pieceID = PM.pieceID GROUP BY P.planeID;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    _loop: LOOP
		FETCH cur INTO b, a;
    
		IF done THEN 
			LEAVE _loop;
        END IF;
        
        INSERT INTO MaintenanceCost
        SELECT b, a;
       
	END LOOP;
    
    CLOSE cur;
    
    END $$
DELIMITER ;