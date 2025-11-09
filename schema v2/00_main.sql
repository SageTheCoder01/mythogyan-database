-- 01_core_tables.sql
-- Core entity tables for MythoGyan Knowledge Base (Enhanced)
-- Features: UUID PKs, multilingual-ready, lineage, media, audit/versioning

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

------------------------------------------------------------
-- 🧙 Characters
------------------------------------------------------------
CREATE TABLE characters (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    canonical_name TEXT NOT NULL UNIQUE,
    aliases TEXT[],
    description TEXT,
    origin TEXT,
    father_uuid UUID REFERENCES characters(uuid),
    mother_uuid UUID REFERENCES characters(uuid),
    type TEXT,          -- God, Demon, Human, Sage, etc.
    gender TEXT,
    alignment TEXT,     -- Good, Evil, Neutral
    attributes JSONB,   -- {"weapon":"Trishul","mount":"Nandi"}
    symbolism JSONB,    -- {"represents":"Destruction and Renewal"}
    source_texts TEXT[], -- References to texts/epics
    birth_event_uuid UUID REFERENCES events(uuid),
    death_event_uuid UUID REFERENCES events(uuid),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN DEFAULT TRUE
);

------------------------------------------------------------
-- 🌐 Relationship Types
------------------------------------------------------------
CREATE TABLE relationship_types (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,           -- Father, Consort, Avatar, Sibling, Enemy, etc.
    description TEXT,                    -- Optional description of relationship type
    category TEXT,                       -- familial, divine, friendly, adversarial
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🔗 Relationships
------------------------------------------------------------
CREATE TABLE relationships (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_uuid UUID NOT NULL REFERENCES characters(uuid),
    target_uuid UUID NOT NULL REFERENCES characters(uuid),
    relation_type_uuid UUID REFERENCES relationship_types(uuid),
    context TEXT,                        -- Description/context of relationship
    source_reference TEXT,               -- Textual sources / scriptures
    confidence_score NUMERIC(3,2) DEFAULT 1.0,
    is_bidirectional BOOLEAN DEFAULT FALSE,  -- TRUE if the relationship is symmetric
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🪔 Artifacts
------------------------------------------------------------
CREATE TABLE artifacts (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    material TEXT,
    owner_uuid UUID REFERENCES characters(uuid),
    creator_uuid UUID REFERENCES characters(uuid),
    significance TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 📜 Texts / Scriptures / Quotes
------------------------------------------------------------
CREATE TABLE texts (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT,
    language_code TEXT DEFAULT 'sa',      -- 'sa' = Sanskrit, 'en' = English
    type TEXT,                            -- Epic, Purana, Quote
    content TEXT,
    source_reference TEXT,
    related_entities UUID[],
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🌌 Events
------------------------------------------------------------
CREATE TABLE events (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid),
    location TEXT,
    involved_entities UUID[],
    start_order INT,
    end_order INT,
    event_type TEXT,                       -- Battle, Birth, Miracle, etc.
    parent_event_uuid UUID REFERENCES events(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🎭 Event Participants
------------------------------------------------------------
CREATE TABLE event_participants (
    id SERIAL PRIMARY KEY,
    event_uuid UUID NOT NULL REFERENCES events(uuid),
    character_uuid UUID NOT NULL REFERENCES characters(uuid),
    role TEXT,          -- Warrior, Witness, Sage, etc.
    context TEXT        -- Multilingual-ready via translations
);

------------------------------------------------------------
-- 🌱 Concepts / Ontology
------------------------------------------------------------
CREATE TABLE concepts (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT,               -- Ethical, Philosophical, Archetype
    symbolism JSONB,
    ethical_polarity TEXT,       -- Good, Evil, Neutral
    archetype TEXT,              -- Creator, Destroyer, Protector
    symbolic_color TEXT,
    cultural_region TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE concept_hierarchy (
    id SERIAL PRIMARY KEY,
    parent_uuid UUID REFERENCES concepts(uuid),
    child_uuid UUID REFERENCES concepts(uuid),
    relation_type TEXT DEFAULT 'is_a',
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE entity_concept_tags (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,   -- character, artifact, event, etc.
    concept_uuid UUID REFERENCES concepts(uuid),
    relevance_score NUMERIC(3,2) DEFAULT 1.0,
    context TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🌐 Translations
------------------------------------------------------------
CREATE TABLE translations (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,         -- character, artifact, event, concept, text
    language_code TEXT NOT NULL,       -- en, hi, ta, etc.
    field_name TEXT NOT NULL,          -- canonical_name, description, role, significance, content
    translated_text TEXT NOT NULL,
    is_fallback BOOLEAN DEFAULT FALSE, -- TRUE for default language
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(entity_uuid, language_code, field_name)
);

------------------------------------------------------------
-- ⏳ Epochs / Yugas
------------------------------------------------------------
CREATE TABLE epochs (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE,
    order_index INT,
    description TEXT,
    start_event_uuid UUID REFERENCES events(uuid),
    end_event_uuid UUID REFERENCES events(uuid),
    yuga_type TEXT                  -- Satya, Treta, Dvapara, Kali
);

------------------------------------------------------------
-- 🔁 Reincarnations
------------------------------------------------------------
CREATE TABLE reincarnations (
    id SERIAL PRIMARY KEY,
    previous_uuid UUID REFERENCES characters(uuid),
    next_uuid UUID REFERENCES characters(uuid),
    cycle_order INT,
    context TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid)
);

------------------------------------------------------------
-- 🌍 Traditions & Variants
------------------------------------------------------------
CREATE TABLE traditions (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE,
    region TEXT,
    description TEXT
);

CREATE TABLE entity_variants (
    id SERIAL PRIMARY KEY,
    base_entity_uuid UUID NOT NULL,
    variant_name TEXT,
    tradition_uuid UUID REFERENCES traditions(uuid),
    variant_details JSONB,
    source_reference TEXT
);

------------------------------------------------------------
-- 🖼️ Media
------------------------------------------------------------
CREATE TABLE media (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,    -- character, artifact, event, concept, text
    media_type TEXT,              -- image, audio, video
    url TEXT NOT NULL,
    caption TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 📝 Entity History / Audit
------------------------------------------------------------
CREATE TABLE entity_history (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,
    field_name TEXT NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_by TEXT,
    changed_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🔗 Graph Sync
------------------------------------------------------------
CREATE TABLE graph_sync_status (
    entity_uuid UUID PRIMARY KEY,
    entity_type TEXT,
    last_synced_at TIMESTAMPTZ,
    sync_status TEXT DEFAULT 'PENDING'
);

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

-- 03_events.sql
-- Enhanced events, participants, hierarchy, epochs, and multilingual readiness

------------------------------------------------------------
-- 🌌 Events
-- Already defined in 01_core_tables.sql
-- This file focuses on views, full-text search, and indexes
------------------------------------------------------------

------------------------------------------------------------
-- 📊 Event Summary View
-- Shows events with participants, roles, and context
------------------------------------------------------------
CREATE OR REPLACE VIEW event_summary AS
SELECT 
    e.uuid AS event_uuid,
    e.name AS event_name,
    e.event_type,
    e.location,
    e.epoch_uuid,
    ep.character_uuid,
    c.canonical_name AS character_name,
    ep.role,
    ep.context AS participant_context,
    e.parent_event_uuid,
    e.start_order,
    e.end_order,
    e.created_at
FROM events e
LEFT JOIN event_participants ep ON ep.event_uuid = e.uuid
LEFT JOIN characters c ON c.uuid = ep.character_uuid;

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_event_name ON events(name);
CREATE INDEX idx_event_epoch ON events(epoch_uuid);
CREATE INDEX idx_event_parent ON events(parent_event_uuid);
CREATE INDEX idx_event_type ON events(event_type);
CREATE INDEX idx_event_participants_event ON event_participants(event_uuid);
CREATE INDEX idx_event_participants_character ON event_participants(character_uuid);

------------------------------------------------------------
-- 🔍 Full Text Search Trigger for Events
------------------------------------------------------------
ALTER TABLE events ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE events
SET search_vector = to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,''));

CREATE FUNCTION trg_events_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.name,'') || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_events 
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW EXECUTE FUNCTION trg_events_search();

------------------------------------------------------------
-- 🔍 Optional: Missing translations check for events
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_event_translations AS
SELECT e.uuid AS event_uuid,
       e.name AS event_name
FROM events e
LEFT JOIN translations t
  ON t.entity_uuid = e.uuid
 AND t.entity_type = 'event'
WHERE t.id IS NULL;

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

-- 05_translations.sql
-- Multilingual translations for all entities in MythoGyan
-- Future-ready with fallback support and missing translations check

------------------------------------------------------------
-- 🌐 Translations Table
------------------------------------------------------------
CREATE TABLE translations (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,             -- Links to any entity (character, artifact, event, concept, text, relationship)
    entity_type TEXT NOT NULL,             -- Entity type, e.g., 'character', 'event', 'concept', 'artifact', 'text', 'relationship'
    language_code TEXT NOT NULL,           -- Language code, e.g., 'en', 'hi', 'ta'
    field_name TEXT NOT NULL,              -- Field being translated, e.g., 'canonical_name', 'description', 'role', 'significance', 'content', 'context'
    translated_text TEXT NOT NULL,         -- The translation itself
    is_fallback BOOLEAN DEFAULT FALSE,     -- TRUE if this is default language
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(entity_uuid, language_code, field_name)
);

------------------------------------------------------------
-- 📊 View: Missing Translations
-- Shows entities missing translations for a specific language
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_translations AS
SELECT 
    t.entity_uuid,
    t.entity_type,
    t.field_name
FROM (
    SELECT 'character' AS entity_type, uuid AS entity_uuid, 'canonical_name' AS field_name FROM characters
    UNION ALL
    SELECT 'character', uuid, 'description' FROM characters
    UNION ALL
    SELECT 'event', uuid, 'name' FROM events
    UNION ALL
    SELECT 'event', uuid, 'description' FROM events
    UNION ALL
    SELECT 'concept', uuid, 'name' FROM concepts
    UNION ALL
    SELECT 'concept', uuid, 'description' FROM concepts
    UNION ALL
    SELECT 'artifact', uuid, 'name' FROM artifacts
    UNION ALL
    SELECT 'artifact', uuid, 'description' FROM artifacts
    UNION ALL
    SELECT 'text', uuid, 'title' FROM texts
    UNION ALL
    SELECT 'text', uuid, 'content' FROM texts
    UNION ALL
    SELECT 'relationship', uuid, 'context' FROM relationships
) t
WHERE NOT EXISTS (
    SELECT 1 
    FROM translations tr
    WHERE tr.entity_uuid = t.entity_uuid
      AND tr.entity_type = t.entity_type
      AND tr.field_name = t.field_name
      AND tr.language_code = 'hi' -- Example: check for Hindi translation
);

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_translations_entity ON translations(entity_uuid);
CREATE INDEX idx_translations_entity_field ON translations(entity_uuid, field_name);
CREATE INDEX idx_translations_language ON translations(language_code);

-- 06_graph_views.sql
-- Graph node and edge views for Neo4j sync (Enhanced MythoGyan)

------------------------------------------------------------
-- 🌐 Nodes View
------------------------------------------------------------
CREATE OR REPLACE VIEW graph_nodes_view AS
-- Characters
SELECT 
    uuid AS node_id,
    'Character' AS label,
    canonical_name AS name,
    description,
    attributes,
    symbolism
FROM characters

UNION ALL
-- Events
SELECT 
    uuid,
    'Event',
    name,
    description,
    NULL,
    NULL
FROM events

UNION ALL
-- Concepts
SELECT 
    uuid,
    'Concept',
    name,
    description,
    symbolism,
    NULL
FROM concepts

UNION ALL
-- Artifacts
SELECT
    uuid,
    'Artifact',
    name,
    description,
    variant_details::jsonb AS attributes,
    NULL
FROM artifacts

UNION ALL
-- Media
SELECT
    uuid,
    'Media',
    caption AS name,
    url AS description,
    NULL,
    NULL
FROM media

UNION ALL
-- Traditions
SELECT
    uuid,
    'Tradition',
    name,
    description,
    NULL,
    NULL
FROM traditions;

------------------------------------------------------------
-- 🔗 Edges View
------------------------------------------------------------
CREATE OR REPLACE VIEW graph_edges_view AS
-- Character Relationships
SELECT
    r.uuid AS edge_id,
    r.source_uuid AS source_id,
    r.target_uuid AS target_id,
    rt.name AS relation_type,
    r.context,
    'CharacterRel' AS edge_category
FROM relationships r
LEFT JOIN relationship_types rt ON rt.uuid = r.relation_type_uuid

UNION ALL
-- Event Participants
SELECT
    gen_random_uuid() AS edge_id,
    ep.character_uuid AS source_id,
    e.uuid AS target_id,
    'PARTICIPATED_IN' AS relation_type,
    ep.context,
    'EventParticipation'
FROM events e
JOIN event_participants ep ON e.uuid = ep.event_uuid

UNION ALL
-- Concept Tags
SELECT
    ect.id::text::uuid AS edge_id,
    ect.entity_uuid AS source_id,
    ect.concept_uuid AS target_id,
    'HAS_CONCEPT' AS relation_type,
    ect.context,
    'ConceptTag'
FROM entity_concept_tags ect

UNION ALL
-- Character Lineage: Father
SELECT
    gen_random_uuid(),
    c.father_uuid,
    c.uuid,
    'FATHER_OF',
    'Father-child lineage',
    'Lineage'
FROM characters c
WHERE c.father_uuid IS NOT NULL

UNION ALL
-- Character Lineage: Mother
SELECT
    gen_random_uuid(),
    c.mother_uuid,
    c.uuid,
    'MOTHER_OF',
    'Mother-child lineage',
    'Lineage'
FROM characters c
WHERE c.mother_uuid IS NOT NULL

UNION ALL
-- Reincarnations
SELECT
    r.id::text::uuid,
    r.previous_uuid,
    r.next_uuid,
    'REINCARNATION_OF',
    r.context,
    'Reincarnation'
FROM reincarnations r

UNION ALL
-- Event Hierarchy (Parent → Child)
SELECT
    gen_random_uuid(),
    e.parent_event_uuid,
    e.uuid,
    'SUB_EVENT_OF',
    'Event hierarchy',
    'EventHierarchy'
FROM events e
WHERE e.parent_event_uuid IS NOT NULL;


-- 07_indexes.sql
-- Indexes, full-text search, and triggers for MythoGyan enhanced schema

------------------------------------------------------------
-- 🟢 JSONB Indexes for faster filtering
------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_char_attributes_jsonb ON characters USING GIN (attributes);
CREATE INDEX IF NOT EXISTS idx_char_symbolism_jsonb ON characters USING GIN (symbolism);

CREATE INDEX IF NOT EXISTS idx_artifacts_significance_jsonb ON artifacts USING GIN (variant_details);
CREATE INDEX IF NOT EXISTS idx_entity_variants_details_jsonb ON entity_variants USING GIN (variant_details);

------------------------------------------------------------
-- 🟢 Full-Text Search
------------------------------------------------------------
-- Characters
ALTER TABLE characters ADD COLUMN IF NOT EXISTS search_vector tsvector;
UPDATE characters
SET search_vector = to_tsvector('english', coalesce(canonical_name,'') || ' ' || coalesce(description,''));

CREATE FUNCTION trg_characters_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.canonical_name,'') || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_characters 
BEFORE INSERT OR UPDATE ON characters
FOR EACH ROW EXECUTE FUNCTION trg_characters_search();

CREATE INDEX IF NOT EXISTS idx_char_search ON characters USING GIN (search_vector);

-- Events
ALTER TABLE events ADD COLUMN IF NOT EXISTS search_vector tsvector;
UPDATE events
SET search_vector = to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,''));

CREATE FUNCTION trg_events_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.name,'') || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_events 
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW EXECUTE FUNCTION trg_events_search();

CREATE INDEX IF NOT EXISTS idx_event_search ON events USING GIN (search_vector);

-- Concepts
ALTER TABLE concepts ADD COLUMN IF NOT EXISTS search_vector tsvector;
UPDATE concepts
SET search_vector = to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,''));

