import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:monochrome_jump/game/audio_manager.dart';
import 'package:monochrome_jump/game/components/terrain.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/settings.dart';
import 'package:monochrome_jump/models/terraindata.dart';

enum PlayerAnimationStates {
  jump,
  run,
}

// This represents the player
class Player extends SpriteAnimationGroupComponent<PlayerAnimationStates>
    with CollisionCallbacks, HasGameRef<MonochromeJumpGame> {
  // A map of all the animation states and their corresponding animations.
  static final _animationMap = {
    PlayerAnimationStates.jump: SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 0.1,
      textureSize: Vector2.all(16),
      // Added 0.5 padding to fix a bug.
      texturePosition: Vector2(5 * 16 + 0.5, 12 * 16 + 0.5),
    ),
    PlayerAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(16),
      // Same here.
      texturePosition: Vector2(0 * 16 + 0.5, 12 * 16 + 0.5),
    ),
  };

  double yMax = 0.0;

  double speedY = 0.0;

  static const double gravity = 900;

  final Settings settings;

  bool isOnGround = false;
  bool isJumping = false;
  int lastRandomId = 0;
  Player(Image image, this.settings)
      : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    _reset();
    // debugMode = true;
    // debugColor = Color.fromARGB(255, 12, 35, 211);
    // TODO(nushio): adjust hitbox to make it only feet.
    add(
      RectangleHitbox.relative(
        Vector2(1, 1),
        parentSize: size,
        position: Vector2(0, 0),
      ),
    );
    yMax = y;

    super.onMount();
  }

  @override
  void update(double dt) {
    // v = u + at
    speedY += gravity * dt;
    // d = s0 + s * t
    y += speedY * dt;

    if (y > gameRef.size.y + 32) {
      current = PlayerAnimationStates.jump;
      AudioManager.instance.playSfx('Ouch__002.wav');
      gameRef.gameOver();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    isOnGround = true;
    speedY = 0.0;
    if (other is Terrain) {
      isJumping = false;
      if (current != PlayerAnimationStates.run) {
        current = PlayerAnimationStates.run;
      }
      yMax = other.position.y - 32;
      if (lastRandomId != other.randomId) {
        lastRandomId = other.randomId;
        var score = 0;
        if (other.terrainData.type == TerrainType.random) {
          score = 1;
        }
        landed(score);
      }
    }
    y = yMax;
    super.onCollision(intersectionPoints, other);
  }

  void jump() {
    if (isOnGround) {
      isJumping = true;
      isOnGround = false;
      speedY = -300;
      current = PlayerAnimationStates.jump;
      AudioManager.instance.playSfx('Jump__005.wav');
    }
  }

  void landed(int score) {
    isOnGround = true;
    speedY = 0;
    current = PlayerAnimationStates.run;
    gameRef.settings.currentScore += score;
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    isJumping = false;
    anchor = Anchor.bottomLeft;
    position = Vector2(32, gameRef.size.y - 32);
    size = Vector2.all(16);
    current = PlayerAnimationStates.run;
    speedY = 0.0;
  }
}
