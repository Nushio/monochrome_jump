import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/settings.dart';
import 'package:monochrome_jump/utils/enums.dart';
import 'package:monochrome_jump/widgets/credits_menu.dart';
import 'package:monochrome_jump/widgets/game_over_menu.dart';
import 'package:monochrome_jump/widgets/hud.dart';
import 'package:monochrome_jump/widgets/main_menu.dart';
import 'package:monochrome_jump/widgets/pause_menu.dart';
import 'package:monochrome_jump/widgets/settings_menu.dart';

MonochromeJumpGame _monochromeJumpGame = MonochromeJumpGame();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Makes the game full screen and landscape only.
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  await initHive();
  runApp(const MonochromeJumpApp());
}

Future<void> initHive() async {
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter<Settings>(SettingsAdapter());
}

class MonochromeJumpApp extends StatelessWidget {
  const MonochromeJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monochrome Jump',
      theme: ThemeData(
        fontFamily: 'Silkscreen',
        primarySwatch: materialWhite,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          headline1: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline6: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget(
          loadingBuilder: (conetxt) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          overlayBuilderMap: {
            MainMenu.id: (_, MonochromeJumpGame gameRef) => MainMenu(gameRef),
            PauseMenu.id: (_, MonochromeJumpGame gameRef) => PauseMenu(gameRef),
            Hud.id: (_, MonochromeJumpGame gameRef) => Hud(gameRef),
            GameOverMenu.id: (_, MonochromeJumpGame gameRef) =>
                GameOverMenu(gameRef),
            CreditsMenu.id: (_, MonochromeJumpGame gameRef) =>
                CreditsMenu(gameRef),
            SettingsMenu.id: (_, MonochromeJumpGame gameRef) =>
                SettingsMenu(gameRef),
          },
          initialActiveOverlays: const [MainMenu.id],
          game: _monochromeJumpGame,
        ),
      ),
    );
  }
}
