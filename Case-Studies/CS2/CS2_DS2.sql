/*flight attendant table*/
SELECT "ID", "name", "surname", "email", "sex", "salary", "years_working"
UNION ALL
SELECT DISTINCT fa.flightattendantID, p.name, p.surname, p.email, p.sex, e.salary, e.years_working
FROM FLIGHT As f
JOIN FLIGHT_FLIGHTATTENDANT As ffa ON ffa.flightID = f.flightID
JOIN FLIGHT_ATTENDANT As fa ON fa.flightattendantID = ffa.flightAttendantID
JOIN PERSON As p ON p.personID = fa.flightattendantID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN 
(
SELECT lp.personID
FROM LanguagePerson As lp
JOIN PERSON As p ON p.personID = lp.personID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN PILOT AS pi ON pi.pilotID = e.employeeID
WHERE e.salary > 100000 AND e.retirement_date IS NOT NULL
GROUP BY lp.personID
HAVING COUNT(lp.languageID) >= 3
) As p1 ON p1.personID = f.pilotID
INTO OUTFILE '/var/lib/mysql-files/flightAtts.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*FlightAttendantLanguage table*/
SELECT "attendantID", "language"
UNION ALL
SELECT p2.flightattendantID, l.name
FROM
(
SELECT DISTINCT fa.flightattendantID
FROM FLIGHT As f
JOIN FLIGHT_FLIGHTATTENDANT As ffa ON ffa.flightID = f.flightID
JOIN FLIGHT_ATTENDANT As fa ON fa.flightattendantID = ffa.flightAttendantID
JOIN PERSON As p ON p.personID = fa.flightattendantID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN 
(
SELECT lp.personID
FROM LanguagePerson As lp
JOIN PERSON As p ON p.personID = lp.personID
JOIN EMPLOYEE As e ON e.employeeID = p.personID
JOIN PILOT AS pi ON pi.pilotID = e.employeeID
WHERE e.salary > 100000 AND e.retirement_date IS NOT NULL
GROUP BY lp.personID
HAVING COUNT(lp.languageID) >= 3
) As p1 ON p1.personID = f.pilotID
) As p2
JOIN LanguagePerson As lp ON lp.personID = p2.flightattendantID
JOIN LANGUAGE As l ON l.languageID = lp.languageID
INTO OUTFILE '/var/lib/mysql-files/flightAttsLanguage.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

