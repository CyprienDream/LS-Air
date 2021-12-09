SELECT A.name AS "Airline Name", COUNT(R.routeID) AS "# Routes"
FROM AIRLINE AS A
JOIN PLANE  AS P ON P.airlineID = A.airlineID
JOIN PLANETYPE AS PT ON PT.planetypeID = P.planetypeID
JOIN RouteAirline AS RA ON RA.airlineID = A.airlineID
JOIN ROUTE AS R ON R.routeID = RA.routeID
JOIN AIRPORT AS Ai ON R.destination_airportID = Ai.airportID 
JOIN AIRPORT As Ai2 ON R.departure_airportID = Ai2.airportID
JOIN CITY AS C ON C.cityID = Ai.cityID
JOIN CITY AS C2 ON C2.cityID = Ai2.cityID
WHERE C.countryID <> C2.countryID AND PT.petrol_capacity <= R.minimum_petrol
GROUP BY A.airlineID;

