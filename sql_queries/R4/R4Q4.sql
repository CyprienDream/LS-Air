
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

