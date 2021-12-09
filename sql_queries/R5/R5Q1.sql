-- This first cross-query finds out which are the airlines with more overbookings.
-- Furthermore, it only considers the airlines that had this problem with more than
-- 10% of the passengers.
-- It uses one big subquery which encapsulates two smaller queries; one
-- to calculate the total number of passengers per airline and one to calculate the number of not checked
-- in passengers per airline. These must be separate queries as we are counting from the same tables
-- with different conditions.

SELECT ai.name, COUNT(distinct ft.flightID) As "# overbooked flights"
FROM PLANE As p
JOIN AIRLINE As ai ON ai.airlineID = p.airlineID
JOIN FLIGHT As f ON p.planeID = f.planeID
JOIN FLIGHTTICKETS As ft ON ft.flightID = f.flightID
JOIN
(
SELECT p1.airlineID
FROM
(
/*#passengers per airline*/
SELECT p.airlineID, COUNT(ft.passengerID) As numPassengers
FROM PLANE As p
JOIN FLIGHT As f ON p.planeID = f.planeID
JOIN FLIGHTTICKETS As ft ON ft.flightID = f.flightID
GROUP BY p.airlineID
) As p1
JOIN
(
/*#not checkd in passengers per airline*/
SELECT p.airlineID, COUNT(ft.passengerID) As numNotChecked
FROM PLANE As p
JOIN FLIGHT As f ON p.planeID = f.planeID
JOIN FLIGHTTICKETS AS ft on ft.flightID = f.flightID
WHERE ft.passengerID NOT IN
(SELECT p.passengerID
FROM PASSENGER As p
JOIN FLIGHTTICKETS As ft ON ft.passengerID = p.passengerID
JOIN CHECKIN As c ON c.flightTicketID = ft.flightTicketID)
GROUP BY p.airlineID
) As p2 ON p2.airlineId = p1.airlineID
WHERE p2.numNotChecked > 0.1 * p1.numPassengers
) As tmp ON tmp.airlineID = p.airlineID
WHERE ft.passengerID NOT IN
(SELECT p.passengerID
FROM PASSENGER As p
JOIN FLIGHTTICKETS As ft ON ft.passengerID = p.passengerID
JOIN CHECKIN As c ON c.flightTicketID = ft.flightTicketID)
GROUP BY p.airlineID;
