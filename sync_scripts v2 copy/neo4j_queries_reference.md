MythoGyan Knowledge Graph — Neo4j Query Reference

🕉️ Overview

This guide provides ready-to-use Cypher queries for exploring the MythoGyan Knowledge Graph in Neo4j.
It assumes your graph has been synced from PostgreSQL using sync_to_neo4j.py and constraints are applied via setup_graph_constraints.cypher.

Each query example is categorized by use case (Character, Event, Relationship, Ontology, Symbolism, etc.).

🔹 1. Character Exploration
🧙 1.1 Find a Character by Name
MATCH (c:Character)
WHERE toLower(c.name) CONTAINS toLower('Vishnu')
RETURN c
LIMIT 1;

👪 1.2 List All Avatars of Vishnu
MATCH (v:Character {name: 'Vishnu'})-[:RELATION {type:'Avatar Of'}]-(a:Character)
RETURN a.name AS Avatar, a.origin AS Origin, a.type AS Type
ORDER BY a.name;

🧬 1.3 Show Vishnu’s Consorts
MATCH (v:Character {name:'Vishnu'})<-[:RELATION {type:'Consort'}]-(c:Character)
RETURN c.name AS Consort, c.type AS Type, c.origin AS Origin;

🔄 1.4 Trace Reincarnation Cycle
MATCH (prev:Character)-[:RELATION {type:'Reincarnation Of'}]->(next:Character)
WHERE prev.name = 'Rama'
RETURN prev.name AS Previous_Form, next.name AS Reborn_As;

⚔️ 2. Events, Battles & Participation
🗺 2.1 List All Events a Character Participated In
MATCH (c:Character {name:'Arjuna'})-[r:RELATION {type:'Participated In'}]->(e:Event)
RETURN e.name AS Event, e.subtype AS Type, e.origin AS Yuga, r.context AS Role
ORDER BY e.name;

⚔️ 2.2 Show All Participants in “Kurukshetra War”
MATCH (e:Event {name:'Kurukshetra War'})<-[:RELATION {type:'Participated In'}]-(c:Character)
RETURN c.name AS Participant, c.alignment AS Alignment, c.origin AS Origin;

🏆 2.3 Find Battles Won by a Character or Their Allies
MATCH (c:Character {name:'Rama'})-[:RELATION*1..2]->(e:Event {subtype:'Battle'})
WHERE e.description CONTAINS 'Victory'
RETURN DISTINCT e.name AS Battle, e.origin AS Yuga, e.description;

💫 3. Relationships & Lineage
🧬 3.1 Show All Relationships Between Two Characters
MATCH (a:Character {name:'Rama'})-[r:RELATION]-(b:Character {name:'Hanuman'})
RETURN a.name, r.type AS Relationship, r.context, b.name;

🩸 3.2 Get Parental Lineage
MATCH (child:Character {name:'Kartikeya'})-[:RELATION {type:'Child Of'}]->(parent:Character)
RETURN child.name AS Child, parent.name AS Parent;

🌺 3.3 Show Marital Connections
MATCH (a:Character)-[:RELATION {type:'Consort'}]-(b:Character)
RETURN a.name AS Partner1, b.name AS Partner2
ORDER BY Partner1;

🧠 4. Symbolism, Virtues & Concepts
🌿 4.1 Characters Representing a Concept (e.g., Dharma)
MATCH (c:Character)-[r:RELATION {type:'Symbolizes'}]->(d:Concept {name:'Dharma'})
RETURN c.name AS Character, r.context AS Description, r.confidence AS Relevance
ORDER BY Relevance DESC;

💭 4.2 Concepts Associated with a Character
MATCH (c:Character {name:'Krishna'})-[r:RELATION {type:'Symbolizes'}]->(con:Concept)
RETURN con.name AS Concept, con.description AS Meaning, r.confidence AS Relevance;

☯️ 4.3 Archetypes with Ethical Polarity
MATCH (con:Concept)
WHERE con.ethical_polarity IN ['Good', 'Evil']
RETURN con.name AS Concept, con.ethical_polarity AS Polarity, con.archetype;

🪶 5. Scriptures, Yugas & Text Sources
📚 5.1 Characters Appearing in a Scripture
MATCH (c:Character)-[:RELATION {type:'Referenced In'}]->(s:Scripture)
WHERE s.name = 'Ramayana'
RETURN c.name AS Character, c.type AS Type, c.origin AS Origin;

🕰 5.2 Events in a Yuga
MATCH (e:Event)
WHERE e.origin = 'Dvapara Yuga'
RETURN e.name AS Event, e.subtype AS Type, e.description;

🌸 5.3 Compare Dharma across Yugas
MATCH (c:Character)-[:RELATION {type:'Symbolizes'}]->(con:Concept {name:'Dharma'})
RETURN c.name AS Character, c.origin AS Origin, con.ethical_polarity AS Polarity;

🎥 6. Media Integration
🎬 6.1 List All Media Linked to a Character
MATCH (c:Character {name:'Rama'})-[:RELATION {type:'Depicted In'}]->(m:Media)
RETURN m.url AS Media_URL, m.media_type AS Type, m.caption AS Description;

🔊 6.2 Find Videos or Audio Narrations for an Event
MATCH (e:Event {name:'Battle of Lanka'})-[:RELATION {type:'Depicted In'}]->(m:Media)
RETURN m.url AS Media_URL, m.caption AS Description;

🔎 7. Knowledge Graph Discovery Queries
🕸 7.1 Explore Character Network
MATCH path=(c:Character {name:'Rama'})-[*1..3]-(related)
RETURN path LIMIT 25;

🌐 7.2 Find All Connected Entities for a Concept
MATCH path=(con:Concept {name:'Karma'})-[*1..2]-(entity)
RETURN path;

🔄 7.3 Shortest Path Between Two Characters
MATCH path=shortestPath((a:Character {name:'Rama'})-[*..5]-(b:Character {name:'Krishna'}))
RETURN path;

🧩 8. Analytics & Meta Queries
📊 8.1 Count Nodes by Type
MATCH (n)
RETURN n.type AS Type, count(n) AS Count
ORDER BY Count DESC;

📊 8.2 Most Common Relationship Types
MATCH ()-[r:RELATION]->()
RETURN r.type AS Relationship, count(*) AS Frequency
ORDER BY Frequency DESC
LIMIT 10;

📊 8.3 Characters with the Most Connections
MATCH (c:Character)-[r]-()
RETURN c.name AS Character, count(r) AS Relationships
ORDER BY Relationships DESC
LIMIT 10;

🧭 9. Debug & Maintenance
⚙️ 9.1 Check for Duplicate UUIDs
MATCH (n)
WITH n.uuid AS id, count(*) AS cnt
WHERE cnt > 1
RETURN id, cnt;

⚙️ 9.2 Remove Orphaned Relations
MATCH ()-[r:RELATION]->()
WHERE r.type IS NULL
DELETE r;

⚙️ 9.3 Drop All Data (Development Only)
MATCH (n)
DETACH DELETE n;

✅ Summary
Category	Purpose
Characters	Avatars, lineage, devotion
Events	Participation, victories, Yugas
Concepts	Dharma, Karma, Bhakti, Adharma
Scriptures	Contextual origins
Graph	Traversal, shortest paths, clustering
Media	Video/audio associations
🧠 Recommended Usage

🔍 Test in Neo4j Browser for validation

⚙️ Integrate into your chatbot’s query templates (e.g., getAvatarsOf(Vishnu))

📊 Use in graph analytics dashboards (e.g., Gephi, Bloom, or NeoDash)