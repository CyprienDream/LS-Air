SELECT co.name AS "company name", cntry.name AS "country name" FROM country AS cntry 

JOIN company AS co ON co.countryID = cntry.countryID 

JOIN product AS p ON p.companyID = co.companyID 

JOIN food AS f ON f.foodID = p.productID 

  

JOIN 

(SELECT f.countryID, f.foodID FROM food AS f)  

AS tab ON tab.countryID = cntry.countryID 

  

GROUP BY co.name 

having (COUNT(distinct f.foodID) / COUNT(distinct tab.foodID)) >= 1 / 40 