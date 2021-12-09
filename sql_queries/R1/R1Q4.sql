SELECT P.name as "passenger name", P.surname, P.born_date as "born date"
FROM PERSON as P
JOIN PASSENGER as Ps ON Ps.passengerID = P.personID
JOIN LanguagePerson as LP ON LP.personID = P.personID
JOIN LANGUAGE as L ON L.languageID = LP.languageID
JOIN FLIGHTTICKETS as FT ON FT.passengerID = Ps.passengerID
JOIN FLIGHT as F ON FT.flightID = F.flightID
JOIN FLIGHT_FLIGHTATTENDANT as FFA ON FFA.flightID = F.flightID
JOIN FLIGHT_ATTENDANT as FA ON FA.flightAttendantID = FFA.flightAttendantID
JOIN LanguagePerson as LP2 ON LP2.personID = FA.flightAttendantID
JOIN LANGUAGE as L2 ON L2.languageID = LP2.languageID
WHERE L2.name != L.name
GROUP by P.personID
HAVING P.born_date < '1921-04-28' 
ORDER by P.name

