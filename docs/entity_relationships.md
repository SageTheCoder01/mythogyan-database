# 🕸️ MythoGyan — Entity Relationship Overview

> A narrative and technical overview of how major entities interact in the schema.

---

## 🧙 Characters
- Central node type in the schema.
- Can connect to:
  - Other **characters** via `relationships` (e.g., Consort_of, Avatar_of).
  - **Concepts** via `entity_concept_tags` (e.g., Shiva → Destruction Archetype).
  - **Events** via `event_participants`.
  - **Artifacts** via ownership links.

---

## ⚔️ Events
- Serve as contextual hubs connecting multiple characters.
- Example: “Kurukshetra War”
  - Participants → Krishna (strategist), Arjuna (warrior)
  - Epoch → Dvapara Yuga
  - Concepts → Dharma, Karma

---

## 🧩 Ontology / Concepts
- Define mythological and philosophical **archetypes**.
- Hierarchically structured (`concept_hierarchy`):
  - **Virtue**
    - ↳ Dharma
    - ↳ Satya
  - **Cosmic Roles**
    - ↳ Creator (Brahma)
    - ↳ Destroyer (Shiva)
    - ↳ Preserver (Vishnu)

---

## ⏳ Temporal Entities
- **Epochs** → Represent cyclic Yugas.
- **Reincarnations** → Connect entities across cycles.

Vishnu --(AVATAR_OF)--> Rama
Rama --(BORN_IN)--> Treta Yuga

yaml
Copy code

---

## 🌍 Regional Variants
Handled via `entity_variants`:
- Allow different traditions (Tamil, Bengali, etc.) to express alternate interpretations.

Example:
Shiva (canonical)
├── variant: Sivan (Tamil)
├── variant: Mahadeva (North India)

yaml
Copy code

---

## 🔗 Relationship Map Example (Simplified)

(Character) --[Consort_of]--> (Character)
(Character) --[Avatar_of]--> (Character)
(Character) --[Participated_in]--> (Event)
(Event) --[Happened_in]--> (Epoch)
(Character) --[Tagged_with]--> (Concept)
(Concept) --[is_a]--> (Concept)

yaml
Copy code

---

## 🧠 Semantic Layers
The schema supports **multiple abstraction levels**:

| Layer | Entities | Description |
|--------|-----------|-------------|
| Core | Characters, Events | Basic relational facts |
| Semantic | Concepts, Ontology | Meaning and symbolism |
| Temporal | Epochs, Reincarnations | Time-bound context |
| Regional | Variants, Translations | Localization layer |
| Graph | Views, Neo4j sync | Traversable relationships |

---

This modular design allows:
- Straight SQL queries for factual data
- Graph queries (Cypher) for reasoning-based searches
- AI models to use ontology tags for context-aware answers