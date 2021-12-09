USE LSAIR;

SELECT A.airportID, C.countryID, P1.AvgDistCity as "average distance"
FROM AIRPORT AS A
JOIN CITY AS C ON C.cityID = A.cityID
JOIN(
	SELECT A.airportID , AVG(R.distance) AS AvgDistCity
	FROM AIRPORT AS A
	JOIN ROUTE AS R ON R.departure_airportID = A.airportID
	GROUP BY A.airportID
    ) AS P1 ON P1.airportID = A.airportID
JOIN(
	SELECT C.countryID, AVG(R.distance) AS AvgDistCountry
	FROM CITY AS C
	JOIN AIRPORT AS A ON A.cityID = C.cityID
	JOIN ROUTE AS R ON R.departure_airportID = A.airportID
	GROUP BY C.countryID
    ) AS P2 ON P2.countryID = C.countryID
    WHERE P1.AvgDistCity > P2.AvgDistCountry;


