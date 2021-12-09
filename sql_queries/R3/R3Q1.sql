-- This query finds which companies have at least 1 of 40 food products from the
-- same country as its country. It joins company, product and food, and joins the food
-- with the country of this company using a sub query and a group by company name and finds a ratio
-- of number of food products from the companies of that company and the number of food products
-- from that company’s country.

SELECT co.name AS "company name", cntry.name AS "country name" FROM country AS cntry
JOIN company AS co ON co.countryID = cntry.countryID
JOIN product AS p ON p.companyID = co.companyID
JOIN food AS f ON f.foodID = p.productID
JOIN (SELECT f.countryID, f.foodID FROM food AS f) AS tab ON tab.countryID = cntry.countryID
GROUP BY co.name
HAVING (COUNT(distinct f.foodID) / COUNT(distinct tab.foodID)) >= 1 / 40
