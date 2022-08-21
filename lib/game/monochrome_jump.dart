import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:monochrome_jump/game/audio_manager.dart';
import 'package:monochrome_jump/game/components/player.dart';
import 'package:monochrome_jump/game/terrain_manager.dart';
import 'package:monochrome_jump/models/settings.dart';
import 'package:monochrome_jump/widgets/game_over_menu.dart';
import 'package:monochrome_jump/widgets/hud.dart';
import 'package:monochrome_jump/widgets/pause_menu.dart';

class MonochromeJumpGame extends FlameGame
    with TapDetector, KeyboardEvents, HasCollisionDetection {
  static const _imageAssets = ['monochrome_tilemap_packed.png'];

  static const _audioAssets = [
    'HoliznaCC0-Red-Skies.mp3',
    'Jump__005.wav',
    'Ouch__002.wav'
  ];

  late Player _player;
  late Settings settings;
  late TerrainManager _terrainManager;
  late bool gameStart = false;

  @override
  Future<void> onLoad() async {
    Paint().isAntiAlias = false;
    settings = await _readSettings();

    await AudioManager.instance.init(_audioAssets, settings);

    AudioManager.instance.startBgm('HoliznaCC0-Red-Skies.mp3');

    await images.loadAll(_imageAssets);

    camera.viewport = FixedResolutionViewport(Vector2(360, 180));

    return super.onLoad();
  }

  void startGamePlay() {
    _player =
        Player(images.fromCache('monochrome_tilemap_packed.png'), settings);
    _terrainManager = TerrainManager();

    add(_player);
    add(_terrainManager);
  }

  void _disconnectActors() {
    _player.removeFromParent();

    _terrainManager.removeAllTerrain();
    _terrainManager.removeFromParent();
  }

  void reset() {
    gameStart = false;
    _disconnectActors();

    settings.currentScore = 0;
    settings.lives = 3;
  }

  void gameOver() {
    overlays.add(GameOverMenu.id);
    overlays.remove(Hud.id);
    pauseEngine();
    AudioManager.instance.pauseBgm();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _player.jump();
    }
    super.onTapDown(info);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      if (overlays.isActive(Hud.id)) {
        _player.jump();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('RainbowJam.SettingsMenu');
    final settings = settingsBox.get('RainbowJam.Settings');

    if (settings == null) {
      await settingsBox.put(
        'RainbowJam.Settings',
        Settings(bgm: true, sfx: true),
      );
    }
    return settingsBox.get('RainbowJam.Settings')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!overlays.isActive(PauseMenu.id) &&
            !overlays.isActive(GameOverMenu.id)) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
