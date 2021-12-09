// QUERY 1
MATCH (p:Plane)
	WHERE p.num_piece < 8 AND NOT (p:Plane)-[:DepartsFrom]->(:Airport) AND NOT (p:Plane)-[:ArrivesAt]->(:Airport)
RETURN p

// QUERY 2
MATCH (p:Plane)-[]->(a:Airport)
RETURN p, COUNT(DISTINCT a)
ORDER BY COUNT(DISTINCT a) DESC

// QUERY 3
MATCH (p:Plane)-[]->(a:Airport)-[]->(c:City)-[]->(co:Country)
    WHERE a.altitude > 100
RETURN p, COUNT(DISTINCT co);

// QUERY 4
MATCH (n:Country {name: 'Belgium'})
MATCH (m:Country {name: 'Norway'})
RETURN shortestpath((n)-[*..6]-(m));

// QUERY 5
MATCH (c1:Country {name: 'Belgium'})
MATCH (c2:Country {name: 'Norway'})
MATCH ((c1)<-[c:In]-(e:City)<-[d:Located]-(f:Airport)<-[a:DepartsFrom]-(g:Plane)-[b:ArrivesAt]->(h:Airport)-[i:Located]->(j:City)-[k:In]->(c2:Country))
RETURN c1, c2, a, b, c, d, e, f, g, h, i, j, k
