-- This query is quite simple and uses a union to unite the results from the brand and color queries. This
-- union had to be put in a subquery in order to be able to perform operations with the results of
-- aggreagate functions (count/count).

SELECT type, num_objects, num_passengers, num_objects / num_passengers As ratio
FROM(
SELECT lu.color As type, COUNT(lo.lostObjectID) As num_objects, COUNT(lu.passengerID) As num_passengers
FROM LOSTOBJECT As lo
JOIN LUGGAGE As lu ON lu.luggageID = lo.luggageID
GROUP BY lu.color
UNION
SELECT lu.brand, COUNT(lo.lostObjectID), COUNT(lu.passengerID)
FROM LUGGAGE As lu
JOIN LOSTOBJECT As lo ON lu.luggageID = lo.luggageID
GROUP BY lu.brand
) As tab
ORDER BY ratio DESC;
