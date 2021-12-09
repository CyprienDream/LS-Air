/*flightArrival.csv*/
SELECT "planeID", "airportID"
UNION ALL
SELECT p.planeID, r.destination_airportID
FROM PLANE AS p
JOIN AIRLINE As air ON air.airlineID = p.airlineID
JOIN COUNTRY As co ON co.countryID = air.countryID
JOIN FLIGHT As f ON f.planeID = p.planeID
JOIN ROUTE As r ON r.routeID = f.routeID
WHERE p.retirement_year >= year(current_date()) - 3 AND  co.name LIKE 'S%'
GROUP BY p.planeID, r.destination_airportID
INTO OUTFILE '/var/lib/mysql-files/flightDes.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*flightDeparture.csv*/
SELECT "planeID", "airportID"
UNION ALL
SELECT p.planeID, r.departure_airportID
FROM PLANE AS p
JOIN AIRLINE As air ON air.airlineID = p.airlineID
JOIN COUNTRY As co ON co.countryID = air.countryID
JOIN FLIGHT As f ON f.planeID = p.planeID
JOIN ROUTE As r ON r.routeID = f.routeID
WHERE p.retirement_year >= year(current_date()) - 3 AND  co.name LIKE 'S%'
GROUP BY p.planeID, r.departure_airportID
INTO OUTFILE '/var/lib/mysql-files/flightDep.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';