SELECT co.name, co.company_value FROM company AS co  

JOIN waitingarea AS wa ON wa.companyID = co.companyID  

JOIN store AS st ON st.storeId = wa.waitingareaID  

JOIN productstore AS ps ON ps.storeID = st.storeId 

JOIN product AS p ON p.companyID = co.companyID 

  

JOIN(SELECT p.productId FROM product AS p)  

AS tab ON tab.productId = ps.productId 

  

JOIN waitingarea As wa1 ON wa1.companyID = co.companyID 

JOIN waitingarea AS wa2 ON wa2.companyID = co.companyID   

JOIN restaurant AS res1 ON wa1.waitingAreaID = res1.restaurantID 

JOIN restaurant AS res2 ON wa2.waitingAreaID = res2.restaurantID 

WHERE res2.type <> res1.type 

group by co.name 

having (COUNT(distinct p.productId) / COUNT(distinct tab.productId)) >= 0.2 