-- This query finds the heavy workers (the luggage handlers) which have loaded
-- a plane by themselves and are paid less than the average wage of the luggage handlers.
-- In order to extract the flights that have been handled by only one person it is only
-- needed to count the number of occurences of flightID in the FlightLuggageHandler table and select
-- the ones occuring only once. It uses a subquery where it groups by flightID, which has
-- no reation to the selected variables.
-- The calculation of the average had to be used as a subquery in order to find the average
-- salary for all luggage handlers, not the restricted group of handlers found in the main query.

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
