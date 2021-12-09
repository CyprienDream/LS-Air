/*ffap.csv*/
SELECT "flightID", "pilotID", "attendantID", "depID", "depName", "desID", "desName", "date"
UNION ALL
SELECT f.flightID, p.pilotID, ffa.flightAttendantID, a1.airportID As depid, a1.name, a2.airportID As desid, a2.name, f.date
FROM FLIGHT As f 
JOIN PILOT AS p ON p.pilotID = f.pilotID
JOIN FLIGHT_FLIGHTATTENDANT As ffa ON ffa.flightID = f.flightID
JOIN ROUTE AS r ON r.routeID = f.routeID
JOIN AIRPORT As a1 ON a1.airportID = r.departure_airportID
JOIN AIRPORT As a2 ON a2.airportID = r.destination_airportID
JOIN
(
SELECT lp.personID
FROM LanguagePerson As lp
JOIN PERSON As p ON p.personID = lp.personID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN PILOT AS pi ON pi.pilotID = e.employeeID
WHERE e.salary > 100000 AND e.retirement_date IS NOT NULL
GROUP BY lp.personID
HAVING COUNT(lp.languageID) >= 3
) As p1 ON p1.personID = p.pilotID
INTO OUTFILE '/var/lib/mysql-files/ffap.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';