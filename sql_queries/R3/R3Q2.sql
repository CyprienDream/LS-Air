-- This query verifies trade relations, by identifying countries with vip rooms and countries with
-- all restaurants corresponding to each of these vip rooms, and outputs their sums as well. The main idea
-- is to join the vip room of country 1 and restaurant of country 2 and also
-- make sure that each of them has less than 80 food products. This comparison has to be done
-- twice as seen in the HAVING clause, and not forgetting to group by country 1 name and country 2
-- name, for the counters above for restaurant and vip rooms.

SELECT cty1.name AS "vip room's country", cty2.name AS "vip restaurant's country", COUNT(distinct vip1.vipID) + COUNT(res.restaurantID) AS "#vip rooms/restaurant"
FROM country AS cty1
INNER JOIN company AS co1 ON cty1.countryID = co1.countryID
INNER JOIN (SELECT fp1.countryID, fp1.productID FROM forbiddenproducts AS fp1) AS tab1
  ON co1.countryID = tab1.countryID /*AND co2.countryID = tab1.countryID*/
INNER JOIN product AS  pr ON tab1.productID = pr.productID
INNER JOIN waitingarea AS wa1 ON wa1.companyID = co1.companyID
INNER JOIN vip_room AS vip1 ON vip1.vipID = wa1.waitingAreaID /*AND COUNT(distinct tab2.productID) <= 80 */
INNER JOIN restaurant AS res ON res.restaurantID = vip1.restaurantID
INNER JOIN waitingarea AS wa2 ON wa2.waitingareaID = res.restaurantID
INNER JOIN company AS co2 ON wa2.companyID = co2.companyID
INNER JOIN country AS cty2 ON cty2.countryID = co2.countryID
INNER JOIN (SELECT fp1.countryID, fp1.productID FROM forbiddenproducts AS fp1) AS tab2
  ON co2.countryID = tab2.countryID
GROUP BY cty1.name, cty2.name
HAVING COUNT(distinct tab1.productID) <= 80 AND COUNT(distinct tab2.productID) <= 80
