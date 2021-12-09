-- This query uses a case statement to attach the correct string according to the value of the grade. It
-- also uses a subquery in orer to select the maintenances where less than 10 pieces have been replaced.
-- The average for each grade range was calculated using the AVG function.

USE LSAIR;

SELECT
CASE
WHEN M.grade BETWEEN 0 AND 1 THEN '0-1'
WHEN M.grade BETWEEN 1 AND 2 THEN '1-2'
WHEN M.grade BETWEEN 2 AND 3 THEN '2-3'
WHEN M.grade BETWEEN 3 AND 4 THEN '3-4'
WHEN M.grade BETWEEN 4 AND 5 THEN '4-5'
WHEN M.grade BETWEEN 5 AND 6 THEN '5-6'
WHEN M.grade BETWEEN 6 AND 7 THEN '6-7'
WHEN M.grade BETWEEN 7 AND 8 THEN '7-8'
WHEN M.grade BETWEEN 8 AND 9 THEN '8-9'
WHEN M.grade BETWEEN 9 AND 10 THEN '9-10'
END AS grade_range, AVG(Ma.duration)
FROM MECHANIC AS M
JOIN MAINTENANCE AS Ma ON Ma.mechanicID = M.mechanicID
JOIN(
	SELECT M.maintenanceID
	FROM MAINTENANCE AS M
	JOIN PieceMaintenance AS PM ON PM.maintenanceID = M.maintenanceID
	GROUP BY M.maintenanceID
	HAVING COUNT(PM.pieceID) < 10
    ) AS P1 ON P1.maintenanceID = Ma.maintenanceID
GROUP BY grade_range;
