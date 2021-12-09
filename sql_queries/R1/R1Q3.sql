-- The point of this query was to identify pilots who have served as copilots moret times than pilots.
-- We also had to check that the grade of these pilots was higher than the average grade of all pilots.
-- The information we needed to show was the flying license, the number of tumes being a pilot and
-- the grade.

use lsair;

SELECT Pi.flying_license, COUNT(Pi.pilotID), Pi.grade
FROM PERSON as P
JOIN EMPLOYEE as E ON E.employeeID = P.personID
JOIN PILOT as Pi ON E.employeeID = Pi.pilotID
JOIN FLIGHT as F ON F.pilotID = Pi.pilotID
JOIN ROUTE as Rt ON F.routeID = Rt.routeID
GROUP by Pi.pilotID
HAVING Pi.grade > 2 + (SELECT AVG(Pi.grade)
FROM PERSON as P
JOIN EMPLOYEE as E ON E.employeeID = P.personID
JOIN PILOT as Pi ON E.employeeID = Pi.pilotID)
AND COUNT(Pi.pilotID) > COUNT(Pi.copilotID)
ORDER by COUNT(Pi.pilotID) desc;


SELECT Pi.flying_license, COUNT(Pi.pilotID), Pi.grade
FROM PERSON as P
JOIN EMPLOYEE as E ON E.employeeID = P.personID
JOIN PILOT as Pi ON E.employeeID = Pi.pilotID
JOIN FLIGHT as F ON F.pilotID = Pi.pilotID
JOIN ROUTE as Rt ON F.routeID = Rt.routeID
GROUP by Pi.pilotID
HAVING Pi.grade > 2 + (SELECT AVG(Pi.grade)
FROM PERSON as P
JOIN EMPLOYEE as E ON E.employeeID = P.personID
JOIN PILOT as Pi ON E.employeeID = Pi.pilotID)
AND COUNT(Pi.pilotID) < COUNT(Pi.copilotID)
ORDER by Pi.grade desc
