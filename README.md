# AI Dungeon Master

A comprehensive single-player D&D 5e experience with an AI Dungeon Master powered by Claude.

## Overview

This Flutter desktop application provides a rich D&D 5e gaming experience where Claude acts as your Dungeon Master. Create diverse characters, explore procedurally-generated dungeons, engage in tactical grid-based combat, cast spells, complete quests, craft items, and level up through an epic adventure.

## Features

### ✅ Core Systems
- **Character Creation & Advancement**: Full multi-class character creation system with comprehensive leveling mechanics
- **AI Dungeon Master**: Claude generates dynamic narrative responses and manages complex game states
- **Turn-Based Combat**: Complete D&D 5e combat mechanics with initiative, attack rolls, damage, and tactical positioning
- **Tactical Combat Maps**: Grid-based combat with terrain types, cover systems, line-of-sight, and area-of-effect spells
- **Spell System**: Comprehensive spell database with spell slots, concentration, and spellcasting mechanics
- **Quest System**: Dynamic quest generation and tracking with quest journal UI
- **Procedural Generation**: Dungeon and encounter generation for varied gameplay
- **Loot System**: Advanced loot generation with rarity tiers and magic items
- **Crafting System**: Create items, potions, and equipment using gathered materials
- **Skill Checks**: D20 rolls with proficiency bonuses and difficulty classes
- **Experience & Leveling**: Full progression system with automatic stat increases and class features
- **Inventory Management**: Equipment system with weapons, armor, consumables, and magic items
- **Save/Load**: Robust SQLite persistence for all game state
- **Desktop Support**: Runs on Windows, macOS, and Linux

### 🎮 UI Widgets
- **Character Sheet**: Comprehensive character stat display and management
- **Dice Roller**: Interactive D20 dice rolling with modifiers
- **Spell Book**: Browse and manage character spells
- **Quest Journal**: Track active quests and objectives

### 📚 Game Content
- **Expanded Spell Database**: Large collection of D&D 5e spells
- **Monster Database**: Extensive creature collection for encounters
- **Magic Items**: Comprehensive magical equipment database

### 🔮 Future Enhancements
- Sound effects and music
- AI-generated character portraits
- Multiplayer co-op campaigns
- Mobile support (iOS and Android)
- Voice narration for DM responses
- Enhanced tactical map visualization
- Campaign sharing and import/export

## Tech Stack

- **Frontend**: Flutter 3.0+
- **Database**: SQLite (via sqflite_common_ffi for desktop)
- **AI**: Claude Sonnet 4 API
- **State Management**: Provider + StatefulWidget
- **Additional Libraries**: http, uuid, shared_preferences, path_provider

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── models/                            # Data models
│   ├── character.dart                 # Character class with stats
│   ├── game_state.dart               # Campaign state and events
│   ├── item.dart                     # Inventory items
│   ├── combat_state.dart             # Combat tracking
│   └── tactical_map.dart             # Grid-based tactical combat maps
├── services/                          # Business logic
│   ├── database_service.dart         # SQLite persistence
│   ├── claude_service.dart           # Claude API integration
│   ├── dice_service.dart             # D20 dice rolling
│   ├── combat_service.dart           # Combat mechanics
│   ├── experience_service.dart       # XP and leveling
│   ├── character_advancement.dart    # Character progression system
│   ├── quest_generation.dart         # Dynamic quest creation
│   ├── procedural_generation.dart    # Dungeon and encounter generation
│   ├── loot_generator.dart           # Item and treasure generation
│   └── crafting_system.dart          # Item crafting mechanics
├── screens/                           # UI screens
│   ├── home_screen.dart              # Campaign list/new game
│   ├── character_creation_screen.dart # Character creation wizard
│   ├── main_game_screen.dart         # Primary gameplay
│   ├── combat_screen.dart            # Turn-based tactical combat
│   └── character_sheet_screen.dart   # Character details
├── ui/                                # Reusable UI widgets
│   ├── character_sheet_widget.dart   # Character stats display
│   ├── dice_roller_widget.dart       # Interactive dice roller
│   ├── spell_book_widget.dart        # Spell management
│   └── quest_journal_widget.dart     # Quest tracking
└── data/                              # Game content databases
    ├── spell_database.dart            # Spell definitions
    ├── expanded_spell_database.dart   # Extended spell collection
    ├── magic_items.dart               # Magic item database
    ├── expanded_magic_items.dart      # Extended magic items
    └── expanded_monster_database.dart # Monster stat blocks
