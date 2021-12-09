-- This query shows the restaurant best scores of the company with most waiting areas. The
-- restaurant with most waiting areas was found using ORDER By COUNT of number of waiting areas
-- ID of companies and to get just the maximum, used DESC to put in descending order and LIMIT1
-- just to get the top most company. And to get the restaurant maximum score, the max function is used.

SELECT co1.name AS "company name", max(res.score) AS "score"
FROM company AS co1 /*getting company with most waiting areas*/
JOIN  waitingarea AS wa ON co1.companyID = wa.companyID /*Joins to link the waitingarea to the restaurant*/
JOIN restaurant AS res ON wa.waitingAreaID = res.restaurantID
GROUP BY co1.companyID
ORDER BY count(distinct waitingAreaID) DESC LIMIT 1
