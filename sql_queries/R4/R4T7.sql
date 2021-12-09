/*inside loop or not?*/

DROP TABLE IF EXISTS LostObjectDays;
CREATE TABLE LostObjectDays(
	objectID int,
    num_days int,
    type_avg float
);

select * from LostObjectDays


DELIMITER $$
DROP TRIGGER IF EXISTS object_found $$
CREATE TRIGGER object_found AFTER UPDATE
ON LOSTOBJECT
FOR EACH ROW BEGIN
        
	IF(NEW.founded = 1 AND OLD.founded = 0)
		THEN INSERT INTO LostObjectDays
		SELECT NEW.lostObjectID, 
			   DAY(current_date() - (SELECT date FROM CLAIMS WHERE claimID =  NEW.lostObjectID)),
			   (SELECT AVG(num_days) FROM LostObjectDays JOIN LOSTOBJECT As lo ON lo.lostObjectID = objectID WHERE description LIKE NEW.description);       
		END IF;
        
END $$
DELIMITER ;
