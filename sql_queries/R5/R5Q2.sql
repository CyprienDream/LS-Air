SELECT c1.timezone - c2.timezone As TimeDifference, COUNT(lo.lostObjectID) As "# lost objects"
FROM FLIGHT As f
JOIN ROUTE As r ON f.routeID = r.routeID
JOIN AIRPORT As a1 ON r.departure_airportID = a1.airportID
JOIN AIRPORT As a2 ON r.destination_airportID= a2.airportID
JOIN CITY As c1 ON a1.cityID = c1.cityID
JOIN CITY As c2 ON a2.cityID = c2.cityID
JOIN LUGGAGE As l ON f.flightID = l.flightID
JOIN LOSTOBJECT As lo ON l.luggageID = lo.luggageID
JOIN CLAIMS As cla ON cla.claimID = lo.lostObjectID
WHERE TIMESTAMPDIFF(MONTH, cla.date, f.date) <= 3
GROUP BY TimeDifference;
