DROP TABLE IF EXISTS DailyLuggageStatistics;
CREATE TABLE DailyLuggageStatistics(
	date date,
    num_kilos int,
    num_objects int,
    num_claims int
);

DROP TABLE IF EXISTS MonthlyLuggageStatistics;
CREATE TABLE MonthlyLuggageStatistics(
	year int,
    month int, 
    num_kilos int,
    num_objects int,
    num_claims int
);

DROP TABLE IF EXISTS YearlyLuggageStatistics;
CREATE TABLE YearlyLuggageStatistics(
    year int, 
    num_kilos int,
    num_objects int,
    num_claims int
);


DELIMITER $$
DROP EVENT IF EXISTS event1 $$
CREATE EVENT event1 
ON SCHEDULE EVERY 1 YEAR
ON COMPLETION PRESERVE
DO BEGIN
    DECLARE a INT;
    DECLARE b INT;
    DECLARE c FLOAT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE claim CURSOR FOR SELECT SUM(re.accepted) FROM REFUND As re JOIN FLIGHTTICKETS As ft ON ft.flightTicketID = re.flightTicketID WHERE DAY(datediff(current_date(), ft.date_of_purchase)) <= 365;
    DECLARE danger CURSOR FOR SELECT COUNT(so.specialobjectID) FROM SPECIALOBJECTS As so JOIN CHECKEDLUGGAGE As cl ON cl.checkedluggageID = so.specialobjectID JOIN LUGGAGE As lu ON lu.luggageID = cl.checkedluggageID JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE (corrosive <> 0 OR fragile <> 0 OR flammable <> 0) AND DAY(datediff(current_date(), f.date)) <= 365;
    DECLARE kilo CURSOR FOR SELECT SUM(lu.weight) FROM LUGGAGE As lu JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE DAY(datediff(current_date(), f.date)) <= 365;    
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN claim;
    OPEN danger;
    OPEN kilo;
    
    _loop: LOOP
		FETCH claim INTO a;
        FETCH danger INTO b;
        FETCH kilo INTO c;
        
        IF done THEN
			LEAVE _loop;
		END IF;
        
        INSERT INTO YearlyLuggageStatistics
        SELECT year(current_date()), c, b, a;
        
    END LOOP;
    
    CLOSE claim;
    CLOSE danger;
    CLOSE kilo;
    END $$

DELIMITER ;

DELIMITER $$
DROP EVENT IF EXISTS event2 $$
CREATE EVENT event2 
ON SCHEDULE EVERY 1 DAY
ON COMPLETION PRESERVE
DO BEGIN
    DECLARE a INT;
    DECLARE b INT;
    DECLARE c FLOAT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE claim CURSOR FOR SELECT SUM(re.accepted) FROM REFUND As re JOIN FLIGHTTICKETS As ft ON ft.flightTicketID = re.flightTicketID WHERE day(datediff(current_date(), ft.date_of_purchase)) <= 1;
    DECLARE danger CURSOR FOR SELECT COUNT(so.specialobjectID) FROM SPECIALOBJECTS As so JOIN CHECKEDLUGGAGE As cl ON cl.checkedluggageID = so.specialobjectID JOIN LUGGAGE As lu ON lu.luggageID = cl.checkedluggageID JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE (corrosive <> 0 OR fragile <> 0 OR flammable <> 0) AND day(datediff(current_date(), f.date)) <= 1;
    DECLARE kilo CURSOR FOR SELECT SUM(lu.weight) FROM LUGGAGE As lu JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE day(datediff(current_date(), f.date)) <= 1;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN claim;
    OPEN danger;
    OPEN kilo;
    
    _loop: LOOP
		FETCH claim INTO a;
        FETCH danger INTO b;
        FETCH kilo INTO c;
        
        IF done THEN
			LEAVE _loop;
		END IF;
        
        INSERT INTO DailyLuggageStatistics
        SELECT current_date(), c, b, a;
        
    END LOOP;
    
    CLOSE claim;
    CLOSE danger;
    CLOSE kilo;
    
    END $$
DELIMITER ;

/*check for same month and same year*/

DELIMITER $$
DROP EVENT IF EXISTS event3 $$
CREATE EVENT event3 
ON SCHEDULE EVERY 1 MONTH
ON COMPLETION PRESERVE
DO BEGIN
    DECLARE a INT;
    DECLARE b INT;
    DECLARE c FLOAT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE claim CURSOR FOR SELECT SUM(re.accepted) FROM REFUND As re JOIN FLIGHTTICKETS As ft ON ft.flightTicketID = re.flightTicketID WHERE year(current_date()) = year(ft.date_of_purchase) AND month(current_date()) = month(ft.date_of_purchase);
    DECLARE danger CURSOR FOR SELECT COUNT(so.specialobjectID) FROM SPECIALOBJECTS As so JOIN CHECKEDLUGGAGE As cl ON cl.checkedluggageID = so.specialobjectID JOIN LUGGAGE As lu ON lu.luggageID = cl.checkedluggageID JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE (corrosive <> 0 OR fragile <> 0 OR flammable <> 0) AND year(current_date()) = year(f.date) AND month(current_date()) = month(f.date);
	DECLARE kilo CURSOR FOR SELECT SUM(lu.weight) FROM LUGGAGE As lu JOIN FLIGHT As f ON f.flightID = lu.flightID WHERE year(current_date()) = year(f.date) AND month(current_date()) = month(f.date);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN claim;
    OPEN danger;
    OPEN kilo;
    
    _loop: LOOP
		FETCH claim INTO a;
        FETCH danger INTO b;
        FETCH kilo INTO c;
        
        IF done THEN
			LEAVE _loop;
		END IF;
        
        INSERT INTO MonthlyLuggageStatistics
        SELECT year(current_date()), month(current_date()), c, b, a;
        
    END LOOP;
    
    CLOSE claim;
    CLOSE danger;
    CLOSE kilo;
    
    END $$
DELIMITER ;