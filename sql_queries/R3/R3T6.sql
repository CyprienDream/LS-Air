DROP TABLE IF EXISTS EconomicReductions;
CREATE TABLE EconomicReductions(
    comp_name  VARCHAR (255),
    closed_wa INT,
    annual_savs VARCHAR(255),
    annual_exp varchar(255)
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_food $$
CREATE TRIGGER trigger_food BEFORE DELETE ON WaitingArea
FOR EACH ROW BEGIN

	INSERT INTO EconomicReductions
	VALUES (
         (SELECT co.name 
		 FROM Company AS co 
         WHERE co.companyID = OLD.companyID), 
         
		 (OLD.waitingAreaID), 
         
         (SELECT SUM(e.salary * sk.weekly_hours * 10 * 52.1429) 
		 FROM EMPLOYEE AS e 
         JOIN Shopkeeper AS sk ON sk.shopkeeperID = e.employeeID
		 WHERE sk.waitingAreaID = OLD.waitingAreaID), 
          
		 (SELECT SUM(e.salary * sk.weekly_hours * 10 * 52.1429)
		 FROM Company As co1 
		 JOIN WaitingArea AS wa ON wa.companyID = co1.companyID
		 JOIN Shopkeeper AS sk ON sk.waitingAreaID = wa.waitingAreaID
		 JOIN EMPLOYEE As e ON e.employeeID = sk.shopkeeperID
		 WHERE co1.companyID = OLD.companyID)         
	);
	
    DELETE FROM ProductStore WHERE storeID = OLD.waitingAreaID;
    DELETE FROM VIP_ROOM WHERE restaurantID = OLD.waitingAreaID;
    DELETE FROM VIP_ROOM WHERE vipID = OLD.waitingAreaID;
    DELETE FROM Store WHERE storeID = OLD.waitingAreaID;
    DELETE FROM RESTAURANT WHERE restaurantID = OLD.waitingAreaID;
    
	DELETE FROM Shopkeeper WHERE waitingAreaID = OLD.waitingAreaID;
    
                
	IF (SELECT annual_exp FROM EconomicReductions JOIN Company As c ON c.name = comp_name WHERE c.companyID = OLD.companyID) = 0 THEN 
		
        DELETE FROM ProductStore WHERE storeID IN (SELECT waitingAreaID FROM WaitingArea As wa WHERE companyID = OLD.companyID);
        
        DELETE FROM ForbiddenProducts WHERE productID IN (SELECT p.productID  FROM Product WHERE p.companyID = OLD.companyID);
        DELETE FROM Clothes WHERE clothesID IN (SELECT p.productID  FROM Product WHERE p.companyID = OLD.companyID);
        DELETE FROM Food WHERE foodID IN (SELECT p.productID  FROM Product WHERE p.companyID = OLD.companyID);
        DELETE FROM Product WHERE companyID = OLD.companyID;
        
        DELETE FROM Shopkeeper WHERE shopkeeperID IN (SELECT shopkeeperID FROM Shopkeeper As sk JOIN WaitingArea AS wa ON wa.waitingAreaID = sk.waitingAreaID WHERE wa.companyID = OLD.companyID);
        DELETE FROM EMPLOYEE WHERE employeeID IN (SELECT shopkeeperID FROM Shopkeeper As sk JOIN WaitingArea AS wa ON wa.waitingAreaID = sk.waitingAreaID WHERE wa.companyID = OLD.companyID);
        
		DELETE FROM VIP_ROOM WHERE restaurantID IN (SELECT waitingAreaID FROM WaitingArea As wa WHERE companyID = OLD.companyID);
        DELETE FROM VIP_ROOM WHERE vipID IN (SELECT waitingAreaID FROM WaitingArea As wa WHERE companyID = OLD.companyID);
        DELETE FROM RESTAURANT WHERE restaurantID IN (SELECT waitingAreaID FROM WaitingArea As wa WHERE companyID = OLD.companyID);
        DELETE FROM Store WHERE storeID IN (SELECT waitingAreaID FROM WaitingArea As wa WHERE companyID = OLD.companyID);
        
        
	END IF;
        
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_food2 $$
CREATE TRIGGER trigger_food2 AFTER DELETE ON WaitingArea
FOR EACH ROW BEGIN
	
    IF (SELECT annual_exp FROM EconomicReductions JOIN Company As c ON c.name = comp_name WHERE c.companyID = OLD.companyID) = 0 THEN
    
		DELETE FROM WaitingArea WHERE companyID = OLD.companyID;
		DELETE FROM Company WHERE companyID = OLD.companyID;
    
    END IF;
    
END $$
DELIMITER ;