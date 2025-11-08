-- 01_core_tables.sql
-- Core entity tables for MythoGyan Knowledge Base

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 🧙 Characters
CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    canonical_name TEXT NOT NULL UNIQUE,
    aliases TEXT[],
    description TEXT,
    origin TEXT,
    type TEXT,          -- God, Demon, Human, Sage, etc.
    gender TEXT,
    alignment TEXT,     -- Good, Evil, Neutral
    attributes JSONB,   -- {"weapon":"Trishul","mount":"Nandi"}
    symbolism JSONB,    -- {"represents":"Destruction and Renewal"}
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN DEFAULT true
);

-- 📜 Texts / Scriptures / Quotes
CREATE TABLE texts (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    title TEXT,
    language TEXT DEFAULT 'Sanskrit',
    type TEXT,  -- Epic, Purana, Quote, etc.
    content TEXT,
    source_reference TEXT,
    related_entities UUID[],
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 🪔 Artifacts
CREATE TABLE artifacts (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    material TEXT,
    owner_uuid UUID REFERENCES characters(uuid),
    significance TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
