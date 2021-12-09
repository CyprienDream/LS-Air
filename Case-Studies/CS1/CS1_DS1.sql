/*planes.csv*/
SELECT "planeiD", "retirement", "type", "airline_name", "num_maintenance", "num_pieces", "total_cost"
UNION ALL
SELECT p.planeID, p.retirement_year, pt.type_name, air.name As "airline_name", COUNT(m.maintenanceID), COUNT(DISTINCT pi.pieceID), SUM(pi.cost)
FROM PLANE As p
JOIN PLANETYPE As pt ON p.planetypeID = pt.planetypeID
JOIN AIRLINE As air ON air.airlineID = p.airlineID
LEFT JOIN MAINTENANCE AS m ON m.planeID = p.planeID
LEFT JOIN PieceMaintenance As pm ON pm.maintenanceID = m.maintenanceID
LEFT JOIN PIECE As pi ON pi.pieceID = pm.pieceID
JOIN COUNTRY As co ON co.countryID = air.countryID
WHERE p.retirement_year >= year(current_date()) - 3 AND  co.name LIKE 'S%'
GROUP BY p.planeID
INTO OUTFILE '/var/lib/mysql-files/planes.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

