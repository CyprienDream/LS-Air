
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


