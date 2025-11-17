import 'dart:math';

class Position {
  int x;
  int y;

  Position(this.x, this.y);

  int distanceTo(Position other) {
    // Grid distance in feet (5 feet per square)
    return (max((x - other.x).abs(), (y - other.y).abs())) * 5;
  }

  int manhattanDistanceTo(Position other) {
    // Manhattan distance for movement cost
    return ((x - other.x).abs() + (y - other.y).abs());
  }

  bool isAdjacent(Position other) {
    return (x - other.x).abs() <= 1 && (y - other.y).abs() <= 1;
  }

  @override
  bool operator ==(Object other) {
    if (other is! Position) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Position.fromJson(Map<String, dynamic> json) =>
      Position(json['x'] as int, json['y'] as int);
}

enum TerrainType {
  normal, // No special effect
  difficult, // Costs 2 movement per square
  blocking, // Impassable (walls, etc.)
  hazard, // Dangerous (lava, spikes, etc.)
  halfCover, // Grants +2 AC
  threeQuartersCover, // Grants +5 AC
  fullCover, // Can't be targeted
  water, // Difficult terrain, some effects
  ice, // Slippery (potential effects)
}

class TacticalMap {
  int width;
  int height;
  List<List<TerrainType>> terrain;
  Map<String, Position> combatantPositions; // combatantId -> Position

  TacticalMap({
    required this.width,
    required this.height,
    List<List<TerrainType>>? terrain,
    Map<String, Position>? combatantPositions,
  })  : terrain = terrain ??
            List.generate(
              height,
              (_) => List.filled(width, TerrainType.normal),
            ),
        combatantPositions = combatantPositions ?? {};

  bool isInBounds(Position pos) {
    return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height;
  }

  bool isOccupied(Position pos) {
    return combatantPositions.values.any((p) => p == pos);
  }

  bool isBlocked(Position pos) {
    if (!isInBounds(pos)) return true;
    if (terrain[pos.y][pos.x] == TerrainType.blocking) return true;
    return false;
  }

  bool isPassable(Position pos, {bool throughAllies = true}) {
    if (!isInBounds(pos)) return false;
    if (terrain[pos.y][pos.x] == TerrainType.blocking) return false;
    if (terrain[pos.y][pos.x] == TerrainType.fullCover) return false;

    // Can move through ally spaces but can't stop there
    if (!throughAllies && isOccupied(pos)) return false;

    return true;
  }

  int getMovementCost(Position pos) {
    if (!isInBounds(pos)) return 999;
    if (isBlocked(pos)) return 999;

    switch (terrain[pos.y][pos.x]) {
      case TerrainType.difficult:
      case TerrainType.water:
        return 2; // Costs 2 movement per square
      default:
        return 1;
    }
  }

