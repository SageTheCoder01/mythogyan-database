MythoGyan Conversational Query Mapping
A bridge between natural-language questions → structured Cypher queries used by your backend chatbot.

It’s designed to:

Help your AI agent (like ChatGPT / LangChain backend) translate user intent into Cypher queries

Support multilingual + flexible phrasing (e.g. Hindi/English mix)

Reuse graph structures (Character, Event, Concept, etc.) from your Neo4j schema

Enable efficient real-time answers for the MythoGyan chatbot, Quiz app, and Knowledge explorer.

📘 docs/chatbot_query_templates.md

MythoGyan Chatbot Query Templates
(Natural Language → Cypher Query Reference)

🧙‍♂️ 1. Character Information Queries
❓ “Who is Rama?” / “Tell me about Krishna.”

Intent: Fetch details about a character.
Cypher:

MATCH (c:Character)
WHERE toLower(c.name) CONTAINS toLower($character_name)
RETURN c.name AS Name, c.description AS Description, c.origin AS Origin, c.alignment AS Alignment, c.type AS Type, c.symbolism AS Symbolism;


Input Example: "Rama"
Response Format: Character profile summary

❓ “Who are the avatars of Vishnu?” / “List Vishnu’s incarnations.”

Intent: Find all characters related by Avatar Of relationship.
Cypher:

MATCH (v:Character {name:$character_name})<-[:RELATION {type:'Avatar Of'}]-(a:Character)
RETURN a.name AS Avatar, a.origin AS Origin, a.type AS Type
ORDER BY a.origin;

❓ “Who was the consort of Shiva?” / “Who is Parvati’s husband?”

Intent: Identify spousal/consort relationship.
Cypher:

MATCH (a:Character {name:$character_name})-[r:RELATION {type:'Consort'}]-(b:Character)
RETURN b.name AS Partner, r.context AS Context;

❓ “Who was Krishna’s teacher?” / “Who trained Arjuna?”

Intent: Find teacher–student relationships.
Cypher:

MATCH (teacher:Character)-[:RELATION {type:'Teacher Of'}]->(student:Character {name:$character_name})
RETURN teacher.name AS Teacher, teacher.origin AS Origin;

⚔️ 2. Event & Battle Queries
❓ “In which wars did Arjuna fight?”

Intent: Show battles/events participated in.
Cypher:

MATCH (c:Character {name:$character_name})-[r:RELATION {type:'Participated In'}]->(e:Event)
RETURN e.name AS Event, e.subtype AS Type, e.origin AS Yuga, r.context AS Role;

❓ “Who fought in the Battle of Lanka?”

Intent: List participants in a given event.
Cypher:

MATCH (e:Event {name:$event_name})<-[:RELATION {type:'Participated In'}]-(c:Character)
RETURN c.name AS Participant, c.alignment AS Alignment, c.origin AS Origin;

❓ “Which side won the Kurukshetra War?”

Intent: Retrieve event outcomes.
Cypher:

MATCH (e:Event {name:$event_name})
RETURN e.name AS Event, e.description AS Description, e.origin AS Yuga;

🧬 3. Lineage & Family Queries
❓ “Who were Rama’s parents?” / “Who was Krishna’s father?”

Intent: Get parent–child relationships.
Cypher:

MATCH (child:Character {name:$character_name})-[r:RELATION {type:'Child Of'}]->(parent:Character)
RETURN parent.name AS Parent, r.context AS Context;

❓ “Who are the children of Shiva and Parvati?”

Intent: Retrieve offspring of given pair.
Cypher:

MATCH (p1:Character {name:$parent1})-[:RELATION {type:'Consort'}]-(p2:Character {name:$parent2})
MATCH (child:Character)-[:RELATION {type:'Child Of'}]->(p1)
RETURN DISTINCT child.name AS Child, child.origin AS Origin;

💫 4. Conceptual & Symbolic Queries
❓ “Who represents Dharma?” / “Who symbolizes Bhakti?”

Intent: Retrieve characters symbolically linked to a concept.
Cypher:

MATCH (c:Character)-[:RELATION {type:'Symbolizes'}]->(con:Concept)
WHERE toLower(con.name) = toLower($concept_name)
RETURN c.name AS Character, con.name AS Concept, con.ethical_polarity AS Polarity, con.archetype AS Archetype;

❓ “What does Krishna represent?” / “What concept is Hanuman linked to?”

Intent: Retrieve symbolic or ethical associations for a character.
Cypher:

MATCH (c:Character {name:$character_name})-[r:RELATION {type:'Symbolizes'}]->(con:Concept)
RETURN con.name AS Concept, con.ethical_polarity AS Polarity, con.archetype AS Archetype, r.context AS Meaning;

📚 5. Scripture & Context Queries
❓ “In which scripture is Rama mentioned?”

Intent: Map characters to textual sources.
Cypher:

