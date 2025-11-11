-- ================================================================
-- 🕉️ MythoGyan Knowledge Base
-- Version: V4__graph_views.sql
-- Description: Graph-oriented views for Neo4j sync and visualization
-- Author: Mythogyan Dev Team
-- ================================================================

-- ================================================================
-- 🌟 GRAPH NODE VIEW
-- ================================================================
-- This view represents all core entities (characters, concepts, events, weapons)
-- unified into a single “node” abstraction for graph export.

CREATE OR REPLACE VIEW graph_nodes_view AS
SELECT 
    c.uuid AS node_id,
    'Character' AS node_type,
    c.canonical_name AS name,
    c.description,
    c.gender,
    c.alignment,
    c.type AS subtype,
    c.origin,
    c.symbolism,
    c.attributes,
    c.created_at,
    c.updated_at
FROM characters c

UNION ALL

SELECT 
    con.uuid AS node_id,
    'Concept' AS node_type,
    con.name AS name,
    con.description,
    NULL AS gender,
    con.ethical_polarity AS alignment,
    con.category AS subtype,
    con.cultural_region AS origin,
    con.symbolism,
    NULL AS attributes,
    con.created_at,
    con.updated_at
FROM concepts con

UNION ALL

SELECT 
    e.uuid AS node_id,
    'Event' AS node_type,
    e.name AS name,
    e.description,
    NULL AS gender,
    NULL AS alignment,
    e.event_type AS subtype,
    (SELECT name FROM epochs WHERE uuid = e.epoch_uuid) AS origin,
    NULL AS symbolism,
    NULL AS attributes,
    e.created_at,
    NULL AS updated_at
FROM events e

UNION ALL

SELECT 
    w.uuid AS node_id,
    'Weapon' AS node_type,
    w.name AS name,
    w.description,
    NULL AS gender,
    NULL AS alignment,
    w.weapon_type AS subtype,
    w.elemental_affinity AS origin,
    NULL AS symbolism,
    NULL AS attributes,
    w.created_at,
    NULL AS updated_at
FROM weapons_catalog w

UNION ALL

SELECT 
    s.uuid AS node_id,
    'Scripture' AS node_type,
    s.name AS name,
    s.description,
    NULL AS gender,
    NULL AS alignment,
    s.type AS subtype,
    s.cultural_region AS origin,
    NULL AS symbolism,
    NULL AS attributes,
    s.created_at,
    NULL AS updated_at
FROM scriptures s;

-- ================================================================
-- 🔗 GRAPH EDGE VIEW
-- ================================================================
-- This view unifies all relationship-like connections (familial, conceptual, participatory)
-- for visualization and graph traversal.

CREATE OR REPLACE VIEW graph_edges_view AS
-- Character Relationships
SELECT
    r.uuid AS edge_id,
    r.source_uuid AS source_id,
    r.target_uuid AS target_id,
    (SELECT name FROM relationship_types WHERE uuid = r.relation_type_uuid) AS edge_type,
    r.context,
    r.confidence_score,
    r.created_at
FROM relationships r

UNION ALL

-- Concept Tags (Character → Concept)
SELECT
    ect.id AS edge_id,
    ect.entity_uuid AS source_id,
    ect.concept_uuid AS target_id,
    'Symbolizes' AS edge_type,
    ect.context,
    ect.relevance_score AS confidence_score,
    ect.created_at
FROM entity_concept_tags ect

UNION ALL

-- Characteristic Mapping (Character → Trait)
SELECT
    ec.id AS edge_id,
    ec.entity_uuid AS source_id,
    ch.uuid AS target_id,
    'Exhibits' AS edge_type,
    ec.context,
    ec.intensity_score AS confidence_score,
    now() AS created_at
FROM entity_characteristics ec
JOIN characteristics ch ON ec.characteristic_uuid = ch.uuid

UNION ALL

-- Event Participants (Character → Event)
SELECT
    ep.id AS edge_id,
    ep.character_uuid AS source_id,
    ep.event_uuid AS target_id,
    'Participated In' AS edge_type,
    ep.role AS context,
    1.0 AS confidence_score,
    now() AS created_at
FROM event_participants ep

UNION ALL

-- Weapon Association (Character → Weapon)
SELECT
    w.uuid AS edge_id,
    w.deity_association_uuid AS source_id,
    w.uuid AS target_id,
    'Wields' AS edge_type,
    'Divine association' AS context,
    1.0 AS confidence_score,
    w.created_at
FROM weapons_catalog w
WHERE w.deity_association_uuid IS NOT NULL;

-- ================================================================
-- 🧩 INDEXES FOR GRAPH PERFORMANCE
-- ================================================================
CREATE INDEX IF NOT EXISTS idx_graph_nodes_id ON graph_nodes_view(node_id);
CREATE INDEX IF NOT EXISTS idx_graph_edges_source ON graph_edges_view(source_id);
CREATE INDEX IF NOT EXISTS idx_graph_edges_target ON graph_edges_view(target_id);
