-- This query finds the countries in which passengers anticipated the most when buying tickets
-- and, on another hand, the country in which passengers anticipated the less. It uses a subtable which
-- calculates the average difference between the day of departure of the flights and the purchase of the
-- tickets (the anticipation), and it then selects the two countries that match the maximum and
-- minimum value of that subtable. The average price of the tickets is shown by
-- doing a simple AVG operation.

use lsair;

SELECT "Most anticipating" as "Type of country", C.name, AVG(F.date-FT.date_of_purchase) as "Hour difference", AVG(FT.price) as "Average price"
FROM country as C
JOIN person as P on P.countryID = C.countryID
JOIN flighttickets as FT on FT.passengerID = P.personID
JOIN flight as F on F.flightID = FT.flightID
GROUP by C.countryID
HAVING AVG(F.date-FT.date_of_purchase) > (SELECT MAX(AvgTimes) FROM (SELECT AVG(F.date-FT.date_of_purchase) as AvgTimes
FROM country as C
JOIN person as P on P.countryID = C.countryID
JOIN flighttickets as FT on FT.passengerID = P.personID
JOIN flight as F on F.flightID = FT.flightID
GROUP by C.countryID) as Times)

UNION

SELECT "Less anticipating" as "Type of country", C.name, AVG(F.date-FT.date_of_purchase) as "Hour difference", AVG(FT.price) as "Average price"
FROM country as C
JOIN person as P on P.countryID = C.countryID
JOIN flighttickets as FT on FT.passengerID = P.personID
JOIN flight as F on F.flightID = FT.flightID
GROUP by C.countryID
HAVING AVG(F.date-FT.date_of_purchase) < ((SELECT MIN(AvgTimes) FROM (SELECT AVG(F.date-FT.date_of_purchase) as AvgTimes
FROM country as C
JOIN person as P on P.countryID = C.countryID
JOIN flighttickets as FT on FT.passengerID = P.personID
JOIN flight as F on F.flightID = FT.flightID
GROUP by C.countryID) as Times) + 1)
