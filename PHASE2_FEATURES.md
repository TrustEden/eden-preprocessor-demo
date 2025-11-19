# Phase 2: Gameplay Depth Features

## Overview

Phase 2 transforms the AI Dungeon Master into a comprehensive **AI-Assisted DM Control Center** with deep gameplay mechanics, multiplayer support, and advanced DM tools. The core philosophy is **"AI suggests, DM decides"** - putting the human DM firmly in control while leveraging AI to enhance creativity and reduce workload.

## Architecture Changes

### From AI-First to DM-First
- **Before**: AI made decisions autonomously
- **After**: AI generates suggestions, DM approves/modifies them
- All AI features now operate in suggestion mode

### Multi-User Sessions
- Session-based architecture replacing solo gameplay
- Role-based permissions (DM, Player, Observer)
- Real-time updates via streams
- Secure session management with player connections

### Enhanced Security
- API keys stored in encrypted `flutter_secure_storage`
- Removed hardcoded AI models
- Support for multiple AI providers (Claude, OpenAI, Gemini, Local)
- Per-session AI configuration

## Getting Started

### 1. Launch the Application
```
flutter run
```

### 2. Choose Your Path

#### Option A: Multiplayer Session (Recommended)
1. Click "Multiplayer Session Lobby"
2. Create a new session as DM or join an existing one
3. DMs get the Enhanced Control Panel with all Phase 2 features
4. Players get the Player View with their character sheet

#### Option B: Solo Campaign (Legacy)
1. Click "New Campaign (Solo)"
2. Original single-player experience
3. Does not include Phase 2 features

## Phase 2 Features

### 1. Relationship System

**Purpose**: Track NPC attitudes and party dynamics with D&D-style relationship mechanics.

**Features**:
- **Attitude System**: -100 (Hostile) to +100 (Devoted)
- **Relationship Tiers**: 8 tiers from Hostile to Devoted
- **Memorable Events**: Track significant relationship moments
- **Merchant Pricing**: NPCs adjust prices based on attitude (0.5x to 2.0x)
- **Romance & Rivalry**: Special relationship states
- **Time Decay**: Relationships naturally change over time
- **Party Health**: Monitor overall party cohesion

**How to Use**:
1. Open Enhanced DM Control Panel
2. Click floating "Advanced Features" button
3. Select "Relationships" tab
4. View NPC relationship cards with attitude meters
5. Add relationship events to update attitudes
6. Monitor merchant price modifiers
7. Track memorable moments in relationship history

**Example Workflow**:
```
1. Party helps shopkeeper defend against bandits
2. DM adds relationship event: "Defended shop" (+15 attitude)
3. Shopkeeper moves from "Neutral" to "Friendly" tier
4. Merchant prices improve from 1.0x to 0.9x
5. Shopkeeper remembers event in relationship history
```

### 2. World Events System

**Purpose**: Create a living, breathing world that reacts to player actions and evolves over time.

**Features**:
- **Dynamic World Events**: 7 event types (political, natural disaster, war, economic, magical, social, mystery)
- **Event Scales**: Local, Regional, Continental, or Global impact
- **Trigger System**: Events triggered by time, location, quests, or faction standing
- **Faction Conflicts**: Track tension levels between factions (0-100)
- **Auto-Triggers**: Events automatically activate based on conditions
- **Consequences**: Multiple possible outcomes based on player intervention

**How to Use**:
1. Open "World Events" tab in Phase 2 sidebar
2. View active, upcoming, and faction conflicts
3. Trigger world events manually or let auto-triggers handle it
4. Escalate/de-escalate faction conflicts
5. Conclude events with chosen consequences
6. Track how events affect the world state

**Example Workflow**:
```
1. Create event: "Orc Invasion" (War, Regional)
2. Set trigger: "When party reaches Level 5"
3. Party levels up → Event auto-triggers
4. DM narrates orc armies approaching
5. Party intervenes, drives back orcs
6. DM concludes event with "Orcs Repelled" consequence
7. Faction standing with local kingdom improves
```

### 3. Enhanced Combat System

**Purpose**: Bring D&D 5e tactical depth with reactions, environmental hazards, and epic boss battles.

**Features**:
- **Combat Reactions**: Track opportunity attacks, counterspells, shield, etc.
- **Environmental Hazards**: Difficult terrain, traps, magical zones
- **Boss Mechanics**: Legendary actions, lair actions, phase transitions
- **Legendary Resistance**: Boss can auto-succeed on saves
- **Multi-Phase Bosses**: Bosses change tactics at HP thresholds
- **Reaction Tracking**: Ensures players can only react once per round

