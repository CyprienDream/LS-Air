//Creates plane and airport nodes and creates 'DepartsFrom' relationship between them
LOAD CSV WITH HEADERS FROM 'file:///flightDep.csv' As line
FIELDTERMINATOR ','
MERGE (n:Plane{ID: line.planeID})
MERGE (m:Airport{ID: line.airportID}) 
MERGE (n)-[:DepartsFrom]->(m);

//Merges plane and airport nodes and creates 'ArrivesAt' relationship between them
LOAD CSV WITH HEADERS FROM 'file:///flightDes.csv' As line
FIELDTERMINATOR ','
MERGE (n:Plane{ID: line.planeID})
MERGE (m:Airport{ID: line.airportID}) 
MERGE (n)-[:ArrivesAt]->(m);

//Merges plane nodes and assigns corresponding properties from plane csv
LOAD CSV WITH HEADERS FROM 'file:///planes.csv' As line
FIELDTERMINATOR ','
MERGE (n:Plane {ID: line.planeiD})
ON CREATE
    SET n.ID = line.planeiD, n.retirement_year = toInteger(line.retirement), n.type = line.type, n.airline = line.airline_name, n.num_main = coalesce(toInteger(line.num_maintenance), 0), n.num_piece = coalesce(toInteger(line.num_pieces), 0), n.cost = coalesce(toInteger(line.total_cost), 0)
ON MATCH
    SET n.retirement_year = toInteger(line.retirement), n.type = line.type, n.airline = line.airline_name, n.num_main = coalesce(toInteger(line.num_maintenance), 0), n.num_piece = coalesce(toInteger(line.num_pieces), 0), n.cost = coalesce(toInteger(line.total_cost), 0);

//Merges airport nodes and assigns corresponding properties from airports csv
LOAD CSV WITH HEADERS FROM 'file:///airports.csv' AS line
FIELDTERMINATOR ','
MERGE (n:Airport{ID: line.air_id})
ON CREATE
    SET n.ID = line.air_id, n.name = line.air_name, n.altitude = toInteger(line.altitude), n.cityId = toInteger(line.city_id)
ON MATCH
    SET n.name = line.air_name, n.altitude = coalesce(toInteger(line.altitude), 0), n.cityId =  coalesce(toInteger(line.city_id), 0);

//Creates city and country nodes from airport csv
LOAD CSV WITH HEADERS FROM 'file:///airports.csv' AS line
FIELDTERMINATOR ','
MERGE (m:City{ID: toInteger(line.city_id), name: line.city_name, timezone: toInteger(line.city_timezone), countryID: toInteger(line.country_id)})
MERGE (o:Country{ID: toInteger(line.country_id), name: line.country_name});

//Creates relationship between airport and corresponding city
MATCH(n:Airport)
MATCH (m:City)
WHERE EXISTS(n.cityId) AND EXISTS(m.ID) AND n.cityId = m.ID
MERGE (n)-[:Located]->(m);

//Creates relationship between city and corresponding country
MATCH(n:City)
MATCH (m:Country)
WHERE EXISTS(n.countryID) AND EXISTS(m.ID) AND n.countryID = m.ID
MERGE (n)-[:In]->(m);
