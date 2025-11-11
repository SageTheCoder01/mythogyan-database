// ================================================================
// 🕉️ MythoGyan Knowledge Graph Setup — Neo4j Constraints & Indexes
// ------------------------------------------------
// Description: Ensures data consistency and fast upserts for nodes & edges.
// Author: Mythogyan Dev Team
// ================================================================

// ================================================================
// 🌟 Core Constraints (UUID-based Uniqueness)
// ================================================================

CREATE CONSTRAINT character_uuid_unique IF NOT EXISTS
FOR (c:Character)
REQUIRE c.uuid IS UNIQUE;

CREATE CONSTRAINT concept_uuid_unique IF NOT EXISTS
FOR (c:Concept)
REQUIRE c.uuid IS UNIQUE;

CREATE CONSTRAINT event_uuid_unique IF NOT EXISTS
FOR (e:Event)
REQUIRE e.uuid IS UNIQUE;

CREATE CONSTRAINT scripture_uuid_unique IF NOT EXISTS
FOR (s:Scripture)
REQUIRE s.uuid IS UNIQUE;

CREATE CONSTRAINT weapon_uuid_unique IF NOT EXISTS
FOR (w:Weapon)
REQUIRE w.uuid IS UNIQUE;

CREATE CONSTRAINT relation_uuid_unique IF NOT EXISTS
FOR ()-[r:RELATION]-()
REQUIRE r.uuid IS UNIQUE;

// ================================================================
// ⚡ Indexes for Common Queries
// ================================================================

CREATE INDEX node_name_index IF NOT EXISTS
FOR (n)
ON (n.name);

CREATE INDEX node_type_index IF NOT EXISTS
FOR (n)
ON (n.type);

CREATE INDEX node_alignment_index IF NOT EXISTS
FOR (n)
ON (n.alignment);

CREATE INDEX relation_type_index IF NOT EXISTS
FOR ()-[r:RELATION]-()
ON (r.type);

CREATE INDEX relation_context_index IF NOT EXISTS
FOR ()-[r:RELATION]-()
ON (r.context);

// ================================================================
// 🔎 Optional: Derived Semantic Node Labels
// ------------------------------------------------
// Adds dynamic labels for easier querying in Browser/UI visualization
// ================================================================

CALL apoc.create.addLabels(
    ['Character', 'Concept', 'Event', 'Scripture', 'Weapon']
) YIELD node
RETURN count(node);

// ================================================================
// ✅ Verification Queries
// ================================================================

// Count nodes per type
MATCH (n)
RETURN n.type AS Type, count(n) AS Count
ORDER BY Count DESC;

// Count relationships per type
MATCH ()-[r:RELATION]->()
RETURN r.type AS Relationship, count(r) AS Count
ORDER BY Count DESC;

// Show sample connections
MATCH (a)-[r:RELATION]->(b)
RETURN a.name, r.type, b.name
LIMIT 15;
