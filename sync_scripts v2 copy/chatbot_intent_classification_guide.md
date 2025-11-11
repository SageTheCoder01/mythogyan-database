MythoGyan AI Assistant — Intent Classification and Entity Mapping

🕉️ Overview

This document defines intent classes, keywords, and entity mappings used by the MythoGyan chatbot backend to interpret user queries.

Each intent corresponds to a Neo4j Cypher query template in chatbot_query_templates.md.

🔹 Intent Taxonomy
Category	Intent Code	Purpose
Character Info	get_character_info	Fetch details about a mythological character
Avatars	get_avatars_of_deity	List incarnations of a deity
Consorts	get_consorts_of_character	Retrieve divine or marital partners
Teachers/Students	get_teacher_of_character	Find guru–shishya lineage
Events	get_character_events	Show events a character participated in
Battles	get_event_participants	List participants of major battles
Outcomes	get_event_outcome	Return battle or event results
Family	get_parents_of_character	Show lineage or ancestry
Children	get_children_of_character	Show descendants or divine offspring
Concept Links	get_characters_by_concept	Show who symbolizes a concept (e.g., Dharma)
Symbolism	get_concepts_of_character	Show what concept a character represents
Scriptures	get_character_scriptures	Identify scriptures mentioning a character
Reincarnation	get_reincarnation_chain	Trace rebirth cycles
Media	get_media_for_entity	Link media references (video/audio)
Discovery	get_related_entities	Graph traversal for connected nodes
Shortest Path	get_connection_between_characters	Show connection between two mythological figures
Analytics	get_central_characters	List most connected or influential entities
Meta Queries	get_dominant_relationships	Find top relationship types
🧩 Intent Details and Example Phrases
🧙 Intent: get_character_info

Purpose: Retrieve general information about a character.
Cypher Template: Character Info section.

Examples:

Language	Utterance
English	“Who is Rama?”, “Tell me about Krishna.”
Hindi	“राम कौन है?”, “मुझे कृष्णा के बारे में बताओ।”
Hinglish	“Who exactly is Hanuman ji?”, “Parvati ka description batao.”

Entities:

character_name

Keywords: who, about, describe, information, कौन, बताओ

🧬 Intent: get_avatars_of_deity

Purpose: Show all avatars/incarnations of a deity.
Cypher Template: Avatars of Vishnu query.

Examples:

Language	Utterance
English	“What are the avatars of Vishnu?”, “List incarnations of Vishnu.”
Hindi	“विष्णु के अवतार कौन हैं?”, “शिव के अवतार बताओ।”
Hinglish	“Show all forms of Vishnu ji.”

Entities:

character_name

Keywords: avatar, incarnation, अवतार, form, roop

❤️ Intent: get_consorts_of_character

Purpose: Identify divine consorts/spouses.
Cypher Template: Consort relationship query.

Examples:

Language	Utterance
English	“Who is Shiva’s wife?”, “Who is the consort of Vishnu?”
Hindi	“शिव की पत्नी कौन है?”, “विष्णु की सहचरी बताओ।”
Hinglish	“Lakshmi ka pati kaun hai?”

Entities:

character_name

Keywords: wife, husband, consort, partner, spouse, पति, पत्नी

📚 Intent: get_teacher_of_character

Purpose: Guru–Shishya relationship lookup.
Examples:
| English | “Who taught Arjuna?”, “Who was Krishna’s guru?” |
| Hindi | “कृष्ण के गुरु कौन हैं?”, “अर्जुन के शिक्षक कौन हैं?” |
Entities: character_name
Keywords: teacher, guru, mentor, taught, guruji, शिक्षक

⚔️ Intent: get_character_events

Purpose: List all events/battles involving a character.
Examples:
| English | “Which battles did Rama fight in?” |
| Hindi | “राम ने कौनसे युद्ध में भाग लिया?” |
Entities: character_name
Keywords: battle, event, fight, participate, युद्ध, लड़ाई

⚔️ Intent: get_event_participants

Purpose: Show who participated in an event.
Examples:
| English | “Who fought in the Kurukshetra war?” |
| Hindi | “कुरुक्षेत्र युद्ध में कौन लड़ा?” |
Entities: event_name
Keywords: fought, participated, part of, युद्ध, लड़ा

🏆 Intent: get_event_outcome

Purpose: Retrieve event or battle outcome.
Examples:
| English | “Who won the Battle of Lanka?” |
| Hindi | “लंका युद्ध किसने जीता?” |
Entities: event_name
Keywords: win, victory, result, outcome, जीता

👪 Intent: get_parents_of_character

Purpose: Identify parents of a character.
Examples:
| English | “Who are Rama’s parents?” |
| Hindi | “राम के माता पिता कौन हैं?” |
Entities: character_name
Keywords: parents, mother, father, माता, पिता

👶 Intent: get_children_of_character