  List<Position> getValidMoves(Position start, int movementRemaining) {
    // BFS to find all reachable positions
    List<Position> validMoves = [];
    Map<Position, int> visited = {start: 0};
    List<Position> queue = [start];

    while (queue.isNotEmpty) {
      Position current = queue.removeAt(0);
      int currentCost = visited[current]!;

      // Check all adjacent squares (including diagonals)
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx == 0 && dy == 0) continue;

          Position next = Position(current.x + dx, current.y + dy);

          // Diagonal movement costs the same in D&D 5e
          int moveCost = getMovementCost(next);
          int totalCost = currentCost + moveCost;

          if (totalCost > movementRemaining) continue;
          if (visited.containsKey(next)) continue;
          if (!isPassable(next)) continue;

          visited[next] = totalCost;
          queue.add(next);

          // Can't stop in occupied squares (but can move through allies)
          if (!isOccupied(next)) {
            validMoves.add(next);
          }
        }
      }
    }

    return validMoves;
  }

  bool hasLineOfSight(Position from, Position to) {
    // Bresenham's line algorithm to check LOS
    List<Position> line = _getLine(from, to);

    for (var pos in line) {
      if (pos == from || pos == to) continue; // Start and end don't block

      TerrainType t = terrain[pos.y][pos.x];
      if (t == TerrainType.blocking || t == TerrainType.fullCover) {
        return false;
      }
    }

    return true;
  }

  List<Position> _getLine(Position from, Position to) {
    // Bresenham's line algorithm
    List<Position> line = [];

    int x0 = from.x;
    int y0 = from.y;
    int x1 = to.x;
    int y1 = to.y;

    int dx = (x1 - x0).abs();
    int dy = (y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      line.add(Position(x0, y0));

      if (x0 == x1 && y0 == y1) break;

      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x0 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y0 += sy;
      }
    }

    return line;
  }

  CoverType getCover(Position attacker, Position target) {
    // Check if there's cover between attacker and target
    List<Position> line = _getLine(attacker, target);

    bool hasHalfCover = false;
    bool hasThreeQuartersCover = false;

    for (var pos in line) {
      if (pos == attacker || pos == target) continue;

      TerrainType t = terrain[pos.y][pos.x];
      if (t == TerrainType.fullCover) {
        return CoverType.full;
      } else if (t == TerrainType.threeQuartersCover) {
        hasThreeQuartersCover = true;
      } else if (t == TerrainType.halfCover) {
        hasHalfCover = true;
      }
    }

    if (hasThreeQuartersCover) return CoverType.threeQuarters;
    if (hasHalfCover) return CoverType.half;
    return CoverType.none;
  }

  int getCoverBonus(CoverType cover) {
    switch (cover) {
      case CoverType.half:
        return 2;
      case CoverType.threeQuarters:
        return 5;
      case CoverType.full:
        return 999; // Can't target
      case CoverType.none:
        return 0;
    }
  }

  List<Position> getAreaOfEffect(Position center, String shape, int size) {
    List<Position> affected = [];

    switch (shape) {
      case 'sphere':
        affected = _getSphereArea(center, size);
        break;
      case 'cone':
        // Simplified cone - would need direction parameter in real implementation
        affected = _getConeArea(center, size);
        break;
      case 'line':
        // Would need direction parameter in real implementation
        affected = _getLineArea(center, size);
        break;
      case 'cube':
        affected = _getCubeArea(center, size);
        break;
      case 'cylinder':
        affected = _getCylinderArea(center, size);
        break;
    }

    return affected;
  }

  List<Position> _getSphereArea(Position center, int radiusFeet) {
    List<Position> positions = [];
    int radiusSquares = radiusFeet ~/ 5;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        Position pos = Position(x, y);
        // Use Euclidean distance for spheres
        double dist = sqrt(pow(x - center.x, 2) + pow(y - center.y, 2));
        if (dist <= radiusSquares) {
          positions.add(pos);
        }
      }
    }

    return positions;
  }

  List<Position> _getConeArea(Position origin, int lengthFeet) {
    // Simplified cone facing "north" - in real implementation would need direction
    List<Position> positions = [];
    int lengthSquares = lengthFeet ~/ 5;

    for (int dist = 1; dist <= lengthSquares; dist++) {
      int width = dist; // Cone widens
      for (int offset = -width; offset <= width; offset++) {
        Position pos = Position(origin.x + offset, origin.y - dist);
        if (isInBounds(pos)) {
          positions.add(pos);
        }
      }
    }

    return positions;
  }

  List<Position> _getLineArea(Position origin, int lengthFeet) {
    // Simplified line facing "north" - in real implementation would need direction
    List<Position> positions = [];
    int lengthSquares = lengthFeet ~/ 5;

    for (int dist = 1; dist <= lengthSquares; dist++) {
      Position pos = Position(origin.x, origin.y - dist);
      if (isInBounds(pos)) {
        positions.add(pos);
      }
    }

    return positions;
  }

  List<Position> _getCubeArea(Position corner, int sizeFeet) {
    List<Position> positions = [];
    int sizeSquares = sizeFeet ~/ 5;

    for (int y = corner.y; y < corner.y + sizeSquares; y++) {
      for (int x = corner.x; x < corner.x + sizeSquares; x++) {
        Position pos = Position(x, y);
        if (isInBounds(pos)) {
          positions.add(pos);
        }
      }
    }

    return positions;
  }

  List<Position> _getCylinderArea(Position center, int radiusFeet) {
    // Same as sphere for 2D representation
    return _getSphereArea(center, radiusFeet);
  }

  void moveCombatant(String combatantId, Position newPosition) {
    if (isPassable(newPosition, throughAllies: false)) {
      combatantPositions[combatantId] = newPosition;
    }
  }

  void addCombatant(String combatantId, Position position) {
    combatantPositions[combatantId] = position;
  }

  void removeCombatant(String combatantId) {
    combatantPositions.remove(combatantId);
  }

  Position? getCombatantPosition(String combatantId) {
    return combatantPositions[combatantId];
  }

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'terrain': terrain
            .map((row) => row.map((t) => t.index).toList())
            .toList(),
        'combatantPositions': combatantPositions.map(
          (id, pos) => MapEntry(id, pos.toJson()),
        ),
      };

  factory TacticalMap.fromJson(Map<String, dynamic> json) {
    return TacticalMap(
      width: json['width'] as int,
      height: json['height'] as int,
      terrain: (json['terrain'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((t) => TerrainType.values[t as int])
              .toList())
          .toList(),
      combatantPositions: (json['combatantPositions'] as Map<String, dynamic>)
          .map(
        (id, pos) =>
            MapEntry(id, Position.fromJson(pos as Map<String, dynamic>)),
      ),
    );
  }

  // Generate a simple arena-style map
  static TacticalMap generateArena(int width, int height) {
    TacticalMap map = TacticalMap(width: width, height: height);

    // Add walls around the edge
    for (int x = 0; x < width; x++) {
      map.terrain[0][x] = TerrainType.blocking;
      map.terrain[height - 1][x] = TerrainType.blocking;
    }
    for (int y = 0; y < height; y++) {
      map.terrain[y][0] = TerrainType.blocking;
      map.terrain[y][width - 1] = TerrainType.blocking;
    }

    // Add some scattered cover
    Random rng = Random();
    int coverCount = (width * height) ~/ 20;
    for (int i = 0; i < coverCount; i++) {
      int x = rng.nextInt(width - 2) + 1;
      int y = rng.nextInt(height - 2) + 1;

      if (rng.nextDouble() < 0.3) {
        map.terrain[y][x] = TerrainType.threeQuartersCover;
      } else {
        map.terrain[y][x] = TerrainType.halfCover;
      }
    }

    // Add some difficult terrain
    int difficultCount = (width * height) ~/ 30;
    for (int i = 0; i < difficultCount; i++) {
      int x = rng.nextInt(width - 2) + 1;
      int y = rng.nextInt(height - 2) + 1;
      map.terrain[y][x] = TerrainType.difficult;
    }

    return map;
  }
}

enum CoverType {
  none,
  half, // +2 AC
  threeQuarters, // +5 AC
  full, // Can't be targeted
}

class OpportunityAttackManager {
  /// Check if moving from one position to another triggers opportunity attacks
  static List<String> checkOpportunityAttacks(
    String movingCombatantId,
    Position from,
    Position to,
    Map<String, Position> enemyPositions,
    Map<String, bool> hasReaction,
    bool hasDisengage,
  ) {
    if (hasDisengage) return [];

    List<String> triggeredEnemies = [];

    for (var entry in enemyPositions.entries) {
      String enemyId = entry.key;
      Position enemyPos = entry.value;

      // Skip if enemy has no reaction
      if (hasReaction[enemyId] == false) continue;

      // Check if moving out of reach
      bool wasInReach = from.distanceTo(enemyPos) <= 5;
      bool isInReach = to.distanceTo(enemyPos) <= 5;

      if (wasInReach && !isInReach) {
        triggeredEnemies.add(enemyId);
      }
    }

    return triggeredEnemies;
  }
}
