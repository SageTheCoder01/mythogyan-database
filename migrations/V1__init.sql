-- V1__init.sql
-- Core entities: characters, texts, artifacts

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    canonical_name TEXT NOT NULL UNIQUE,
    aliases TEXT[],
    description TEXT,
    origin TEXT,
    type TEXT,
    gender TEXT,
    alignment TEXT,
    attributes JSONB,
    symbolism JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE texts (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    title TEXT,
    language TEXT DEFAULT 'Sanskrit',
    type TEXT,
    content TEXT,
    source_reference TEXT,
    related_entities UUID[],
    created_at TIMESTAMPTZ DEFAULT now()
);

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
