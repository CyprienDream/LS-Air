-- This query is made of three parts separated by a UNION. The first part deals with passengers owning
-- 1 luggage, the second deals with passengers having more than 1 luggage and the third deals with
-- passengers who do not own luggage.
-- The action of counting the number of passengers is done in subquerries as it is needed to group by
-- passengerID for that purpose but since luggage details are selected too, it would bw required to group
-- by luggageID too, which would give undesirable results (more than 1 instance of each passenger).
-- The function LEFT(string, #characters) is used to select the first 4 letters of the passenger and
-- country names. The aggregate function MIN is used for the passengers who own more than
-- one luggage.

SELECT pers.name As "passenger name", pers.email, co.name, lu.color, lu.brand, lu.weight, h.size_x * h.size_y * h.size_z As volume, cl.extra_cost As "extra cost", so.fragile
FROM PASSENGER AS p
JOIN PERSON As pers ON pers.personID = p.passengerID
JOIN COUNTRY As co ON co.countryID = pers.countryID
JOIN LUGGAGE As lu ON lu.passengerID = p.passengerID
LEFT JOIN HANDLUGGAGE As h ON h.handluggageID = lu.luggageID
LEFT JOIN CHECKEDLUGGAGE As cl ON cl.checkedluggageID = lu.luggageID
LEFT JOIN SPECIALOBJECTS As so ON so.specialobjectID = cl.checkedluggageID
WHERE LEFT(pers.name, 4) = LEFT(co.name, 4) AND p.passengerID IN
(
SELECT passengerID
FROM LUGGAGE
GROUP BY passengerID
HAVING COUNT(luggageID) = 1
)
UNION
SELECT pers.name, pers.email, co.name As country, lu.color, lu.brand, p1.weight, h.size_x * h.size_y * h.size_z As volume, cl.extra_cost, so.fragile As fragility
FROM PASSENGER AS p
JOIN PERSON As pers ON pers.personID = p.passengerID
JOIN COUNTRY As co ON co.countryID = pers.countryID
JOIN
(
SELECT lu.passengerID, MIN(lu.weight) As weight
FROM LUGGAGE As lu
GROUP BY lu.passengerID
) As p1 ON p1.passengerID = p.passengerID
JOIN LUGGAGE As lu ON lu.passengerID = p1.passengerID AND lu.weight = p1.weight
LEFT JOIN HANDLUGGAGE As h ON h.handluggageID = lu.luggageID
LEFT JOIN CHECKEDLUGGAGE As cl ON cl.checkedluggageID = lu.luggageID
LEFT JOIN SPECIALOBJECTS As so ON so.specialobjectID = cl.checkedluggageID
WHERE LEFT(pers.name, 4) = LEFT(co.name, 4) AND p.passengerID IN
(
SELECT passengerID
FROM LUGGAGE
GROUP BY passengerID
HAVING COUNT(luggageID) > 1
)
UNION
SELECT pers.name, pers.email, co.name, null, null, null, null, null, null
FROM PASSENGER AS p
JOIN PERSON As pers ON pers.personID = p.passengerID
JOIN COUNTRY As co ON co.countryID = pers.countryID
WHERE LEFT(pers.name, 4) = LEFT(co.name, 4) AND p.passengerID NOT IN (SELECT passengerID FROM LUGGAGE);
