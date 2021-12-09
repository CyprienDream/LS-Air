-- This query outputs companies which don’t have enough shopkeepers to cover the opening hours of
-- its waiting areas weekly. It just uses “ having SUM(DISTINCT sk.weekly_hours) <
-- (wa.close_hour - wa.opening_hour) * 7” which compares all shopkeepers working hours in a week
-- and all opening hours of waiting areas in a week, and also to make sure these closing times of all
-- waiting areas are before midnight.

SELECT co.name AS "company name", wa.opening_hour AS "opening hour",  wa.close_hour AS "close hour", wa.airportID AS "airport ID", wa.waitingAreaID AS "waiting area ID"
FROM company AS co
JOIN waitingarea AS wa ON co.companyID = wa.companyID
JOIN shopkeeper AS sk ON wa.waitingAreaID = sk.waitingAreaID
GROUP BY sk.shopkeeperID
HAVING SUM(DISTINCT sk.weekly_hours) < (wa.close_hour - wa.opening_hour) * 7  AND wa.close_hour <= "24:00:00"
