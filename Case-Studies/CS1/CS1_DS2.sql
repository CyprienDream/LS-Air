/*airport.csv*/
SELECT "air_id", "air_name", "altitude", "city_id", "city_name", "city_timezone", "country_id", "country_name"
UNION ALL
SELECT ai.airportID, ai.name, ai.altitude, ci.cityID, ci.name, ci.timezone, c.countryID, c.name
FROM AIRPORT As ai
JOIN ROUTE As r ON r.departure_airportID = ai.airportID
JOIN FLIGHT As f ON f.routeID = r.routeID
JOIN CITY As ci ON ci.cityID = ai.cityID
JOIN COUNTRY As c ON ci.countryID = c.countryID
JOIN PLANE AS p ON p.planeID = f.planeID
JOIN AIRLINE As air ON air.airlineID = p.airlineID
JOIN COUNTRY As co ON co.countryID = air.countryID
WHERE p.retirement_year >= year(current_date()) - 3 AND  co.name LIKE 'S%'
GROUP BY ai.airportID
UNION
SELECT ai.airportID, ai.name, ai.altitude, ci.cityID, ci.name, ci.timezone, c.countryID, c.name
FROM AIRPORT As ai
JOIN ROUTE As r ON r.destination_airportID = ai.airportID
JOIN FLIGHT As f ON f.routeID = r.routeID
JOIN CITY As ci ON ci.cityID = ai.cityID
JOIN COUNTRY As c ON ci.countryID = c.countryID
JOIN PLANE AS p ON p.planeID = f.planeID
JOIN AIRLINE As air ON air.airlineID = p.airlineID
JOIN COUNTRY As co ON co.countryID = air.countryID
WHERE p.retirement_year >= year(current_date()) - 3 AND  co.name LIKE 'S%'
GROUP BY ai.airportID
INTO OUTFILE '/var/lib/mysql-files/airports.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';