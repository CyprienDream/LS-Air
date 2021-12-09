-- The following query looks for passengers that speak at least two languages and that have
-- done a flight with a time difference from origin to destination of at least 3 hours.
-- It uses two subqueries to calculate number of languages and find the
-- Chavacano speakers as they use the same tables but are aggregated differently. Finally, just like in
-- the previous query, it joins the airport and city tables twice to deal with the time difference.

SELECT p.name, p.surname, p.phone_number, multiLingual.numSpoken As "# languages spoken"
FROM
(
SELECT pers.personID
FROM PASSENGER as p
JOIN PERSON as pers ON p.passengerID = pers.personID
JOIN LanguagePerson as lp ON lp.personID = pers.personID
JOIN LANGUAGE as l ON l.languageID = lp.languageID
WHERE l.name = 'Chavacano'
) As ChavacanoSpeakers
JOIN
(
SELECT lp.personID, COUNT(lp.personID) As numSpoken
FROM PASSENGER As p
JOIN PERSON As pers ON p.passengerID = pers.personID
JOIN LanguagePerson as lp ON lp.personID = pers.personID
GROUP BY lp.personID
HAVING numSpoken > 1
) As multiLingual ON ChavacanoSpeakers.personID = multiLingual.personID
JOIN
(
SELECT DISTINCT p.passengerID
FROM PASSENGER As p
JOIN FLIGHTTICKETS As ft ON p.passengerID = ft.passengerID
JOIN FLIGHT As f ON f.flightID = ft.flightID
JOIN ROUTE As r ON f.routeID = r.routeID
JOIN AIRPORT As a1 ON r.departure_airportID = a1.airportID
JOIN AIRPORT As a2 ON r.destination_airportID= a2.airportID
JOIN CITY As c1 ON a1.cityID = c1.cityID
JOIN CITY As c2 ON a2.cityID = c2.cityID
WHERE c1.timezone - c2.timezone > 2
) As experiencedTraveler ON multiLingual.personID = experiencedTraveler.passengerID
JOIN PERSON as p ON experiencedTraveler.passengerID = p.personID;
