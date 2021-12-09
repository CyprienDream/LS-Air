DROP TABLE IF EXISTS ExpiredProducts;
CREATE TABLE ExpiredProducts(
	id int,
    expiry_date date,
    warning_date date
);

DELIMITER $$
DROP EVENT IF EXISTS event1 $$
CREATE EVENT event1 
ON SCHEDULE EVERY 1 DAY
ON COMPLETION PRESERVE
DO
BEGIN
	DECLARE a int;
    DECLARE b date;
    DECLARE done int DEFAULT FALSE;
    
	DECLARE exp CURSOR FOR SELECT foodID, expiration_date FROM Food AS f WHERE f.expiration_date < current_date();
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN exp;
    
    _loop: LOOP
		FETCH exp INTO a, b;
        
        IF done THEN
			LEAVE _loop;
		END IF;
        
        INSERT INTO ExpiredProducts
        SELECT a, b, current_date();
        
    END LOOP;
    
    CLOSE exp;
END $$
DELIMITER ;