-- This event uses a cursor. First, it creates two variables a and b to store the data
-- fetched by the cursor. Then, having set a handler to control the loop, it fetches the data by running
-- the insert query inside the loop and by inserting from the variables straight into the desired table.
-- What this will do is insert each row of the query into the table, one by one.

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
