/*pilot table*/
SELECT "ID", "name", "surname", "email", "sex", "salary", "years_working"
UNION ALL
SELECT lp.personID, p.name, p.surname, p.email, p.sex, e.salary, e.years_working
FROM LanguagePerson As lp
JOIN PERSON As p ON p.personID = lp.personID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN PILOT AS pi ON pi.pilotID = e.employeeID
WHERE e.salary > 100000 AND e.retirement_date IS NOT NULL
GROUP BY lp.personID
HAVING COUNT(lp.languageID) >= 3
INTO OUTFILE '/var/lib/mysql-files/pilots.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*PilotLanguage table*/
SELECT "pilotID", "language"
UNION ALL
SELECT p1.personID, l.name
FROM
(
SELECT lp.personID
FROM LanguagePerson As lp
JOIN PERSON As p ON p.personID = lp.personID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN PILOT AS pi ON pi.pilotID = e.employeeID
WHERE e.salary > 100000 AND e.retirement_date IS NOT NULL
GROUP BY lp.personID
HAVING COUNT(lp.languageID) >= 3
) As p1
JOIN LanguagePerson As lp ON lp.personID = p1.personID
JOIN LANGUAGE As l ON l.languageID = lp.languageID
INTO OUTFILE '/var/lib/mysql-files/pilotsLanguage.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
