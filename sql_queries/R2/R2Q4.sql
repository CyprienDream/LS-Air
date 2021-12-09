USE LSAIR;

SELECT A.name, A.airlineID, C.name, MAX(R.time) AS "longest route duration"
FROM AIRLINE AS A
JOIN COUNTRY AS C ON C.countryID = A.countryID
JOIN RouteAirline AS RA ON RA.airlineID = A.airlineID
JOIN ROUTE AS R ON R.routeID = RA.routeID
JOIN AIRPORT AS A1 ON A1.airportID = R.destination_airportID
JOIN AIRPORT AS A2 ON A2.airportID = R.departure_airportID
JOIN CITY AS C1 ON A1.cityID = C1.cityID
JOIN CITY AS C2 ON A2.cityID = C2.cityID
JOIN COUNTRY AS Co ON Co.countryID = C.countryID
JOIN COUNTRY AS Co2 ON Co2.countryID = C2.countryID
WHERE Co.countryID <> "Spain" OR Co2.countryID <> "Spain" AND A.active = "Y"
GROUP BY A.airlineID
ORDER BY MAX(R.time) DESC;


