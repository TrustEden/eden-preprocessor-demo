import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/tactical_map.dart';
import '../models/enhanced_character.dart';
import '../models/monster.dart';

/// Enhanced tactical map visualization widget
class TacticalMapWidget extends StatefulWidget {
  final TacticalMap map;
  final List<EnhancedCharacter> characters;
  final List<Monster>? monsters;
  final String? currentTurnCombatantId;
  final String? selectedCombatantId;
  final Function(String combatantId)? onCombatantSelected;
  final Function(String combatantId, Position newPosition)? onCombatantMoved;
  final Function(Position position)? onTileSelected;
  final bool showGrid;
  final bool showMovementRange;
  final bool showLineOfSight;
  final bool fogOfWarEnabled;
  final Set<Position>? visibleTiles;

  const TacticalMapWidget({
    Key? key,
    required this.map,
    required this.characters,
    this.monsters,
    this.currentTurnCombatantId,
    this.selectedCombatantId,
    this.onCombatantSelected,
    this.onCombatantMoved,
    this.onTileSelected,
    this.showGrid = true,
    this.showMovementRange = false,
    this.showLineOfSight = false,
    this.fogOfWarEnabled = false,
    this.visibleTiles,
  }) : super(key: key);

  @override
  State<TacticalMapWidget> createState() => _TacticalMapWidgetState();
}

class _TacticalMapWidgetState extends State<TacticalMapWidget> {
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;
  String? _hoveredCombatantId;
  Position? _hoveredTile;
  List<Position>? _movementRange;
  Position? _dragStartPosition;
  String? _draggingCombatantId;

  static const double baseTileSize = 50.0;

  @override
  void didUpdateWidget(TacticalMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Recalculate movement range if selected combatant changed
    if (widget.selectedCombatantId != oldWidget.selectedCombatantId) {
      _updateMovementRange();
    }
  }

