cypher-shell -u neo4j -p wallaby -a bolt://10.255.0.1:7690 'MATCH (n:rgAttribute) DETACH DELETE n;'
cypher-shell -u neo4j -p wallaby -a bolt://10.255.0.1:7690 'MATCH (n:rgResource) DETACH DELETE n;'
cypher-shell -u neo4j -p wallaby -a bolt://10.255.0.1:7690 'MATCH (n:rgSchemaVersions) DETACH DELETE n;'
cypher-shell -u neo4j -p wallaby -a bolt://10.255.0.1:7690 'MATCH (n:rgSchemas) DETACH DELETE n;'
