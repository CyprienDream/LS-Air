USE LSAIR;

SELECT planeID, name, num_pieces 
FROM(
	SELECT p.planeID, pi.name, COUNT(pi.pieceID) as num_pieces, pi.cost * COUNT(pi.pieceID) As piecesPrice, Price.total - (pi.cost * COUNT(pi.pieceID)) As sma
	FROM PLANE As p
	JOIN MAINTENANCE AS m ON m.planeID = p.planeID
	JOIN PieceMaintenance As pm ON pm.maintenanceID = m.maintenanceID
	JOIN PIECE AS pi ON pi.pieceID = pm.pieceID
	JOIN(
		SELECT m.planeID, SUM(pi.cost) As total
		FROM MAINTENANCE As m
		JOIN PieceMaintenance As pm ON pm.maintenanceID = m.maintenanceID
		JOIN PIECE As pi ON pi.pieceID = pm.pieceID
		GROUP BY m.planeID
	) As Price ON Price.planeID = p.planeID
	GROUP BY p.planeID, pm.pieceID
	HAVING num_pieces > 1 AND piecesPrice > (sma) / 2
) As table1;
