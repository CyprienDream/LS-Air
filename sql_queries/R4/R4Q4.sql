-- This query was solved using the case statement. To separate the data in their corresponding groups,
-- it adds the flammable, fragile and corrosive filds together. As they are of
-- boolean types, the results of that addition is the number of hazardous characteristics they have.

SELECT
CASE
WHEN so.flammable + so.fragile + so.corrosive = 0 THEN '0'
WHEN so.flammable + so.fragile + so.corrosive = 1 THEN '1'
WHEN so.flammable + so.fragile + so.corrosive = 2 THEN '2'
WHEN so.flammable + so.fragile + so.corrosive = 3 THEN '3'
END As hazardous_level, AVG(cl.extra_cost) As "average extra cost"
FROM SPECIALOBJECTS As so
JOIN CHECKEDLUGGAGE As cl On cl.checkedluggageID = so.specialobjectID
GROUP BY hazardous_level;