```

## Getting Started

### Prerequisites

1. **Flutter SDK** (3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify with: `flutter doctor`

2. **Claude API Key**
   - Get from: https://console.anthropic.com
   - You'll need to enter this when you first run the app

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eden-preprocessor-demo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Linux
   flutter run -d linux

   # For macOS
   flutter run -d macos

   # For Windows
   flutter run -d windows
   ```

### First Run

1. The app will prompt for your Claude API key
2. Enter your API key (starts with `sk-ant-...`)
3. The key is saved locally and encrypted for future sessions
4. Create a new campaign and design your character
5. Choose from various classes, races, and backgrounds
6. Customize your character's appearance, stats, and equipment
7. Begin your adventure in a procedurally-generated world!

## How to Play

### Character Creation
1. Enter your character's name and choose a character class
2. Select your character's race and background
3. Customize ability scores or use point buy/standard array
4. Choose class-specific options (fighting style, spells, etc.)
5. Start with class-appropriate equipment and gear

### Gameplay Loop
1. Read the DM's narrative description
2. Type what you want to do in the action box
3. Press "Go" or hit Enter
4. The AI DM responds to your action and updates the game state
5. Complete quests, explore dungeons, find loot, and advance your character

### Tactical Combat
- Combat starts when the DM initiates an encounter
- Initiative is rolled automatically for all combatants
- **Grid-Based Movement**: Move your character on the tactical map
- **Cover & Positioning**: Use terrain for tactical advantages (half/three-quarters/full cover)
- **Spellcasting**: Cast spells with area-of-effect targeting and line-of-sight checks
- **Opportunity Attacks**: Triggered when enemies move out of melee range
- On your turn, choose from: Attack, Cast Spell, Move, Use Item, or custom actions
- Enemies take their turns automatically
- Combat ends when all enemies or the player is defeated
- Victory awards XP and triggers loot generation

### Spells & Magic
- Spellcasters have access to the full spell database
- Manage spell slots and prepare spells
- Track concentration for ongoing spell effects
- Cast offensive, defensive, utility, and buff spells
- Use the Spell Book widget to browse and select spells

### Quests & Objectives
- Accept quests from NPCs or discover them through exploration
- Track active quests in the Quest Journal
- Complete objectives for rewards and narrative progression
- Dynamic quest generation ensures varied content

### Crafting & Loot
- Collect materials from defeated enemies and exploration
- Craft weapons, armor, potions, and magic items
- Generated loot scales with character level
- Find rare and legendary magic items

### Skill Checks
- The DM may request skill checks (e.g., "Roll Athletics check, DC 15")
- A dialog shows your d20 roll + modifiers
- Success/failure is determined automatically based on D&D 5e rules
- Results affect the narrative and unlock new options

### Character Progression
- Gain experience points (XP) from combat and quest completion
- Level up to unlock new abilities, spells, and stat improvements
- Choose multiclass options for hybrid character builds
- Track character growth through the Character Sheet widget

### Saving
- Games auto-save after each significant action
- Click the save icon in the top bar to manually save
- Load previous campaigns from the home screen
- Multiple campaign slots supported

## Character Progression

The game features a comprehensive D&D 5e-compliant leveling system:

### Experience Points
- Combat encounters award XP based on encounter difficulty
- Quest completion provides bonus XP
- Exploration and roleplay milestones grant XP

### Leveling Benefits
- **Hit Points**: Increase based on class hit dice + CON modifier
- **Proficiency Bonus**: Increases at levels 5, 9, 13, and 17
- **Ability Score Improvements**: Gain +2 to one stat or +1 to two stats at certain levels
- **Class Features**: Unlock new abilities, fighting styles, and class-specific features
- **Spell Progression**: Spellcasters gain new spell slots and access to higher-level spells
- **Multiclassing**: Option to take levels in multiple classes for hybrid builds

