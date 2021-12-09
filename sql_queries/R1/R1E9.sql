-- This query create two tables and two events in order to be able to record statisics
-- about the number of flights on a daily basis and on a monthly basis. Both events are only containing
-- an insert statements that uses a query to count the number of flights within as specific time frame.

USE LSAIR;

DROP TABLE IF EXISTS DailyFlights;
CREATE TABLE DailyFlights(
	DateToday DATE,
    numFlights int(11) DEFAULT NULL,
    PRIMARY KEY (DateToday)
);

DROP TABLE IF EXISTS MonthlyFlights;
CREATE TABLE MonthlyFlights(
	DateToday DATE,
    numFlights int(11) DEFAULT NULL,
    PRIMARY KEY (DateToday)
);

DROP EVENT IF EXISTS R1E9day;
DELIMITER $$
CREATE EVENT IF NOT EXISTS R1E9day
ON SCHEDULE AT CURRENT_TIMESTAMP() + INTERVAL 1 DAY
DO BEGIN
	INSERT INTO DailyFlights
    SELECT curdate(), COUNT(F.flightID)
    FROM FLIGHT as F
    WHERE F.date > curdate()-1
    END
DELIMITER ;

DROP EVENT IF EXISTS R1E9month;
DELIMITER $$
CREATE EVENT IF NOT EXISTS R1E9month
ON SCHEDULE AT CURRENT_TIMESTAMP() + INTERVAL 1 MONTH
DO BEGIN
	INSERT INTO DailyFlights
    SELECT curdate(), COUNT(F.flightID)
    FROM FLIGHT as F
    WHERE month(F.date) = month(current_date())
    END
DELIMITER ;
