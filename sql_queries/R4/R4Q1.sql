SELECT p.personID, p.name, p.surname, e.salary
FROM FlightLuggageHandler As fl
JOIN LUGGAGEHANDLER As lh ON lh.luggagehandlerID = fl.luggageHandlerID
JOIN EMPLOYEE As e ON e.employeeID = lh.luggagehandlerID
JOIN PERSON As p on p.personID = e.employeeID
WHERE fl.flightID IN 
(
SELECT fl.flightID
FROM FlightLuggageHandler As fl
GROUP BY fl.flightID
HAVING COUNT(fl.flightID) = 1
) AND e.salary < 
(
SELECT AVG(e.salary)
FROM EMPLOYEE As e
JOIN LUGGAGEHANDLER AS lh ON lh.luggagehandlerID = e.employeeID
)