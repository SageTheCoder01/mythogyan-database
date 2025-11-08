-- V3__events.sql
-- Events and participation mapping

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    epoch TEXT,
    location TEXT,
    involved_entities UUID[],
    start_order INT,
    end_order INT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE event_participants (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid),
    character_uuid UUID REFERENCES characters(uuid),
    role TEXT,
    context TEXT
);
