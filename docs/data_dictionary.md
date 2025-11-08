# 📘 MythoGyan Data Dictionary

> The Data Dictionary describes every major table, column, and its purpose in the MythoGyan Knowledge Base.
> It serves as a reference for backend developers, data curators, and AI integration.

---

## 🧙 Table: `characters`
Stores all mythological characters — deities, humans, demons, sages, etc.

| Column | Type | Description |
|---------|------|-------------|
| id | SERIAL | Internal numeric ID |
| uuid | UUID | Global unique ID for API and relations |
| canonical_name | TEXT | Primary name used across all references |
| aliases | TEXT[] | Alternate names and spellings |
| description | TEXT | Narrative description |
| origin | TEXT | Source (Veda, Purana, Epic, etc.) |
| type | TEXT | e.g., Deity, Human, Demon, Sage |
| gender | TEXT | Male / Female / Neutral |
| alignment | TEXT | Good, Evil, Neutral |
| attributes | JSONB | Flexible metadata — e.g., {"weapon":"Trishul"} |
| symbolism | JSONB | Represents abstract meaning, e.g., {"represents":"Renewal"} |
| created_at | TIMESTAMPTZ | Record creation timestamp |
| updated_at | TIMESTAMPTZ | Record update timestamp |
| is_active | BOOLEAN | Marks deprecated or hidden entries |

---

## 🧩 Table: `relationships`
Defines how characters or entities relate to each other.

| Column | Type | Description |
|---------|------|-------------|
| uuid | UUID | Unique relationship ID |
| source_uuid | UUID | First entity (e.g., Shiva) |
| target_uuid | UUID | Second entity (e.g., Parvati) |
| relation_type | TEXT | e.g., Consort_of, Father_of, Avatar_of |
| context | TEXT | Description or notes |
| source_reference | TEXT | Text or scripture source |
| confidence_score | NUMERIC(3,2) | Certainty of relation (1.0 = confirmed) |

---

## ⚔️ Table: `events`
Represents mythological events — wars, sacrifices, births, etc.

| Column | Type | Description |
|---------|------|-------------|
| uuid | UUID | Unique event ID |
| name | TEXT | Event name |
| description | TEXT | Event summary |
| epoch | TEXT | Yuga or era |
| location | TEXT | Geographical / mythical location |
| involved_entities | UUID[] | Characters involved |
| start_order / end_order | INT | Chronological order within epoch |

---

## 🧘 Table: `concepts`
Ontology concepts defining symbolic or philosophical ideas.

| Column | Type | Description |
|---------|------|-------------|
| uuid | UUID | Concept ID |
| name | TEXT | Concept name (e.g., Dharma, Karma) |
| description | TEXT | Concept explanation |
| category | TEXT | Ethical / Philosophical / Archetype |
| ethical_polarity | TEXT | Good, Evil, Neutral |
| archetype | TEXT | Creator, Protector, Destroyer, etc. |
| cultural_region | TEXT | Vedic, Tamil, Puranic, etc. |

---

## 🧩 Table: `entity_concept_tags`
Links characters, artifacts, or events to ontology concepts.

| Column | Type | Description |
|---------|------|-------------|
| entity_uuid | UUID | Refers to character/event/etc. |
| entity_type | TEXT | Entity category |
| concept_uuid | UUID | Concept linked |
| relevance_score | NUMERIC(3,2) | Relevance of link |
| context | TEXT | Notes on how they relate |

---

## 🕰 Table: `epochs`
Represents time periods or Yugas.

| Column | Type | Description |
|---------|------|-------------|
| name | TEXT | e.g., Satya Yuga, Dvapara Yuga |
| order_index | INT | Sequential order |
| description | TEXT | Characteristics of that epoch |

---

## 🔁 Table: `reincarnations`
Links characters across lives.

| Column | Type | Description |
|---------|------|-------------|
| previous_uuid | UUID | Earlier incarnation |
| next_uuid | UUID | Later incarnation |
| context | TEXT | Explanation (e.g., Vishnu → Rama) |

---

## 🌍 Table: `translations`
Handles multilingual text for any entity field.

| Column | Type | Description |
|---------|------|-------------|
| entity_uuid | UUID | Linked entity |
| language_code | TEXT | e.g., hi, en, ta |
| field_name | TEXT | e.g., name, description |
| translated_text | TEXT | Translation content |

---

## 🧱 Table: `graph_sync_status`
Tracks Neo4j sync operations.

| Column | Type | Description |
|---------|------|-------------|
| entity_uuid | UUID | Entity synced |
| entity_type | TEXT | Character/Event/Concept |
| last_synced_at | TIMESTAMPTZ | Last sync timestamp |
| sync_status | TEXT | PENDING, COMPLETE, FAILED |

---

_Last updated: November 2025_
