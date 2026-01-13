# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Build for web (primary deployment target)
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Run linter
flutter analyze

# Run tests
flutter test

# Run single test file
flutter test test/widget_test.dart

# Generate localization files (after modifying .arb files)
flutter gen-l10n
```

## Architecture Overview

This is a multi-game Flutter application targeting web deployment via Firebase Hosting.

### Entry Point & Navigation
- `lib/main.dart` - Main entry with `GameModeSelector` widget for game category selection
- Navigation: MaterialPageRoute-based hierarchical navigation
- Game flow: Category selection → Game selection → Gameplay screen

### Module Structure

**Card Games** (`lib/card_game/`)
- Mighty (마이티): 5-player Korean trick-taking game with bidding, friend declaration, and AI
- Hearts, HiLo, Hula, OneCard, Seven Card Poker
- Pattern: `screens/` + `models/` + `services/` per game

**Board Games** (`lib/board_game/games/`)
- Each game in its own directory: sudoku, tetris, minesweeper, maze, bubble, gomoku, othello, solitaire, baseball, chess, janggi
- Pattern: `*_screen.dart` + models + optional services

**Traditional Games**
- `lib/yutnori/` - Yutnori (윷놀이) with physics-based animation
- `lib/janggi/` - Janggi (장기) Korean chess

**Go (Baduk)** - In `main.dart`
- Life/Death problems (사활) with 30+ problems
- MCTS-based AI opponent

### State Management
- Provider pattern with `ChangeNotifier`
- Game controllers extend `ChangeNotifier` (e.g., `GameController`, `SevenCardController`)
- `StatsService` for player statistics

### Data Persistence
- `SharedPreferences` for game saves and statistics
- JSON serialization for game state
- Single active game save policy (memory efficient)

### Localization
- ARB files in `lib/card_game/l10n/` (ko, en, ja, zh)
- Board game strings in `lib/board_game/l10n/board_game_strings.dart`
- Use `.tr()` extension for translations

### Ad Integration
- `lib/services/web_ad_helper.dart` - Flutter ↔ JavaScript bridge for AdSense
- `web/index.html` - AdSense configuration
- Debug mode uses test ad IDs, release uses production IDs
- Ads shown on game completion screens

### Responsive Design
- Breakpoints: 600px (tablet), 900px (desktop)
- `scaleFactor` pattern for dynamic sizing
- All screens adapt to web/mobile layouts

## Firebase Configuration
- Project: `baduk-game-app`
- Hosting URL: https://baduk-game-app.web.app
- Config files: `firebase.json`, `.firebaserc`

## Key Patterns

**Adding a new game:**
1. Create directory under `lib/board_game/games/` or appropriate location
2. Implement `*_screen.dart` with game UI
3. Add models for game state
4. Add to selection screen navigation
5. Add localization strings

**Game completion ads:**
- Import `web_ad_helper.dart`
- Call `WebAdHelper.showAd()` in completion/result dialog

**AI opponents:**
- Card games use rule-based AI in services
- Go uses MCTS algorithm
- Board games use minimax or custom algorithms