**How to Use**:
1. Click "Start Combat" floating action button
2. Add environmental hazards to the battlefield
3. For boss fights, configure legendary actions and phases
4. Track player reactions each round
5. Apply environmental hazard effects
6. Transition boss phases at HP thresholds

**Example Boss Fight**:
```
Dragon Boss Configuration:
- Legendary Actions: 3 per round
  * Detect (cost 1): Make Perception check
  * Tail Attack (cost 2): One attack
  * Wing Attack (cost 3): Knock prone, fly away
- Lair Actions: Every initiative 20
  * Volcanic eruption at random location
- Phases:
  * Phase 1 (100-50% HP): Aerial combat
  * Phase 2 (50-0% HP): Grounded, enraged, +2 AC
- Legendary Resistances: 3 remaining
```

### 4. Character Development System

**Purpose**: Give each character a personalized story arc tied to their backstory.

**Features**:
- **Personal Quests**: 7 quest types (revenge, redemption, legacy, discovery, love, duty, transformation)
- **Character Arcs**: Long-term narrative journeys with multiple stages
- **Growth Milestones**: Track character development and unlockable abilities
- **Time Limits**: Optional deadlines for urgent quests
- **Progress Tracking**: Visual progress bars and completion percentages
- **Character Moments**: Memorable narrative beats

**How to Use**:
1. Open "Character Development" tab
2. Create personal quests for each character
3. Add quest objectives and track progress
4. Design character arcs with multiple stages
5. Define growth milestones and rewards
6. Complete objectives as story progresses
7. Advance arc stages at narrative beats

**Example Character Arc**:
```
Character: Elara the Fallen Paladin
Quest Type: Redemption
Arc Stages:
1. "Rock Bottom" - Haunted by past failures
2. "First Steps" - Helps innocent villagers
3. "Tested" - Faces old enemies, chooses mercy
4. "Redeemed" - Regains divine powers
Growth Milestones:
- Help 10 innocent people
- Resist revenge when facing betrayer
- Perform act of true selflessness
Rewards:
- Restore paladin powers
- Unlock Divine Sense ability
```

### 5. Crafting System

**Purpose**: Allow players to create custom items with meaningful progression.

**Features**:
- **Recipe System**: Define materials, difficulty, and time required
- **Quality Scoring**: Daily checks accumulate to determine outcome quality
- **Crafting Categories**: Weapons, armor, potions, tools, magical items, art
- **Progress Tracking**: Monitor days worked and quality score
- **Failure Consequences**: Lost materials, damaged projects
- **Custom Descriptions**: Flavor text for crafted items

**How to Use**:
1. Open "Crafting & Economy" tab
2. View available recipes
3. Start crafting project for a character
4. Each day, character works on project
5. Daily check adds to quality score
6. Complete project when time requirement met
7. Quality score determines final item properties

**Example Crafting Project**:
```
Recipe: Masterwork Longsword
Materials: Steel Ingot (3), Rare Wood Handle (1)
Difficulty: 15 (Hard)
Time Required: 5 days
Quality Tiers:
- 0-10: Poor quality (-1 to hit)
- 11-20: Standard quality
- 21-30: Fine quality (+1 damage)
- 31+: Masterwork (+1 to hit, +1 damage)

Day 1: Roll 18 → Success, +1 quality
Day 2: Roll 12 → Failure, +0 quality
Day 3: Roll 22 → Critical success, +3 quality
Day 4: Roll 16 → Success, +1 quality
Day 5: Roll 19 → Success, +1 quality
Final Quality: 6 → Standard longsword
```

### 6. Dynamic Economy System

**Purpose**: Create realistic market fluctuations and merchant economies.

**Features**:
- **Supply & Demand**: Prices adjust based on availability (0-100 scale)
- **Price Modifiers**: 0.1x to 5.0x multipliers based on market conditions
- **Price Trends**: Rising, falling, or stable markets
- **Merchant Inventories**: Track stock levels and restock times
- **Market Events**: Shortages, gluts, trade disruptions
- **Daily Fluctuations**: Automatic market updates with time progression

**How to Use**:
1. Monitor market prices in "Crafting & Economy" tab
2. View supply/demand levels for items
3. Track price trends (rising/falling/stable)
4. Apply market events (e.g., "Steel shortage")
5. Automatic daily fluctuations on time advancement
6. Purchase items from merchant inventories

**Example Market Event**:
```
Event: "Bandit raids disrupt trade routes"
Effect on Steel:
- Supply: 80 → 20 (shortage)
- Demand: 50 → 75 (increased need)
- Price Modifier: 1.0x → 3.0x
- Trend: Rising

Effect on Food:
- Supply: 60 → 30 (shipments delayed)
- Demand: 50 → 70 (panic buying)
- Price Modifier: 1.2x → 2.5x
- Trend: Rising
```

