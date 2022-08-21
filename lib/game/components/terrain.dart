import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/terraindata.dart';

class Terrain extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MonochromeJumpGame> {
  final TerrainData terrainData;
  final int randomId;
  Terrain(this.terrainData, this.randomId) {
    sprite = Sprite(terrainData.image,
        srcSize: terrainData.textureSize,
        srcPosition: terrainData.texturePosition);

    // debugMode = true;
  }

  @override
  void onMount() {
    size *= 2;
    // TODO(nushio): Finetune this hitbot to only make it the top of the platform.
    add(
      RectangleHitbox.relative(
        Vector2(0.9, 0.4),
        parentSize: Vector2(size.x, size.y),
        position: Vector2(0, 0),
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= 80 * dt;

    // Remove the terrain
    if (position.x < -terrainData.textureSize.x - 32) {
      removeFromParent();
    }

    super.update(dt);
  }
}
