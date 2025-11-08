-- V7__graph_views.sql
-- Create views for Neo4j sync

CREATE OR REPLACE VIEW graph_nodes_view AS
SELECT uuid AS node_id, 'Character' AS label,
       canonical_name AS name, description, attributes, symbolism
FROM characters
UNION ALL
SELECT uuid, 'Event', name, description, NULL, NULL FROM events
UNION ALL
SELECT uuid, 'Concept', name, description, symbolism, NULL FROM concepts;

CREATE OR REPLACE VIEW graph_edges_view AS
SELECT r.uuid AS edge_id, r.source_uuid AS source_id, r.target_uuid AS target_id,
       r.relation_type, r.context, 'CharacterRel' AS edge_category
FROM relationships r
UNION ALL
SELECT gen_random_uuid(), ep.character_uuid, e.uuid,
       'PARTICIPATED_IN', ep.context, 'EventParticipation'
FROM events e JOIN event_participants ep ON e.uuid = ep.event_uuid
UNION ALL
SELECT ect.id::text::uuid, ect.entity_uuid, ect.concept_uuid,
       'HAS_CONCEPT', ect.context, 'ConceptTag'
FROM entity_concept_tags ect;
