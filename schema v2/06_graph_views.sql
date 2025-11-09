-- 06_graph_views.sql
-- Graph node and edge views for Neo4j sync
-- Fully aligned with enhanced schema

------------------------------------------------------------
-- 📌 Graph Nodes
------------------------------------------------------------
CREATE OR REPLACE VIEW graph_nodes_view AS
-- Characters
SELECT
    uuid AS node_id,
    'Character' AS label,
    canonical_name AS name,
    description,
    attributes,
    symbolism,
    created_at
FROM characters

UNION ALL
-- Events
SELECT
    uuid,
    'Event' AS label,
    name,
    description,
    NULL::jsonb,
    NULL::jsonb,
    created_at
FROM events

UNION ALL
-- Concepts
SELECT
    uuid,
    'Concept' AS label,
    name,
    description,
    symbolism,
    NULL::jsonb,
    created_at
FROM concepts

UNION ALL
-- Artifacts
SELECT
    a.uuid,
    'Artifact' AS label,
    a.name,
    a.description,
    a.attributes,
    a.symbolism,
    a.created_at
FROM artifacts a

UNION ALL
-- Media
SELECT
    uuid,
    'Media' AS label,
    media_type AS name,
    caption AS description,
    NULL::jsonb,
    NULL::jsonb,
    created_at
FROM media

UNION ALL
-- Entity Variants
SELECT
    uuid,
    'EntityVariant' AS label,
    variant_name AS name,
    NULL::text AS description,
    variant_details AS attributes,
    NULL::jsonb,
    created_at
FROM entity_variants

UNION ALL
-- Texts
SELECT
    uuid,
    'Text' AS label,
    title AS name,
    content AS description,
    NULL::jsonb,
    NULL::jsonb,
    created_at
FROM texts;

------------------------------------------------------------
-- 📌 Graph Edges
------------------------------------------------------------
CREATE OR REPLACE VIEW graph_edges_view AS
-- Character Relationships
SELECT
    r.uuid AS edge_id,
    r.source_uuid AS source_id,
    r.target_uuid AS target_id,
    rt.name AS relation_type,
    r.context AS metadata,
    'CharacterRel' AS edge_category
FROM relationships r
LEFT JOIN relationship_types rt ON rt.uuid = r.relation_type_uuid

UNION ALL
-- Event Participation
SELECT
    gen_random_uuid() AS edge_id,
    ep.character_uuid AS source_id,
    e.uuid AS target_id,
    'PARTICIPATED_IN' AS relation_type,
    ep.role AS metadata,
    'EventParticipation' AS edge_category
FROM event_participants ep
JOIN events e ON e.uuid = ep.event_uuid

UNION ALL
-- Entity Concept Tags
SELECT
    ect.id::text::uuid AS edge_id,
    ect.entity_uuid AS source_id,
    ect.concept_uuid AS target_id,
    'HAS_CONCEPT' AS relation_type,
    ect.context AS metadata,
    'ConceptTag' AS edge_category
FROM entity_concept_tags ect

UNION ALL
-- Reincarnations
SELECT
    r.id::text::uuid AS edge_id,
    r.previous_uuid AS source_id,
    r.next_uuid AS target_id,
    'REINCARNATED_AS' AS relation_type,
    r.context AS metadata,
    'Reincarnation' AS edge_category
FROM reincarnations r

UNION ALL
-- Event Hierarchy
SELECT
    e.uuid AS edge_id,
    e.parent_event_uuid AS source_id,
    e.uuid AS target_id,
    'HAS_SUBEVENT' AS relation_type,
    NULL AS metadata,
    'EventHierarchy' AS edge_category
FROM events e
WHERE e.parent_event_uuid IS NOT NULL

UNION ALL
-- Concept Hierarchy
SELECT
    ch.id::text::uuid AS edge_id,
    ch.parent_uuid AS source_id,
    ch.child_uuid AS target_id,
    ch.relation_type AS relation_type,
    NULL AS metadata,
    'ConceptHierarchy' AS edge_category
FROM concept_hierarchy ch

UNION ALL
-- Entity Variants
SELECT
    ev.id::text::uuid AS edge_id,
    ev.base_entity_uuid AS source_id,
    ev.uuid AS target_id,
    'VARIANT_OF' AS relation_type,
    ev.variant_name AS metadata,
    'EntityVariant' AS edge_category
FROM entity_variants ev;