MATCH (c:Character {name:$character_name})-[:RELATION {type:'Referenced In'}]->(s:Scripture)
RETURN s.name AS Scripture, s.cultural_region AS Region;

❓ “Show all characters from the Ramayana.”

Intent: Get characters appearing in a specific scripture.
Cypher:

MATCH (s:Scripture {name:$scripture_name})<-[:RELATION {type:'Referenced In'}]-(c:Character)
RETURN c.name AS Character, c.type AS Type, c.origin AS Origin;

🔱 6. Reincarnation & Cycle Queries
❓ “Who was Rama reborn as?”

Intent: Trace reincarnation links.
Cypher:

MATCH (prev:Character {name:$character_name})-[:RELATION {type:'Reincarnation Of'}]->(next:Character)
RETURN next.name AS Reborn_As, next.origin AS Yuga, next.type AS Type;

❓ “List all avatars of Vishnu with their Yuga.”

Intent: Show incarnation cycles.
Cypher:

MATCH (a:Character)-[:RELATION {type:'Avatar Of'}]->(v:Character {name:'Vishnu'})
RETURN a.name AS Avatar, a.origin AS Yuga, a.description AS Summary
ORDER BY a.origin;

🎥 7. Media & Cultural References
❓ “Show videos about the Battle of Lanka.”

Intent: Find linked media.
Cypher:

MATCH (e:Event {name:$event_name})-[:RELATION {type:'Depicted In'}]->(m:Media)
RETURN m.media_type AS Type, m.url AS URL, m.caption AS Description;

❓ “Find all songs about Krishna.”

Intent: Find audio media tagged to a character.
Cypher:

MATCH (c:Character {name:$character_name})-[:RELATION {type:'Depicted In'}]->(m:Media)
WHERE m.media_type = 'audio'
RETURN m.url AS AudioLink, m.caption AS Title;

🕸️ 8. Discovery & Graph Traversal
❓ “Show me all connected to Rama.”

Intent: Graph traversal query for relationships.
Cypher:

MATCH path=(c:Character {name:$character_name})-[*1..3]-(related)
RETURN path LIMIT 20;

❓ “What’s the connection between Rama and Krishna?”

Intent: Find shortest semantic path.
Cypher:

MATCH path=shortestPath((a:Character {name:$character1})-[*..5]-(b:Character {name:$character2}))
RETURN path;

🧠 9. Meta / Knowledge Queries
❓ “Who has the most connections in mythology?”

Intent: Find central characters.
Cypher:

MATCH (c:Character)-[r]-()
RETURN c.name AS Character, count(r) AS Connections
ORDER BY Connections DESC
LIMIT 5;

❓ “Which relationship type appears most often?”

Intent: Find dominant relational archetypes.
Cypher:

MATCH ()-[r:RELATION]->()
RETURN r.type AS RelationshipType, count(r) AS Count
ORDER BY Count DESC;

❓ “What archetypes exist?”

Intent: List archetypal concepts and their nature.
Cypher:

MATCH (con:Concept)
RETURN DISTINCT con.archetype AS Archetype, con.ethical_polarity AS Polarity
ORDER BY Archetype;

🗣️ 10. Multilingual Support Notes
Intent Type	Hindi Example	Backend Strategy
Character Info	“राम कौन है?”	Map “राम” → “Rama” (via multilingual_aliases table)
Avatar	“विष्णु के अवतार कौन हैं?”	Use translation map: विष्णु = Vishnu
Concept	“कर्म क्या है?”	Match Concept.name via language column
Event	“कुरुक्षेत्र युद्ध में कौन लड़ा?”	Match Event.name translations

Integrate via translation tables (05_translations.sql) or NLP synonym mapping in the chatbot backend.

⚙️ Implementation Tip for Chatbot Backend
Step	Action
1️⃣	User question → intent classification (using LLM or regex)
2️⃣	Identify entities (character_name, concept_name, event_name)
3️⃣	Select Cypher template by intent
4️⃣	Replace variables ($character_name, $event_name, etc.)
5️⃣	Execute via Neo4j driver and format response
✅ Example Workflow (Node.js Backend)
import neo4j from "neo4j-driver";

const driver = neo4j.driver("bolt://localhost:7687", neo4j.auth.basic("neo4j", "neo4jpass"));
const session = driver.session();

async function getAvatarsOf(character) {
  const query = `
    MATCH (v:Character {name:$character})<-[:RELATION {type:'Avatar Of'}]-(a:Character)
    RETURN a.name AS Avatar, a.origin AS Origin
  `;
  const res = await session.run(query, { character });
  return res.records.map(r => r.get("Avatar"));
}

🧩 This document helps your team:

Train your chatbot’s prompt templates

Build query libraries for app-level features (e.g. "show Vishnu’s avatars" button)

Design multilingual question–intent mappings