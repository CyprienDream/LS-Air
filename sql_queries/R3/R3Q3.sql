SELECT co1.name AS "company name", max(res.score) AS "score" 

FROM company AS co1 

  

/*getting company with most waiting areas*/ 

JOIN  waitingarea AS wa ON co1.companyID = wa.companyID 

  

/*Joins to link the waitingarea to the restaurant*/   

JOIN restaurant AS res ON wa.waitingAreaID = res.restaurantID 

  

group by co1.companyID 

order by count(distinct waitingAreaID) DESC LIMIT 1 