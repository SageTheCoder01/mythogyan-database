-- ================================================================
-- 🕉️ MythoGyan Knowledge Base - Schema Initialization
-- Version: V1__init.sql
-- Description: Base schema for mythological knowledge system
-- Author: Mythogyan Dev Team
-- ================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ================================================================
-- CHARACTERS
-- ================================================================
CREATE TABLE characters (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    canonical_name TEXT NOT NULL,
    aliases TEXT[],
    description TEXT,
    origin TEXT,
    caste_or_role TEXT,
    type TEXT,
    gender TEXT,
    alignment TEXT,
    attributes JSONB,
    symbolism JSONB,
    source_texts TEXT[],
    birth_event_uuid UUID,
    death_event_uuid UUID,
    father_uuid UUID,
    mother_uuid UUID,
    primary_scripture_uuid UUID,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE titles_and_epithets (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    character_uuid UUID REFERENCES characters(uuid),
    title TEXT,
    epithet TEXT,
    source_reference TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE marriages (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    spouse1_uuid UUID REFERENCES characters(uuid),
    spouse2_uuid UUID REFERENCES characters(uuid),
    marriage_event_uuid UUID,
    context TEXT,
    children_uuids UUID[],
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- RELATIONSHIPS
-- ================================================================
CREATE TABLE relationship_types (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    category TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE relationships (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_uuid UUID REFERENCES characters(uuid),
    target_uuid UUID REFERENCES characters(uuid),
    relation_type_uuid UUID REFERENCES relationship_types(uuid),
    context TEXT,
    source_reference TEXT,
    confidence_score NUMERIC,
    is_bidirectional BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- LOCATIONS, EPOCHS, EVENTS
-- ================================================================
CREATE TABLE locations (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    historical_name TEXT,
    type TEXT,
    description TEXT,
    latitude NUMERIC,
    longitude NUMERIC,
    current_country TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE epochs (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    order_index INT,
    description TEXT,
    start_event_uuid UUID,
    end_event_uuid UUID,
    yuga_type TEXT
);

CREATE TABLE events (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid),
    location_uuid UUID REFERENCES locations(uuid),
    scripture_section_uuid UUID,
    start_order INT,
    end_order INT,
    event_type TEXT,
    parent_event_uuid UUID,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE event_participants (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid),
    character_uuid UUID REFERENCES characters(uuid),
    role TEXT,
    context TEXT
);

CREATE TABLE duel_events (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_uuid UUID REFERENCES events(uuid),
    participant1_uuid UUID REFERENCES characters(uuid),
    participant2_uuid UUID REFERENCES characters(uuid),
    outcome TEXT,
    artifact_used_uuids UUID[],
    powers_used JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- SCRIPTURES
-- ================================================================
CREATE TABLE scriptures (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    type TEXT,
    description TEXT,
    estimated_period TEXT,
    cultural_region TEXT,
    language TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE scripture_sections (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scripture_uuid UUID REFERENCES scriptures(uuid),
    section_name TEXT,
    reference_code TEXT,
    summary TEXT,
    start_verse INT,
    end_verse INT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- ARTIFACTS, WEAPONS, POWERS
-- ================================================================
CREATE TABLE artifacts (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    type TEXT,
    material TEXT,
    owner_uuid UUID REFERENCES characters(uuid),
    creator_uuid UUID REFERENCES characters(uuid),
    significance TEXT,
    powers JSONB,
    source_reference TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE artifact_transfers (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artifact_uuid UUID REFERENCES artifacts(uuid),
    from_uuid UUID REFERENCES characters(uuid),
    to_uuid UUID REFERENCES characters(uuid),
    transfer_event_uuid UUID REFERENCES events(uuid),
    context TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE weapons_catalog (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    deity_association_uuid UUID REFERENCES characters(uuid),
    weapon_type TEXT,
    elemental_affinity TEXT,
    scripture_reference_uuid UUID REFERENCES scriptures(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE weapon_traits (
    id SERIAL PRIMARY KEY,
    weapon_uuid UUID REFERENCES weapons_catalog(uuid),
    trait_name TEXT,
    trait_value TEXT
);

CREATE TABLE powers (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    granted_by_uuid UUID REFERENCES characters(uuid),
    received_by_uuid UUID REFERENCES characters(uuid),
    type TEXT,
    context TEXT,
    source_reference TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- BOONS & CURSES
-- ================================================================
CREATE TABLE boons_and_curses (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    giver_uuid UUID REFERENCES characters(uuid),
    receiver_uuid UUID REFERENCES characters(uuid),
    type TEXT,
    reason TEXT,
    scripture_reference_uuid UUID REFERENCES scriptures(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE conditions (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    associated_boon_curse_uuid UUID REFERENCES boons_and_curses(uuid),
    description TEXT,
    fulfilled_event_uuid UUID REFERENCES events(uuid),
    status TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- TEMPLES & FESTIVALS
-- ================================================================
CREATE TABLE temples (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    location_uuid UUID REFERENCES locations(uuid),
    dedicated_to_uuid UUID REFERENCES characters(uuid),
    description TEXT,
    festival_associations TEXT[],
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE festivals (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    associated_event_uuid UUID REFERENCES events(uuid),
    month TEXT,
    cultural_region TEXT,
    scripture_reference_uuid UUID REFERENCES scriptures(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE festival_participants (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    festival_uuid UUID REFERENCES festivals(uuid),
    character_uuid UUID REFERENCES characters(uuid),
    role TEXT,
    context TEXT
);

-- ================================================================
-- CHARACTERISTICS & CONCEPTS
-- ================================================================
CREATE TABLE characteristics (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT,
    polarity TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE entity_characteristics (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID,
    entity_type TEXT,
    characteristic_uuid UUID REFERENCES characteristics(uuid),
    intensity_score NUMERIC(3,2),
    context TEXT
);

CREATE TABLE concepts (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
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

CREATE TABLE entity_concept_tags (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID,
    entity_type TEXT,
    concept_uuid UUID REFERENCES concepts(uuid),
    relevance_score NUMERIC,
    context TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================================================
-- MYTHOLOGICAL CYCLES
-- ================================================================
CREATE TABLE mythological_cycles (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    type TEXT,
    order_index INT,
    parent_cycle_uuid UUID,
    duration_years BIGINT,
    presiding_deity_uuid UUID REFERENCES characters(uuid),
    description TEXT
);

CREATE TABLE reincarnations (
    id SERIAL PRIMARY KEY,
    previous_uuid UUID REFERENCES characters(uuid),
    next_uuid UUID REFERENCES characters(uuid),
    cycle_order INT,
    context TEXT,
    incarnation_type TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid)
);

-- ================================================================
-- MEDIA & HISTORY
-- ================================================================
CREATE TABLE media (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_uuid UUID,
    entity_type TEXT,
    media_type TEXT,
    url TEXT,
    caption TEXT,
    playlist TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE media_tags (
    id SERIAL PRIMARY KEY,
    media_uuid UUID REFERENCES media(uuid),
    tag TEXT,
    relevance_score NUMERIC,
    context TEXT
);

CREATE TABLE entity_history (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID,
    entity_type TEXT,
    field_name TEXT,
    old_value TEXT,
    new_value TEXT,
    change_type TEXT,
    approval_status TEXT,
    changed_by TEXT,
    changed_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE graph_sync_status (
    entity_uuid UUID PRIMARY KEY,
    entity_type TEXT,
    last_synced_at TIMESTAMPTZ,
    sync_status TEXT
);