### 7. DM AI Tools

**Purpose**: AI-powered assistance for creative tasks and campaign management.

**Features**:
- **NPC Generator**: Create detailed NPCs with personality, secrets, motivations
- **Consistency Checker**: Verify campaign continuity and catch contradictions
- **Campaign Analyzer**: Get insights on pacing, balance, player engagement
- **Quest Hook Generator**: Create compelling story hooks tied to campaign themes
- **Scene Suggestions**: Get AI ideas for current situation
- **Dialogue Generator**: Sample NPC conversations and responses

**How to Use**:
1. Open "AI Tools" tab in Phase 2 sidebar
2. Select tool type (NPC, Consistency, Analysis, Quest Hooks)
3. Provide context and requirements
4. Generate AI suggestions
5. Review and modify suggestions
6. Apply to campaign or save for later

**Example NPC Generation**:
```
Input:
- Role: Merchant
- Location: Port City
- Theme: Mysterious, possibly involved in smuggling

AI Output:
Name: Silas Blackwater
Personality: Charming but evasive, quick with a smile
Physical: Middle-aged human, well-dressed, jade ring
Secret: Smuggles magical artifacts for Shadow Thieves guild
Motivation: Accumulating wealth to buy noble title
Hook: Has information about cursed amulet party seeks
Voice: Smooth talker, uses sailor slang, avoids direct answers
Shop: "Blackwater's Exotic Imports" - rare goods, hidden back room

DM can then modify and add to game
```

### 8. Encounter Builder

**Purpose**: Create balanced D&D 5e encounters following official CR guidelines.

**Features**:
- **XP Calculation**: Accurate D&D 5e adjusted XP with multipliers
- **Party Thresholds**: Easy, Medium, Hard, Deadly difficulty tiers
- **Encounter Generation**: Auto-build encounters for target difficulty
- **Effective CR**: Calculate combined threat level of monster groups
- **Daily XP Budget**: Suggest number of encounters for adventuring day
- **Tactical Suggestions**: Environment-specific combat ideas

**How to Use**:
1. Define party composition (character levels)
2. Select target difficulty (Easy/Medium/Hard/Deadly)
3. Choose available monsters
4. Generate balanced encounter
5. Review adjusted XP and actual difficulty
6. Get tactical suggestions for environment
7. Apply encounter to game

**Example Encounter Build**:
```
Party: 4 characters, levels 3-4 (average level 3)
Target Difficulty: Hard
Thresholds:
- Easy: 300 XP
- Medium: 600 XP
- Hard: 900 XP
- Deadly: 1400 XP

Generated Encounter:
- 1x Ogre (CR 2, 450 XP)
- 4x Goblin (CR 1/4, 50 XP each)

Calculation:
- Base XP: 450 + (4 × 50) = 650 XP
- Monster count: 5 → Multiplier 2.0x
- Adjusted XP: 650 × 2.0 = 1300 XP
- Actual Difficulty: Hard (approaching Deadly)

Tactical Suggestions (Forest):
- Add difficult terrain or trees for cover
- Goblins use hit-and-run tactics
- Ogre charges through trees
```

## Phase 2 Sidebar

### Accessing Advanced Features
1. Open Enhanced DM Control Panel
2. Look for floating action button (bottom right)
3. Click to expand/collapse Phase 2 sidebar (400px wide)
4. Navigate between 5 tabs:
   - 🧑‍🤝‍🧑 Relationships
   - 🌍 World Events
   - 📖 Character Development
   - 🔨 Crafting & Economy
   - 🤖 AI Tools

### Layout
```
┌────────────────────────────────────────────────────┬─────────────────┐
│                                                    │                 │
│  Party Panel    Narrative Center    AI Assistant  │  Phase 2 Tabs   │
│  (300px)        (flex 3)            (flex 2)       │  (400px)        │
│                                                    │  [collapsible]  │
│                                                    │                 │
│  - Characters   - Scene description  - Suggestions │  Relationships  │
│  - HP/Status    - Action history     - Questions   │  World Events   │
│  - Initiative   - DM input           - Analysis    │  Char Dev       │
│                 - Player actions     - Config      │  Crafting       │
│                                                    │  AI Tools       │
└────────────────────────────────────────────────────┴─────────────────┘
```

## Time Advancement System

When you click "Advance Time" button, multiple systems update automatically:

