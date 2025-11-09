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
