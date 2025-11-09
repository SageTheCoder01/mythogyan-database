-- 04_concepts_ontology.sql
-- Enhanced concepts, hierarchy, and semantic tagging

------------------------------------------------------------
-- 🌱 Concepts
-- Already defined in 01_core_tables.sql
-- This file focuses on views, indexes, and multilingual support
------------------------------------------------------------

------------------------------------------------------------
-- 📊 Concept Summary View
-- Shows concept details including hierarchy
------------------------------------------------------------
CREATE OR REPLACE VIEW concept_summary AS
SELECT
    c.uuid AS concept_uuid,
    c.name AS concept_name,
    c.category,
    c.ethical_polarity,
    c.archetype,
    c.symbolic_color,
    c.cultural_region,
    ch.parent_uuid AS parent_concept_uuid,
    p.name AS parent_concept_name,
    ch.relation_type AS hierarchy_relation,
    c.created_at,
    c.updated_at
FROM concepts c
LEFT JOIN concept_hierarchy ch ON ch.child_uuid = c.uuid
LEFT JOIN concepts p ON p.uuid = ch.parent_uuid;

------------------------------------------------------------
-- 📊 Entity Concept Tags Summary
-- Links any entity (character, artifact, event, etc.) to concepts
------------------------------------------------------------
CREATE OR REPLACE VIEW entity_concept_summary AS
SELECT
    ect.id AS tag_id,
    ect.entity_uuid,
    ect.entity_type,
    c.uuid AS concept_uuid,
    c.name AS concept_name,
    ect.relevance_score,
    ect.context,
    ect.created_at
FROM entity_concept_tags ect
LEFT JOIN concepts c ON c.uuid = ect.concept_uuid;

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_concept_name ON concepts(name);
CREATE INDEX idx_concept_category ON concepts(category);
CREATE INDEX idx_concept_hierarchy_parent ON concept_hierarchy(parent_uuid);
CREATE INDEX idx_concept_hierarchy_child ON concept_hierarchy(child_uuid);
CREATE INDEX idx_entity_concept_tags_entity ON entity_concept_tags(entity_uuid);
CREATE INDEX idx_entity_concept_tags_concept ON entity_concept_tags(concept_uuid);

------------------------------------------------------------
-- 🔍 Optional: Missing translations check for concepts
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_concept_translations AS
SELECT c.uuid AS concept_uuid,
       c.name AS concept_name
FROM concepts c
LEFT JOIN translations t
  ON t.entity_uuid = c.uuid
 AND t.entity_type = 'concept'
WHERE t.id IS NULL;
