-- 04_concepts_ontology.sql
-- Ontology and semantic tagging system

CREATE TABLE concepts (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT,              -- Ethical, Philosophical, Archetype
    symbolism JSONB,
    ethical_polarity TEXT,       -- Good, Evil, Neutral
    archetype TEXT,              -- Creator, Destroyer, Protector, etc.
    symbolic_color TEXT,
    cultural_region TEXT,        -- Vedic, Tamil, Puranic
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE concept_hierarchy (
    id SERIAL PRIMARY KEY,
    parent_uuid UUID REFERENCES concepts(uuid),
    child_uuid  UUID REFERENCES concepts(uuid),
    relation_type TEXT DEFAULT 'is_a',
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE entity_concept_tags (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,
    concept_uuid UUID REFERENCES concepts(uuid),
    relevance_score NUMERIC(3,2) DEFAULT 1.0,
    context TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
