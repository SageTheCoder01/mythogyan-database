-- 03_events.sql
-- Mythological events, battles, and participants

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    epoch TEXT,           -- Satya Yuga, Treta Yuga, etc.
    location TEXT,
    involved_entities UUID[],
    start_order INTEGER,
    end_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Linking participants with roles
CREATE TABLE event_participants (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid),
    character_uuid UUID REFERENCES characters(uuid),
    role TEXT,  -- Warrior, Witness, Sage, etc.
    context TEXT
);
