-- This trigger is only made of one IF statement that checks that the field ‘founded’ from the LostObject
-- table has been changed from a 0 to a 1. It does so using the NEW and OLD key words. If it has been
-- changed, we proceed to insert the desired information in te LostObjectDays. Since we are dealing
-- with a single row, we were able to insert data using sub queries as select statements.

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