1. **Game Day Counter** increments
2. **World Events** check for auto-triggers
3. **Character Quests** update time limits
4. **Relationships** apply time decay
5. **Economy** applies daily market fluctuations
6. **Crafting Projects** allow daily work progress

This creates a living world that evolves as time passes.

## Database Architecture

### Phase 2 Tables
- `npc_relationships` - NPC attitude and history
- `world_events` - Active and upcoming events
- `faction_conflicts` - Faction tension tracking
- `personal_quests` - Character-specific quests
- `character_arcs` - Long-term narrative journeys
- `crafting_projects` - Active crafting progress
- `crafting_recipes` - Available crafting patterns
- `item_pricing` - Dynamic market prices
- `merchant_inventories` - Shop stock tracking
- `environmental_hazards` - Combat hazards
- `boss_mechanics` - Legendary/lair actions

### Auto-Migration
Phase 2 tables are created automatically on first use. Existing Phase 1 data is preserved.

## AI Configuration

### Supported Providers
1. **Anthropic Claude** (Recommended)
   - Models: claude-3-opus, claude-3-sonnet, claude-3-haiku
   - Best for nuanced storytelling and complex decisions

2. **OpenAI**
   - Models: gpt-4, gpt-4-turbo, gpt-3.5-turbo
   - Good all-around performance

3. **Google Gemini**
   - Models: gemini-pro, gemini-ultra
   - Strong multimodal capabilities

4. **Local Models**
   - Custom endpoint support
   - Privacy-focused option

### Configuring AI
1. Navigate to Settings → AI Configuration
2. Select provider and model
3. Enter API key (stored securely)
4. Set temperature (0.0-2.0)
   - Lower = More consistent
   - Higher = More creative
5. Set max tokens (response length)
6. Test connection

## Best Practices

### For DMs

1. **Start Simple**: Don't enable all Phase 2 features at once
   - Session 1-2: Use basic relationship tracking
   - Session 3-5: Add world events
   - Session 6+: Introduce character arcs and crafting

2. **Let AI Suggest**: Use AI tools for inspiration, not automation
   - Review all AI-generated content before using
   - Modify suggestions to fit your campaign
   - Use AI to fill gaps, not replace creativity

3. **Track Consistently**: Update systems regularly
   - Add relationship events after significant interactions
   - Trigger world events to maintain world dynamism
   - Complete quest objectives as players progress

4. **Balance Features**: Not every session needs every system
   - Combat-heavy session: Focus on enhanced combat
   - Roleplay session: Emphasize relationships
   - Exploration: Highlight world events

### For Players

1. **Engage with Systems**: Participate in tracked mechanics
   - Build relationships with NPCs
   - Pursue personal quests
   - Craft meaningful items

2. **Communicate Goals**: Tell DM what interests you
   - Character development you want to see
   - NPCs you want to interact with more
   - Types of quests you enjoy

## Performance Considerations

- **Phase 2 Sidebar**: Collapsible to reduce screen clutter
- **Auto-Save**: Every 2 minutes to prevent data loss
- **Stream Updates**: Real-time sync for multiplayer
- **Database Indexing**: Fast session and player queries

## Migration from Phase 1

Existing solo campaigns continue to work with the "New Campaign (Solo)" option. To convert to multiplayer:

1. Load solo campaign data
2. Create new multiplayer session
3. Manually transfer character data
4. DM becomes session owner
5. Invite players to join

## Troubleshooting

### Sessions Not Loading
- Check database file permissions
- Verify `game_sessions` table exists
- Check database path in logs

### AI Not Responding
- Verify API key is set correctly
- Check internet connection
- Try different AI model
- Review API usage limits

### Players Can't Join
- Ensure session is active
- Check `player_connections` table
- Verify session ID is correct
- Check permission settings

## Future Enhancements (Beyond Phase 2)

Potential Phase 3 features:
- **Network Multiplayer**: Remote player connections
- **Voice Integration**: Text-to-speech narration
- **Map Tools**: Battle map with tokens
- **Automated Combat**: Initiative tracking, auto-calculations
- **Campaign Journal**: Auto-generated session summaries
- **Homebrew Support**: Custom rules and content
- **Asset Library**: Images, music, sound effects

## Contributing

This is a demonstration project showcasing AI-assisted development. Key files:

- **Models**: `lib/models/*.dart`
- **Services**: `lib/services/*.dart`
- **Widgets**: `lib/widgets/*.dart`
- **Screens**: `lib/screens/**/*.dart`
- **Database**: `lib/services/database_service.dart`

## License

See project LICENSE file.

## Acknowledgments

Built with Flutter, powered by AI assistance, designed for tabletop RPG enthusiasts.