  void _updateMovementRange() {
    if (widget.selectedCombatantId == null || !widget.showMovementRange) {
      setState(() => _movementRange = null);
      return;
    }

    // Find the selected character's position
    Position? currentPos = widget.map.getCombatantPosition(widget.selectedCombatantId!);
    if (currentPos == null) return;

    // Find character's movement speed
    var character = widget.characters.firstWhere(
      (c) => c.id == widget.selectedCombatantId,
      orElse: () => widget.characters.first,
    );

    int movementFeet = character.speed;
    int movementSquares = movementFeet ~/ 5;

    setState(() {
      _movementRange = widget.map.getValidMoves(currentPos, movementSquares);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize = baseTileSize * _zoom;
        final mapWidth = widget.map.width * tileSize;
        final mapHeight = widget.map.height * tileSize;

        return GestureDetector(
          onScaleStart: (details) {
            // Start pan/zoom
          },
          onScaleUpdate: (details) {
            setState(() {
              _zoom = (_zoom * details.scale).clamp(0.5, 3.0);
              _panOffset += details.focalPointDelta;
            });
          },
          child: ClipRect(
            child: Stack(
              children: [
                // Map background
                Positioned(
                  left: _panOffset.dx,
                  top: _panOffset.dy,
                  width: mapWidth,
                  height: mapHeight,
                  child: _buildMap(tileSize),
                ),

                // Controls overlay
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildControls(),
                ),

                // Legend
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _buildLegend(),
                ),

                // Hovered tile info
                if (_hoveredTile != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _buildTileInfo(_hoveredTile!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap(double tileSize) {
    return Stack(
      children: [
        // Terrain layer
        _buildTerrainLayer(tileSize),

        // Grid overlay
        if (widget.showGrid) _buildGridOverlay(tileSize),

        // Movement range highlight
        if (_movementRange != null) _buildMovementRangeOverlay(tileSize),

        // Fog of war
        if (widget.fogOfWarEnabled) _buildFogOfWar(tileSize),

        // Combatants layer
        _buildCombatantsLayer(tileSize),

        // Selection indicator
        if (widget.selectedCombatantId != null)
          _buildSelectionIndicator(tileSize),

        // Interaction layer
        _buildInteractionLayer(tileSize),
      ],
    );
  }

  Widget _buildTerrainLayer(double tileSize) {
    return SizedBox(
      width: widget.map.width * tileSize,
      height: widget.map.height * tileSize,
      child: CustomPaint(
        painter: TerrainPainter(
          map: widget.map,
          tileSize: tileSize,
        ),
      ),
    );
  }

  Widget _buildGridOverlay(double tileSize) {
    return SizedBox(
      width: widget.map.width * tileSize,
      height: widget.map.height * tileSize,
      child: CustomPaint(
        painter: GridPainter(
          width: widget.map.width,
          height: widget.map.height,
          tileSize: tileSize,
        ),
      ),
    );
  }

  Widget _buildMovementRangeOverlay(double tileSize) {
    return SizedBox(
      width: widget.map.width * tileSize,
      height: widget.map.height * tileSize,
      child: CustomPaint(
        painter: MovementRangePainter(
          positions: _movementRange!,
          tileSize: tileSize,
        ),
      ),
    );
  }

  Widget _buildFogOfWar(double tileSize) {
    return SizedBox(
      width: widget.map.width * tileSize,
      height: widget.map.height * tileSize,
      child: CustomPaint(
        painter: FogOfWarPainter(
          width: widget.map.width,
          height: widget.map.height,
          visibleTiles: widget.visibleTiles ?? {},
          tileSize: tileSize,
        ),
      ),
    );
  }

  Widget _buildCombatantsLayer(double tileSize) {
    List<Widget> combatantWidgets = [];

    // Add player characters
    for (var character in widget.characters) {
      Position? pos = widget.map.getCombatantPosition(character.id);
      if (pos != null) {
        combatantWidgets.add(
          Positioned(
            left: pos.x * tileSize,
            top: pos.y * tileSize,
            child: _buildCombatantToken(
              character.id,
              character.name,
              tileSize,
              isPlayer: true,
              isCurrentTurn: character.id == widget.currentTurnCombatantId,
              isSelected: character.id == widget.selectedCombatantId,
            ),
          ),
        );
      }
    }

    // Add monsters
    if (widget.monsters != null) {
      for (var monster in widget.monsters!) {
        Position? pos = widget.map.getCombatantPosition(monster.id);
        if (pos != null) {
          combatantWidgets.add(
            Positioned(
              left: pos.x * tileSize,
              top: pos.y * tileSize,
              child: _buildCombatantToken(
                monster.id,
                monster.name,
                tileSize,
                isPlayer: false,
                isCurrentTurn: monster.id == widget.currentTurnCombatantId,
                isSelected: monster.id == widget.selectedCombatantId,
              ),
            ),
          );
        }
      }
    }

    return Stack(children: combatantWidgets);
  }

  Widget _buildCombatantToken(
    String id,
    String name,
    double tileSize, {
    required bool isPlayer,
    required bool isCurrentTurn,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onCombatantSelected?.call(id);
        _updateMovementRange();
      },
      onPanStart: (details) {
        if (id == widget.selectedCombatantId) {
          setState(() {
            _draggingCombatantId = id;
            _dragStartPosition = widget.map.getCombatantPosition(id);
          });
        }
      },
      onPanUpdate: (details) {
        // Visual feedback during drag
      },
      onPanEnd: (details) {
        if (_hoveredTile != null && _draggingCombatantId != null) {
          widget.onCombatantMoved?.call(_draggingCombatantId!, _hoveredTile!);
        }
        setState(() {
          _draggingCombatantId = null;
          _dragStartPosition = null;
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredCombatantId = id),
        onExit: (_) => setState(() => _hoveredCombatantId = null),
        child: Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPlayer ? Colors.blue : Colors.red,
            border: Border.all(
              color: isCurrentTurn
                  ? Colors.yellow
                  : isSelected
                      ? Colors.white
                      : Colors.black,
              width: isCurrentTurn ? 4 : 2,
            ),
            boxShadow: [
              if (isCurrentTurn || isSelected)
                BoxShadow(
                  color: (isCurrentTurn ? Colors.yellow : Colors.white)
                      .withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Text(
              name.substring(0, math.min(2, name.length)).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: tileSize * 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(double tileSize) {
    Position? pos = widget.map.getCombatantPosition(widget.selectedCombatantId!);
    if (pos == null) return const SizedBox.shrink();

    return Positioned(
      left: pos.x * tileSize,
      top: pos.y * tileSize,
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildInteractionLayer(double tileSize) {
    return Positioned.fill(
      child: GestureDetector(
        onTapDown: (details) {
          final localPos = details.localPosition;
          final tileX = (localPos.dx / tileSize).floor();
          final tileY = (localPos.dy / tileSize).floor();

          if (tileX >= 0 &&
              tileX < widget.map.width &&
              tileY >= 0 &&
              tileY < widget.map.height) {
            widget.onTileSelected?.call(Position(tileX, tileY));
          }
        },
        child: MouseRegion(
          onHover: (event) {
            final localPos = event.localPosition;
            final tileX = (localPos.dx / tileSize).floor();
            final tileY = (localPos.dy / tileSize).floor();

            if (tileX >= 0 &&
                tileX < widget.map.width &&
                tileY >= 0 &&
                tileY < widget.map.height) {
              setState(() => _hoveredTile = Position(tileX, tileY));
            }
          },
          onExit: (_) => setState(() => _hoveredTile = null),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _zoom = (_zoom * 1.2).clamp(0.5, 3.0)),
              tooltip: 'Zoom In',
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() => _zoom = (_zoom / 1.2).clamp(0.5, 3.0)),
              tooltip: 'Zoom Out',
            ),
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              onPressed: () => setState(() {
                _zoom = 1.0;
                _panOffset = Offset.zero;
              }),
              tooltip: 'Reset View',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Legend',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildLegendItem(Colors.blue, 'Player Character'),
            _buildLegendItem(Colors.red, 'Monster'),
            _buildLegendItem(Colors.grey, 'Blocking Terrain'),
            _buildLegendItem(Colors.brown, 'Difficult Terrain'),
            _buildLegendItem(Colors.orange.shade300, 'Half Cover'),
            _buildLegendItem(Colors.orange.shade700, '3/4 Cover'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTileInfo(Position tile) {
    TerrainType terrain = widget.map.terrain[tile.y][tile.x];
    String terrainName = terrain.toString().split('.').last;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tile: (${tile.x}, ${tile.y})',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Terrain: $terrainName'),
            if (widget.map.isOccupied(tile)) const Text('Occupied'),
          ],
        ),
      ),
    );
  }
}

// ==================== Custom Painters ====================

class TerrainPainter extends CustomPainter {
  final TacticalMap map;
  final double tileSize;

  TerrainPainter({required this.map, required this.tileSize});

  @override
  void paint(Canvas canvas, Size size) {
    for (int y = 0; y < map.height; y++) {
      for (int x = 0; x < map.width; x++) {
        TerrainType terrain = map.terrain[y][x];
        Color color = _getTerrainColor(terrain);

        final rect = Rect.fromLTWH(
          x * tileSize,
          y * tileSize,
          tileSize,
          tileSize,
        );

        canvas.drawRect(rect, Paint()..color = color);
      }
    }
  }

  Color _getTerrainColor(TerrainType terrain) {
    switch (terrain) {
      case TerrainType.normal:
        return Colors.grey.shade300;
      case TerrainType.difficult:
        return Colors.brown.shade300;
      case TerrainType.blocking:
        return Colors.grey.shade700;
      case TerrainType.hazard:
        return Colors.red.shade300;
      case TerrainType.halfCover:
        return Colors.orange.shade300;
      case TerrainType.threeQuartersCover:
        return Colors.orange.shade700;
      case TerrainType.fullCover:
        return Colors.grey.shade900;
      case TerrainType.water:
        return Colors.blue.shade300;
      case TerrainType.ice:
        return Colors.cyan.shade100;
    }
  }

  @override
  bool shouldRepaint(TerrainPainter oldDelegate) => false;
}

class GridPainter extends CustomPainter {
  final int width;
  final int height;
  final double tileSize;

  GridPainter({
    required this.width,
    required this.height,
    required this.tileSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;

    // Vertical lines
    for (int x = 0; x <= width; x++) {
      canvas.drawLine(
        Offset(x * tileSize, 0),
        Offset(x * tileSize, height * tileSize),
        paint,
      );
    }

    // Horizontal lines
    for (int y = 0; y <= height; y++) {
      canvas.drawLine(
        Offset(0, y * tileSize),
        Offset(width * tileSize, y * tileSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

class MovementRangePainter extends CustomPainter {
  final List<Position> positions;
  final double tileSize;

  MovementRangePainter({required this.positions, required this.tileSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var pos in positions) {
      final rect = Rect.fromLTWH(
        pos.x * tileSize,
        pos.y * tileSize,
        tileSize,
        tileSize,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(MovementRangePainter oldDelegate) =>
      positions != oldDelegate.positions;
}

class FogOfWarPainter extends CustomPainter {
  final int width;
  final int height;
  final Set<Position> visibleTiles;
  final double tileSize;

  FogOfWarPainter({
    required this.width,
    required this.height,
    required this.visibleTiles,
    required this.tileSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        Position pos = Position(x, y);
        if (!visibleTiles.contains(pos)) {
          final rect = Rect.fromLTWH(
            x * tileSize,
            y * tileSize,
            tileSize,
            tileSize,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(FogOfWarPainter oldDelegate) =>
      visibleTiles != oldDelegate.visibleTiles;
}