### Level Ranges
- **Levels 1-5**: Foundation building, core class features
- **Levels 6-10**: Significant power increases, subclass features
- **Levels 11-15**: Advanced capabilities and legendary features
- **Levels 16-20**: Epic hero status with game-changing abilities

## Database Schema

The app stores all game state in SQLite with comprehensive data persistence:

- **characters**: Character stats, abilities, classes, and multiclass data
- **game_states**: Campaign metadata and session info
- **narrative_events**: Full game history and story progression
- **inventory**: Items, equipment, and consumables
- **combat_states**: Active combat tracking with positions and turn order
- **objectives**: Quest tracking with progress and rewards
- **spells_known**: Character spell lists and prepared spells
- **spell_slots**: Spell slot tracking per character
- **tactical_maps**: Saved map states with terrain and combatant positions
- **crafting_recipes**: Available and discovered crafting formulas
- **loot_tables**: Generated loot drops and treasure
- **quest_log**: Quest history and completion states

Database location: `~/.ai_dungeon_master/ai_dungeon_master.db`

## API Usage & Cost

### Claude API Calls
- **Narrative generation**: ~500-2000 tokens per request
- **Quest generation**: ~300-800 tokens per request
- **Combat narration**: ~100-400 tokens per request
- **Enemy actions**: ~50-150 tokens per request
- **Procedural content**: ~200-600 tokens per request
- **Average game session**: 15-50 API calls depending on activity

### Estimated Costs
- Claude Sonnet 4: $3 per million input tokens, $15 per million output tokens
- Typical 1-hour session: $0.15 - $0.50
- Full campaign (levels 1-10): ~$3-10
- Extended campaign (levels 1-20): ~$8-25

### Optimization Tips
- Use spell/combat/quest caching where possible
- Batch related API calls
- Adjust narrative detail level in settings
- Pre-generate content for offline play sessions

## Development Notes

### Architecture Decisions

**SQLite for Local Storage**
- No backend infrastructure required
- Fast, reliable persistence
- Full offline capability
- Easy backup and restore
- Suitable for single-player experience

**Flutter for Cross-Platform Desktop**
- Single codebase for Windows, macOS, and Linux
- Rich UI widget ecosystem
- Excellent performance for complex UIs
- Built-in material design components

**Claude API for AI DM**
- State-of-the-art language understanding
- Contextual narrative generation
- Handles complex game state management
- Supports dynamic quest and encounter creation

**Grid-Based Tactical Combat**
- Faithful to D&D 5e's tactical positioning rules
- Supports line-of-sight, cover, and area-of-effect mechanics
- Provides strategic depth without complex 3D rendering

### Code Organization
The codebase follows a clean separation of concerns:
- **Models**: Pure data classes with serialization
- **Services**: Business logic and game rules
- **Screens**: Top-level UI components and navigation
- **Widgets**: Reusable UI components
- **Data**: Static game content (spells, monsters, items)

## Troubleshooting

### "flutter: command not found"
- Flutter SDK is not installed or not in PATH
- Follow installation guide: https://flutter.dev/docs/get-started/install

### "No supported devices connected"
- For desktop apps, you need to enable desktop support:
  ```bash
  flutter config --enable-linux-desktop
  flutter config --enable-macos-desktop
  flutter config --enable-windows-desktop
  ```

### "API Error: 401"
- Your Claude API key is invalid
- Re-enter your API key in the app settings

### "Database error"
- Delete the database file and restart:
  ```bash
  rm ~/.ai_dungeon_master/ai_dungeon_master.db
  ```

## Performance & Technical Details

### System Requirements
- **OS**: Windows 10+, macOS 10.14+, or Linux (recent distribution)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 500MB for application + database
- **Internet**: Required for Claude API calls

### Performance Notes
- Tactical map rendering optimized for grids up to 50x50
- Database queries use indexes for fast character/campaign loading
- Spell and item lookups cached in memory
- UI updates throttled for smooth animation during combat

### Thread Safety
- Database operations use connection pooling
- API calls are queued and rate-limited
- State updates synchronized to prevent race conditions

## License

This is a demonstration project. Not licensed for commercial use.

## Credits

- Built with Flutter
- Powered by Claude (Anthropic)
- D&D 5e rules by Wizards of the Coast

---

**Have fun adventuring!** 🎲⚔️🐉
