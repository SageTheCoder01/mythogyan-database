-- 02_relationships.sql
-- Enhanced relationships table with normalized types, multilingual-ready, and bidirectional support

------------------------------------------------------------
-- 🔗 Relationships
-- Already defined in 01_core_tables.sql
-- This file focuses on views and indexes
------------------------------------------------------------

------------------------------------------------------------
-- 📊 Relationship Summary View
-- Shows source, target, type, context, and confidence
------------------------------------------------------------
CREATE OR REPLACE VIEW relationship_summary AS
SELECT 
    r.uuid AS relationship_uuid, 
    s.canonical_name AS source_name, 
    t.canonical_name AS target_name, 
    rt.name AS relation_type,
    r.context,
    r.confidence_score,
    r.is_bidirectional,
    r.created_at
FROM relationships r
JOIN characters s ON s.uuid = r.source_uuid
JOIN characters t ON t.uuid = r.target_uuid
LEFT JOIN relationship_types rt ON rt.uuid = r.relation_type_uuid;

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_relationship_source ON relationships(source_uuid);
CREATE INDEX idx_relationship_target ON relationships(target_uuid);
CREATE INDEX idx_relationship_type ON relationships(relation_type_uuid);

------------------------------------------------------------
-- 🔍 Optional: Check missing translations for relationships
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_relationship_translations AS
SELECT r.uuid AS relationship_uuid,
       rt.name AS relation_type,
       r.context
FROM relationships r
LEFT JOIN translations t
  ON t.entity_uuid = r.uuid
 AND t.entity_type = 'relationship'
WHERE t.id IS NULL;
