// QUERY 1
MATCH (ft1:FlightAttendant)-[:Attends]->(f:Flight)
MATCH (ft2:FlightAttendant)-[:Attends]->(f:Flight)

WHERE ft1.ID <> ft2.ID
CREATE (ft1)-[r:Colleague]->(ft2)
RETURN ft1,ft2


// QUERY 2
MATCH(ft1:FlightAttendant)-[:Attends]->(f1:Flight)-[:DepartsFrom]->(ap1:Airport)<-[:DepartsFrom]-(f2:Flight)<-[:Attends]-(ft2:FlightAttendant)
MATCH(ft11:FlightAttendant)-[:Attends]->(f11:Flight)-[:DepartsFrom]->(ap2:Airport)<-[:DepartsFrom]-(f21:Flight)<-[:Attends]-(ft21:FlightAttendant)
MATCH(ft12:FlightAttendant)-[:Attends]->(f12:Flight)-[:DepartsFrom]->(ap3:Airport)<-[:DepartsFrom]-(f22:Flight)<-[:Attends]-(ft22:FlightAttendant)
MATCH(ft13:FlightAttendant)-[:Attends]->(f13:Flight)-[:DepartsFrom]->(ap4:Airport)<-[:DepartsFrom]-(f23:Flight)<-[:Attends]-(ft23:FlightAttendant)

WHERE ft1.ID <> ft2.ID AND f1.ID <> f2.ID AND ft1.ID <> ft2.ID AND f1.ID <> f2.ID AND ft11.ID <> ft21.ID AND f1.ID <> f2.ID AND ft12.ID <> ft22.ID AND f1.ID <> f2.ID AND ft13.ID <> ft23.ID AND f1.ID <> f2.ID

CREATE (ft1)-[r1:Acquaintance]->(ft2)
CREATE (ft11)-[r2:Acquaintance]->(ft21)
CREATE (ft12)-[r3:Acquaintance]->(ft22)
CREATE (ft13)-[r4:Acquaintance]->(ft23)
RETURN ft1, ft2, ft11, ft21, ft12, ft22, ft13, ft23

//For just departsFrom

MATCH(ft1:FlightAttendant)-[:Attends]->(f1:Flight)-[:DepartsFrom]->(ap1:Airport)<-[:DepartsFrom]-(f2:Flight)<-[:Attends]-(ft2:FlightAttendant)
MATCH(ft1:FlightAttendant)-[:Speaks]->(l1:Language)<-[:Speaks]-(ft2:FlightAttendant)
WHERE ft1.ID <> ft2.ID AND f1.ID <> f2.ID
CREATE (ft1)-[r1:Acquaintance]->(ft2)
RETURN ft1, ft2


// QUERY 3
MATCH(pil:Pilot)-[:Pilots]->(f1:Flight)<-[:Attends]-(ft:FlightAttendant)
MATCH(pil1:Pilot)-[:Speaks]->(l1:Language)<-[:Speaks]-(ft1:FlightAttendant)
WHERE abs(pil.years_working - ft.years_working) < 10 AND  pil.ID = pil1.ID AND ft.ID = ft1.ID
CREATE (pil)-[r:Affaire]->(ft)
RETURN pil, ft


// QUERY 4
MATCH(pil:Pilot)-[:Speaks]->(l:Language)<-[:Speaks]-(ft:FlightAttendant)
MATCH(pil1:Pilot)-[r:Affaire]->(ft1:FlightAttendant)
WHERE pil1.ID = pil.ID AND ft.ID = ft1.ID
WITH l.name AS Language, COUNT(r) AS Affaires
RETURN Language, Affaires
ORDER BY Affaires DESC


// QUERY 5
MATCH(pil:Pilot)-[:Affaire]-(ft1:FlightAttendant)
MATCH(pil:Pilot)-[:Affaire]-(ft2:FlightAttendant)
MATCH(ft11:FlightAttendant)-[:Colleague]->(ft22:FlightAttendant)
WHERE  ft1.ID <> ft2.ID AND ft1.ID = ft11.ID AND ft2.ID = ft22.ID
RETURN pil


// QUERY 6
MATCH (p:Pilot)-[r:Affaire]->()
WITH count(r) as cnt, p
WHERE cnt > 1
return (p)-[:Affaire]-()
