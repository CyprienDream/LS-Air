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
