-- V4__ontology_and_concepts.sql
-- Ontology and concept hierarchy

CREATE TABLE concepts (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT,
    symbolism JSONB,
    ethical_polarity TEXT,
    archetype TEXT,
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
    entity_type TEXT NOT NULL,
    concept_uuid UUID REFERENCES concepts(uuid),
    relevance_score NUMERIC(3,2) DEFAULT 1.0,
    context TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
