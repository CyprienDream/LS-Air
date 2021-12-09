-- This query shows the companies and value with shops that sell at least 20% of total products
-- from same country and have restaurants of at least two types. It uses a sub
-- query of products and joins it to the product store of the company, which is linked with the country of
-- the company, and then just a normal join of products with the company itself directly using Company
-- ID and makes a count of each and makes a percentage out of, and to compare with 20%. And verifies it
-- has at least two restaurant types, by obtaining two restaurants and joins them to two different waiting
-- areas and both related to the same company and use the different symbol to make sure these two
-- restaurants are different.

SELECT co.name, co.company_value FROM company AS co
JOIN waitingarea AS wa ON wa.companyID = co.companyID
JOIN store AS st ON st.storeId = wa.waitingareaID
JOIN productstore AS ps ON ps.storeID = st.storeId
JOIN product AS p ON p.companyID = co.companyID
JOIN(SELECT p.productId FROM product AS p) AS tab ON tab.productId = ps.productId
JOIN waitingarea As wa1 ON wa1.companyID = co.companyID
JOIN waitingarea AS wa2 ON wa2.companyID = co.companyID
JOIN restaurant AS res1 ON wa1.waitingAreaID = res1.restaurantID
JOIN restaurant AS res2 ON wa2.waitingAreaID = res2.restaurantID
WHERE res2.type <> res1.type
GROUP BY co.name
HAVING (COUNT(distinct p.productId) / COUNT(distinct tab.productId)) >= 0.2