CREATE FUNCTION trg_concepts_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.name,'') || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_concepts 
BEFORE INSERT OR UPDATE ON concepts
FOR EACH ROW EXECUTE FUNCTION trg_concepts_search();

CREATE INDEX IF NOT EXISTS idx_concept_search ON concepts USING GIN (search_vector);

-- Artifacts
ALTER TABLE artifacts ADD COLUMN IF NOT EXISTS search_vector tsvector;
UPDATE artifacts
SET search_vector = to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,'') || ' ' || coalesce(significance,''));

CREATE FUNCTION trg_artifacts_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.name,'') || ' ' || coalesce(NEW.description,'') || ' ' || coalesce(NEW.significance,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_artifacts 
BEFORE INSERT OR UPDATE ON artifacts
FOR EACH ROW EXECUTE FUNCTION trg_artifacts_search();

CREATE INDEX IF NOT EXISTS idx_artifact_search ON artifacts USING GIN (search_vector);

-- Texts
ALTER TABLE texts ADD COLUMN IF NOT EXISTS search_vector tsvector;
UPDATE texts
SET search_vector = to_tsvector('english', coalesce(title,'') || ' ' || coalesce(content,''));

CREATE FUNCTION trg_texts_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.title,'') || ' ' || coalesce(NEW.content,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_texts 
BEFORE INSERT OR UPDATE ON texts
FOR EACH ROW EXECUTE FUNCTION trg_texts_search();

CREATE INDEX IF NOT EXISTS idx_text_search ON texts USING GIN (search_vector);

------------------------------------------------------------
-- 🟢 Performance Indexes for Foreign Keys & Common Queries
------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_relationship_source ON relationships(source_uuid);
CREATE INDEX IF NOT EXISTS idx_relationship_target ON relationships(target_uuid);
CREATE INDEX IF NOT EXISTS idx_relationship_type ON relationships(relation_type_uuid);

CREATE INDEX IF NOT EXISTS idx_event_epoch ON events(epoch_uuid);
CREATE INDEX IF NOT EXISTS idx_event_parent ON events(parent_event_uuid);
CREATE INDEX IF NOT EXISTS idx_event_type ON events(event_type);

CREATE INDEX IF NOT EXISTS idx_event_participants_event ON event_participants(event_uuid);
CREATE INDEX IF NOT EXISTS idx_event_participants_character ON event_participants(character_uuid);

CREATE INDEX IF NOT EXISTS idx_concept_hierarchy_parent ON concept_hierarchy(parent_uuid);
CREATE INDEX IF NOT EXISTS idx_concept_hierarchy_child ON concept_hierarchy(child_uuid);

CREATE INDEX IF NOT EXISTS idx_entity_concept_tags_entity ON entity_concept_tags(entity_uuid);
CREATE INDEX IF NOT EXISTS idx_entity_concept_tags_concept ON entity_concept_tags(concept_uuid);

CREATE INDEX IF NOT EXISTS idx_translations_entity ON translations(entity_uuid);
CREATE INDEX IF NOT EXISTS idx_translations_entity_field ON translations(entity_uuid, field_name);
CREATE INDEX IF NOT EXISTS idx_translations_language ON translations(language_code);

CREATE INDEX IF NOT EXISTS idx_artifacts_owner ON artifacts(owner_uuid);
CREATE INDEX IF NOT EXISTS idx_artifacts_creator ON artifacts(creator_uuid);

CREATE INDEX IF NOT EXISTS idx_reincarnations_previous ON reincarnations(previous_uuid);
CREATE INDEX IF NOT EXISTS idx_reincarnations_next ON reincarnations(next_uuid);
CREATE INDEX IF NOT EXISTS idx_reincarnations_epoch ON reincarnations(epoch_uuid);

CREATE INDEX IF NOT EXISTS idx_entity_variants_base ON entity_variants(base_entity_uuid);
CREATE INDEX IF NOT EXISTS idx_entity_variants_tradition ON entity_variants(tradition_uuid);

CREATE INDEX IF NOT EXISTS idx_media_entity ON media(entity_uuid);

-- 09_temporal_regional.sql
-- Temporal (Yuga) and regional modeling for MythoGyan

------------------------------------------------------------
-- 🕰️ Epochs / Yugas
------------------------------------------------------------
CREATE TABLE epochs (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,            -- Satya Yuga, Treta Yuga, etc.
    order_index INT NOT NULL,             -- Chronological order
    description TEXT,
    start_event_uuid UUID REFERENCES events(uuid),
    end_event_uuid UUID REFERENCES events(uuid),
    yuga_type TEXT                        -- Satya, Treta, Dvapara, Kali
);

-- Sample Epochs
INSERT INTO epochs (name, order_index, description, yuga_type)
VALUES
('Satya Yuga', 1, 'Era of truth and virtue', 'Satya'),
('Treta Yuga', 2, 'Era of partial virtue', 'Treta'),
('Dvapara Yuga', 3, 'Era of diminishing virtue', 'Dvapara'),
('Kali Yuga', 4, 'Era of darkness and strife', 'Kali');

------------------------------------------------------------
-- 🔁 Reincarnations
------------------------------------------------------------
CREATE TABLE reincarnations (
    id SERIAL PRIMARY KEY,
    previous_uuid UUID REFERENCES characters(uuid),
    next_uuid UUID REFERENCES characters(uuid),
    cycle_order INT,
    context TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid)
);

