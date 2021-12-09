SELECT p.personID, p.name, p.surname, p2.num_claims AS "# claims", p1.num_flights As "# flights"
FROM PERSON As p
JOIN
(
SELECT ft.passengerID, COUNT(ft.passengerID) As num_flights
FROM FLIGHTTICKETS As ft 
GROUP BY ft.passengerID
) As p1 ON p1.passengerID = p.personID
JOIN
(
SELECT cla.passengerID, COUNT(cla.passengerID) As num_claims
FROM CLAIMS As cla 
GROUP BY cla.passengerID
) As p2 ON p2.passengerID = p.personID
JOIN
(
SELECT cla.passengerID, SUM(re.accepted) As num_refunds
FROM CLAIMS As cla
JOIN REFUND As re ON re.refundID = cla.claimID
GROUP BY cla.passengerID
) As p3 ON p3.passengerID = p.personID
WHERE p2.num_claims > p1.num_flights AND p3.num_refunds = 0;
