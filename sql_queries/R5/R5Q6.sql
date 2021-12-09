-- This query lists the most spoken languages by flight attendants and the other
-- employes. This query consists of the union if two basic queries. The whole trick rests on counting
-- the number of language Ids and grouping by the same ids.

SELECT "other employees" As "employee type", l.name As "language", COUNT(l.languageID) As "# people who speak the language"
FROM EMPLOYEE As e
JOIN PERSON AS p ON e.employeeID = p.personID
JOIN LanguagePerson As lp ON p.personID = lp.personID
JOIN LANGUAGE As l ON l.languageID = lp.languageID
GROUP BY l.languageID
UNION
SELECT "flight attendant", l.name, COUNT(l.languageID)
FROM FLIGHT_ATTENDANT As fa
JOIN PERSON As p On fa.flightattendantID = p.personID
JOIN LanguagePerson As lp ON p.personID = lp.personID
JOIN LANGUAGE As l ON l.languageID = lp.languageID
GROUP BY l.languageID;
