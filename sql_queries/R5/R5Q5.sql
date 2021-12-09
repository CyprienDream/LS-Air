SELECT pt.type_name, numFlights, SUM(r.distance), COUNT(DISTINCT p.airlineID), COUNT(s.statusID)
FROM FLIGHT As f
JOIN PLANE As p ON f.planeID = p.planeID
JOIN STATUS As s ON s.statusID = f.statusID
JOIN ROUTE As r ON r.routeID = f.routeID
JOIN PLANETYPE As pt ON pt.planetypeID = p.planetypeID
JOIN(
SELECT pt.planetypeID, COUNT(f.flightID) As numFlights
FROM PLANETYPE As pt
JOIN PLANE As p ON pt.planetypeID = p.planetypeID
JOIN FLIGHT As f ON f.planeID = p.planeID
GROUP BY pt.planetypeID
) As p1 ON pt.planetypeID = p1.planetypeID
WHERE s.status = 'Perfect'
GROUP BY p.planetypeID
HAVING numFlights > 500 AND SUM(r.distance) > 1000000 AND COUNT(DISTINCT p.airlineID) > 70 AND COUNT(s.statusID) >= 0.53 * numFlights; /*gives results when changed to 0.52*/

