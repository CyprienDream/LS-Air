-- This query retrieves which passengers have ever travelled in business class. Additionally,
-- it shows which one of them have sat on the A or F seats. Furthermore, it also checks
-- that these passengers have checked in 2 times or more.

SELECT P.name, P.surname
FROM PERSON as P
JOIN FLIGHTTICKETS as FT ON FT.passengerID = P.personID
JOIN FLIGHT as F ON F.flightID = FT.flightID
JOIN CHECKIN as CH ON FT.flightTicketID = CH.flightTicketID
WHERE FT.business = 1 AND (CH.seat = 'A' OR CH.seat = 'F')
GROUP by P.personID
HAVING COUNT(F.flightID) > 1;


SELECT checkinID
FROM CHECKIN As CH
WHERE CH.seat = 'A' OR CH.seat = 'F'
