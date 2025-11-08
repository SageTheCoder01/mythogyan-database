-- 02_relationships.sql
-- Define character-to-character and entity relationships

CREATE TABLE relationships (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    source_uuid UUID REFERENCES characters(uuid),
    target_uuid UUID REFERENCES characters(uuid),
    relation_type TEXT,        -- Father_of, Consort_of, Avatar_of, etc.
    context TEXT,
    source_reference TEXT,
    confidence_score NUMERIC(3,2) DEFAULT 1.0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Summary View
CREATE OR REPLACE VIEW relationship_summary AS
SELECT r.uuid, s.canonical_name AS source, t.canonical_name AS target, r.relation_type
FROM relationships r
JOIN characters s ON s.uuid = r.source_uuid
JOIN characters t ON t.uuid = r.target_uuid;