-- Example: Vishnu avatars (to be populated later)
-- INSERT INTO reincarnations (previous_uuid, next_uuid, cycle_order, context, epoch_uuid) VALUES (...);

------------------------------------------------------------
-- 🗓️ Event Timeline
------------------------------------------------------------
CREATE TABLE event_timeline (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid),
    epoch_uuid UUID REFERENCES epochs(uuid),
    start_order INT,
    end_order INT,
    is_cyclical BOOLEAN DEFAULT FALSE
);

-- Example: Linking events to Yugas
-- INSERT INTO event_timeline (event_uuid, epoch_uuid, start_order, end_order, is_cyclical) VALUES (...);

------------------------------------------------------------
-- 🏛️ Traditions
------------------------------------------------------------
CREATE TABLE traditions (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE,
    region TEXT,
    description TEXT
);

-- Example Traditions
INSERT INTO traditions (name, region, description)
VALUES
('Vedic Tradition','North India','Ancient Vedic scriptures and rituals'),
('Tamil Puranic','Tamil Nadu','Regional interpretations of Puranic texts');

------------------------------------------------------------
-- 🧱 Entity Variants
------------------------------------------------------------
CREATE TABLE entity_variants (
    id SERIAL PRIMARY KEY,
    base_entity_uuid UUID NOT NULL,
    variant_name TEXT,
    tradition_uuid UUID REFERENCES traditions(uuid),
    variant_details JSONB,
    source_reference TEXT
);

-- Example Variant
INSERT INTO entity_variants (base_entity_uuid, variant_name, tradition_uuid, variant_details, source_reference)
SELECT c.uuid, 'Shiva (Tamil)', t.uuid, '{"regional_name":"சிவர்"}', 'Tamil Puranas'
FROM characters c, traditions t
WHERE c.canonical_name='Shiva' AND t.region='Tamil';

