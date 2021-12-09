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

