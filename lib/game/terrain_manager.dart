import 'dart:math';

import 'package:flame/components.dart';
import 'package:monochrome_jump/game/components/terrain.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/terraindata.dart';

class TerrainManager extends Component with HasGameRef<MonochromeJumpGame> {
  final List<TerrainData> _data = [];

  final Random _random = Random();

  // Timer to decide when to spawn next terrain.
  final Timer _timer = Timer(0.8, repeat: true);
  int timerCount = 0;
  TerrainManager() {
    _timer.onTick = spawnRandomTerrain;
  }

  void spawnInitialTerrain() {
    for (var i = 0; i < 14; i++) {
      final terrainData = _data.elementAt(0);
      final terrain = Terrain(terrainData, 0);

      terrain.anchor = Anchor.bottomLeft;
      terrain.position = Vector2(
        i * 32,
        gameRef.size.y,
      );

      terrain.size = terrainData.textureSize;
      gameRef.add(terrain);
    }
  }

  // Spawn a random platform.
  void spawnRandomTerrain() {
    if (timerCount > 0) {
      if (!gameRef.gameStart) {
        gameRef.gameStart = true;
      }

      final randomIndex = _random.nextInt(2);
      final terrainData = _data.elementAt(1);
      final terrain = Terrain(terrainData, _random.nextInt(65000));

      terrain.anchor = Anchor.bottomLeft;
      terrain.size = Vector2(
          32 * (32 * _random.nextInt(4) - 2), terrainData.textureSize.y);
      terrain.position = Vector2(
        gameRef.size.x,
        gameRef.size.y - (32 * randomIndex),
      );

      terrain.size = terrainData.textureSize;
      gameRef.add(terrain);
    } else {
      timerCount++;
    }
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {
      _data.addAll([
        TerrainData(
          image: gameRef.images.fromCache('monochrome_tilemap_packed.png'),
          textureSize: Vector2.all(16),
          texturePosition: Vector2(5 * 16, 5 * 16),
          type: TerrainType.starter,
        ),
        TerrainData(
          image: gameRef.images.fromCache('monochrome_tilemap_packed.png'),
          textureSize: Vector2.all(16),
          texturePosition: Vector2(5 * 16, 5 * 16),
          type: TerrainType.random,
        ),
      ]);
    }

    spawnInitialTerrain();
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllTerrain() {
    final terrains = gameRef.children.whereType<Terrain>();
    for (final terrain in terrains) {
      terrain.removeFromParent();
    }
  }
}
