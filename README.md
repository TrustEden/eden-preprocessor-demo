# AI Dungeon Master - MVP

A minimal viable product for a single-player D&D 5e experience with an AI Dungeon Master powered by Claude.

## Overview

This Flutter desktop application provides a complete D&D 5e gaming experience where Claude acts as your Dungeon Master. Create a Fighter character, explore narratively-driven adventures, engage in turn-based combat, and level up from 1-5.

## Features

### ✅ Implemented (MVP)
- **Character Creation**: Create a Fighter character with customizable fighting style
- **AI Dungeon Master**: Claude generates dynamic narrative responses to player actions
- **Turn-Based Combat**: Full D&D 5e combat mechanics with initiative, attack rolls, and damage
- **Skill Checks**: D20 rolls with proficiency bonuses and difficulty classes
- **Experience & Leveling**: Gain XP and level up from 1-5 with automatic stat increases
- **Inventory System**: Equipment management with weapons, armor, and consumables
- **Save/Load**: SQLite persistence for campaign state
- **Desktop Support**: Runs on Windows, macOS, and Linux

### ❌ Not in MVP (Future Enhancements)
- Multiple character classes (only Fighter available)
- Spell system
- Procedural dungeon generation
- Tactical combat maps
- NPC generator
- Quest system
- Sound/music
- Character portraits
- Multiplayer

## Tech Stack

- **Frontend**: Flutter 3.0+
- **Database**: SQLite (via sqflite_common_ffi for desktop)
- **AI**: Claude Sonnet 4 API
- **State Management**: StatefulWidget (Provider removed for simplicity)

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── models/                            # Data models
│   ├── character.dart                 # Character class with stats
│   ├── game_state.dart               # Campaign state and events
│   ├── item.dart                     # Inventory items
│   └── combat_state.dart             # Combat tracking
├── services/                          # Business logic
│   ├── database_service.dart         # SQLite persistence
│   ├── claude_service.dart           # Claude API integration
│   ├── dice_service.dart             # D20 dice rolling
│   ├── combat_service.dart           # Combat mechanics
│   └── experience_service.dart       # XP and leveling
└── screens/                           # UI screens
    ├── home_screen.dart              # Campaign list/new game
    ├── character_creation_screen.dart # Create Fighter
    ├── main_game_screen.dart         # Primary gameplay
    ├── combat_screen.dart            # Turn-based combat
    └── character_sheet_screen.dart   # Character details
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
3. The key is saved locally for future sessions
4. Create a new campaign and your Fighter character
5. Begin your adventure!

## How to Play

### Character Creation
1. Enter your character's name
2. Choose a fighting style:
   - **Defense**: +1 AC while wearing armor
   - **Dueling**: +2 damage with one-handed weapons
3. Your ability scores are pre-set using the standard array
4. You start with Longsword, Chain Mail, Shield, and 2 Healing Potions

### Gameplay Loop
1. Read the DM's narrative description
2. Type what you want to do in the action box
3. Press "Go" or hit Enter
4. The AI DM responds to your action
5. Repeat!

### Combat
- Combat starts when the DM says "COMBAT_START:"
- Initiative is rolled automatically
- On your turn, click "Attack" to swing your weapon
- Enemies take their turns automatically
- Combat ends when all enemies or the player is defeated
- Victory awards XP!

### Skill Checks
- The DM may request skill checks (e.g., "Roll Athletics check, DC 15")
- A dialog shows your d20 roll + modifiers
- Success/failure is determined automatically
- Results affect the narrative

### Saving
- Games auto-save after each action
- Click the save icon in the top bar to manually save
- Load previous campaigns from the home screen

## Character Progression

### Level 1
- HP: 10 + CON modifier
- Proficiency Bonus: +2
- Features: Fighting Style, Second Wind

### Level 2 (300 XP)
- HP increases by ~7
- Gains: Action Surge

### Level 3 (900 XP)
- HP increases by ~7
- Gains: Martial Archetype (not implemented in MVP)

### Level 4 (2,700 XP)
- HP increases by ~7
- Ability Score Improvement: +2 Strength
- Proficiency Bonus: +2

### Level 5 (6,500 XP)
- HP increases by ~7
- Proficiency Bonus: +3
- Gains: Extra Attack (attack twice per turn)

## Database Schema

The app stores all game state in SQLite:

- **characters**: Character stats and abilities
- **game_states**: Campaign metadata
- **narrative_events**: Full game history
- **inventory**: Items and equipment
- **combat_states**: Active combat tracking
- **objectives**: Quest/goal tracking

Database location: `~/.ai_dungeon_master/ai_dungeon_master.db`

## API Usage & Cost

### Claude API Calls
- **Narrative generation**: ~500-1500 tokens per request
- **Enemy actions**: ~50 tokens per request
- **Average game session**: 10-30 API calls

### Estimated Costs
- Claude Sonnet 4: $3 per million input tokens, $15 per million output tokens
- Typical 1-hour session: $0.10 - $0.30
- Full campaign (levels 1-5): ~$2-5

## Development Notes

### Why Fighter Only?
Fighters are the simplest D&D class - no spells, straightforward mechanics. This makes them perfect for an MVP. Other classes can be added later.

### Why No Tactical Map?
"Theater of the mind" combat keeps the MVP scope manageable. The AI DM describes positioning narratively.

### Why SQLite Instead of Cloud?
For an MVP, local storage is simpler and faster. No backend needed.

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

## Future Enhancements

After MVP validation, potential additions:

1. **More Classes**: Wizard, Rogue, Cleric, etc.
2. **Spell System**: Full D&D 5e spellcasting
3. **Procedural Generation**: Random dungeons and encounters
4. **Tactical Combat**: Grid-based combat map
5. **Character Art**: AI-generated character portraits
6. **Voice Narration**: Text-to-speech for DM responses
7. **Multiplayer**: Co-op campaigns
8. **Mobile Support**: iOS and Android versions

## License

This is a demonstration project. Not licensed for commercial use.

## Credits

- Built with Flutter
- Powered by Claude (Anthropic)
- D&D 5e rules by Wizards of the Coast

---

**Have fun adventuring!** 🎲⚔️🐉
