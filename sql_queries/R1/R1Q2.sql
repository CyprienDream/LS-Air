use lsair;

SELECT P.personID as "person id", P.name, P.surname, P.born_date
FROM person as P
JOIN flighttickets as FT ON P.personID = FT.passengerID
JOIN flight as F ON F.flightID = FT.flightID
JOIN `status` as S ON S.statusID = F.statusID 
WHERE S.status = "Strong Turbulences" AND F.date = (SELECT MAX(FinalTurbulence) FROM (SELECT F.date as "FinalTurbulence"
FROM person as P2
JOIN flighttickets as FT ON P2.personID = FT.passengerID
JOIN flight as F ON F.flightID = FT.flightID
JOIN `status` as S ON S.statusID = F.statusID WHERE P2.personID = P.personID GROUP by P2.personID) as FinalTurbulence)
GROUP by P.personID 
