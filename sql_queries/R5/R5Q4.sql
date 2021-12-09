SELECT p1.name, numDep + numDes As "total number of passengers"
FROM
(
SELECT ai.name, COUNT(ft.passengerID) As numDep
FROM AIRPORT As ai
JOIN ROUTE AS r ON r.departure_airportID = ai.airportID
JOIN FLIGHT As f ON f.routeID = r.routeID
JOIN FLIGHTTICKETS As ft ON ft.flightID = f.flightID
GROUP BY ai.airportID
) As p1
JOIN
(
SELECT ai.name, COUNT(ft.passengerID) As numDes
FROM AIRPORT As ai
JOIN ROUTE AS r ON r.destination_airportID = ai.airportID
JOIN FLIGHT As f ON f.routeID = r.routeID
JOIN FLIGHTTICKETS As ft ON ft.flightID = f.flightID
GROUP BY ai.airportID
) As p2 ON p1.name = p2.name
JOIN
(
SELECT DISTINCT ai1.name
FROM ROUTE As r
JOIN AIRPORT As ai1 ON r.departure_airportID = ai1.airportID
JOIN AIRPORT As ai2 ON r.destination_airportID= ai2.airportID
JOIN CITY As ci ON ci.cityID = ai2.cityID
JOIN COUNTRY As c ON c.countryID = ci.countryID
JOIN FLIGHT As f ON f.routeID = r.routeID
JOIN LUGGAGE As lu ON lu.flightID = f.flightID
JOIN HANDLUGGAGE As hl ON hl.handluggageID = lu.luggageID
JOIN ForbiddenProducts As fp ON fp.countryID = c.countryID AND fp.productID = hl.productID
) As p3 ON p3.name = p2.name;