Purpose: Find children of divine couples.
Examples:
| English | “Who are the children of Shiva and Parvati?” |
| Hindi | “शिव और पार्वती के बच्चे कौन हैं?” |
Entities: character_name, character_name2
Keywords: children, sons, daughters, offspring, बच्चे

💫 Intent: get_characters_by_concept

Purpose: Show who symbolizes a concept.
Examples:
| English | “Who represents Dharma?”, “Who stands for Bhakti?” |
| Hindi | “धर्म का प्रतीक कौन है?”, “भक्ति का प्रतीक कौन है?” |
Entities: concept_name
Keywords: represent, symbolize, stand for, embodies, प्रतीक

☯️ Intent: get_concepts_of_character

Purpose: Show which concepts/virtues a character represents.
Examples:
| English | “What does Krishna represent?” |
| Hindi | “कृष्ण क्या दर्शाते हैं?” |
Entities: character_name
Keywords: represents, symbolizes, shows, virtue, दर्शाता

📜 Intent: get_character_scriptures

Purpose: Identify scriptures referencing a character.
Examples:
| English | “In which scripture is Rama mentioned?” |
| Hindi | “राम किस ग्रंथ में आता है?” |
Entities: character_name
Keywords: scripture, text, purana, granth, mentioned

🔁 Intent: get_reincarnation_chain

Purpose: Trace rebirth lineage.
Examples:
| English | “Who was Rama reborn as?” |
| Hindi | “राम का अगला जन्म कौन था?” |
Entities: character_name
Keywords: reborn, reincarnation, birth, next life, पुनर्जन्म

🎥 Intent: get_media_for_entity

Purpose: Retrieve media linked to a character or event.
Examples:
| English | “Show me videos of Krishna.”, “Audio of Kurukshetra war.” |
| Hindi | “कृष्ण के वीडियो दिखाओ।” |
Entities: entity_name, media_type
Keywords: video, audio, song, clip, video link

🕸️ Intent: get_related_entities

Purpose: Explore related entities.
Examples:
| English | “Show all related to Hanuman.” |
| Hindi | “हनुमान से जुड़े लोग दिखाओ।” |
Entities: character_name
Keywords: connected, related, associated, linked

🧩 Intent: get_connection_between_characters

Purpose: Find shortest semantic link.
Examples:
| English | “What’s the connection between Rama and Krishna?” |
| Hindi | “राम और कृष्ण का क्या संबंध है?” |
Entities: character_name1, character_name2
Keywords: relation, connection, link, संबंध

📊 Intent: get_central_characters

Purpose: Rank characters by influence.
Examples:
| English | “Who are the most important gods?”, “Who has most relationships?” |
| Hindi | “सबसे महत्वपूर्ण पात्र कौन हैं?” |
Entities: none
Keywords: important, most connected, major, मुख्य

📈 Intent: get_dominant_relationships

Purpose: Relationship frequency analysis.
Examples:
| English | “What is the most common relationship?” |
| Hindi | “सबसे आम संबंध कौन सा है?” |
Entities: none
Keywords: most common, relationship type, pattern

🧠 Entity Extraction Schema
Entity Type	Example	Extraction Source
character_name	Rama, Vishnu, Krishna	NER / Mythology lookup table
concept_name	Dharma, Karma, Bhakti	Concepts table
event_name	Kurukshetra War, Battle of Lanka	Events table
scripture_name	Ramayana, Mahabharata, Bhagavad Gita	Scriptures table
media_type	video, audio, image	Media table
🌍 Multilingual Considerations
Feature	Strategy
Transliteration	Map Hindi/Sanskrit names → canonical English (via aliases or translations)
Synonym support	Add multilingual synonyms in translations table
NLP pipeline	Use IndicBERT / multilingual BERT or spaCy with custom entity list
Mixed-language queries	Normalize inputs before intent mapping
⚙️ Backend Integration Logic
Step-by-Step (for Chatbot Middleware)

Receive user query

Normalize (lowercase, strip punctuation, transliterate if needed)

Run intent classification (keyword/LLM-based)

Extract entities (character_name, etc.)

Select Cypher template (from chatbot_query_templates.md)

Execute in Neo4j

Format response (short summary or conversational style)

Cache results for frequent questions

🚀 Example: End-to-End Workflow
User:

“विष्णु के अवतार कौन हैं?”

Backend Flow:
Step	Output
Detected Intent	get_avatars_of_deity
Extracted Entity	Vishnu
Selected Query	MATCH (v:Character {name:$character_name})<-[:RELATION {type:'Avatar Of'}]-(a:Character)...
Final Result	Rama, Krishna, Vamana, Narasimha...
Chatbot Output	“Vishnu took several avatars, including Rama and Krishna, to restore Dharma in different Yugas.”
✅ Summary
Layer	File	Purpose
💬 Natural Language → Intent	chatbot_intent_classification_guide.md	Intent taxonomy + examples
🧭 Intent → Cypher	chatbot_query_templates.md	Query library for backend
🧱 Cypher → Graph	neo4j_queries_reference.md	Advanced exploration and reasoning