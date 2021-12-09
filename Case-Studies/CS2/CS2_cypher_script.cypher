//Create language and pilot node, and creates 'Speaks' relationship between them
LOAD CSV WITH HEADERS FROM 'file:///pilotsLanguage.csv' As line
FIELDTERMINATOR ','
MERGE (n:Language {name: line.language})
MERGE (m:Pilot {ID: toInteger(line.pilotID)})
MERGE (m)-[:Speaks]->(n);

//Merges language and Creates flight attendant nodes and creates 'Speaks' relationship between them
LOAD CSV WITH HEADERS FROM 'file:///flightAttsLanguage.csv' As line
FIELDTERMINATOR ','
MERGE (n:Language {name: line.language})
MERGE (m:FlightAttendant {ID: toInteger(line.attendantID)})
MERGE (m)-[:Speaks]->(n);

//Merge pilot nodes from flight csv
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (q:Pilot{ID: toInteger(line.pilotID)});

//Merge flight attendant nodes from flight csv
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (r:FlightAttendant{ID: toInteger(line.attendantID)});

//Creates airport nodes from departure airports in flight csv
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (m:Airport{ID: toInteger(line.depID), name: line.depName});

//Creates airport nodes from destination airports in flight csv
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (o:Airport{ID: toInteger(line.desID), name: line.desName}); 

//Creates flight nodes
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (n:Flight{ID: toInteger(line.flightID)});

//Creates 'ArrivesAt' relationship between flight and corresponding airport
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (n:Flight{ID: toInteger(line.flightID)})
MERGE (o:Airport{ID: toInteger(line.desID), name: line.desName})
MERGE (n)-[:ArrivesAt]->(o);

//Creates 'DepartsFrom' relationship between flight and corresponding airport
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (n:Flight{ID: toInteger(line.flightID)})
MERGE (m:Airport{ID: toInteger(line.depID), name: line.depName})
MERGE (n)-[:DepartsFrom]->(m);

//Creates 'Pilots' relationship between flight and corresponding pilot
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (q:Pilot{ID: toInteger(line.pilotID)})
MERGE (n:Flight{ID: toInteger(line.flightID)})
MERGE (q)-[:Pilots]->(n);

//Creates 'Attends' relationship between flights and corresponding flight attendants
LOAD CSV WITH HEADERS FROM 'file:///ffap.csv' As line
FIELDTERMINATOR ','
MERGE (r:FlightAttendant{ID: toInteger(line.attendantID)})
MERGE (n:Flight{ID: toInteger(line.flightID)})
MERGE (r)-[:Attends]->(n);

//Merges pilot nodes and assigns properties from pìlot csv
LOAD CSV WITH HEADERS FROM 'file:///pilots.csv' As line
FIELDTERMINATOR ','
MERGE (n:Pilot {ID: toInteger(line.ID)})
ON CREATE
    SET n.ID = toInteger(line.ID), n.name = line.name, n.surname = line.surname, n.email = line.email, n.sex = line.sex, n.salary = toInteger(line.salary), n.years_working = toInteger(line.years_working)
ON MATCH
    SET n.name = line.name, n.surname = line.surname, n.email = line.email, n.sex = line.sex, n.salary = toInteger(line.salary), n.years_working = toInteger(line.years_working);

//Merges flight attendant nodes and assigns properties from flight attendant csv
LOAD CSV WITH HEADERS FROM 'file:///flightAtts.csv' As line
FIELDTERMINATOR ','
MERGE (n:FlightAttendant {ID: toInteger(line.ID)})
ON CREATE
    SET n.ID = toInteger(line.ID), n.name = line.name, n.surname = line.surname, n.email = line.email, n.sex = line.sex, n.salary = toInteger(line.salary), n.years_working = toInteger(line.years_working)
ON MATCH
    SET n.name = line.name, n.surname = line.surname, n.email = line.email, n.sex = line.sex, n.salary = toInteger(line.salary), n.years_working = toInteger(line.years_working);






























