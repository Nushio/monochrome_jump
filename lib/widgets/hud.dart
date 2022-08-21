import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monochrome_jump/game/audio_manager.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/settings.dart';
import 'package:monochrome_jump/widgets/pause_menu.dart';

class Hud extends StatelessWidget {
  static const id = 'Hud';

  final MonochromeJumpGame gameRef;

  const Hud(this.gameRef, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.settings,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Selector<Settings, int>(
                  selector: (_, settings) => settings.currentScore,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  },
                ),
                Selector<Settings, int>(
                  selector: (_, settings) => settings.highScore,
                  builder: (_, highScore, __) {
                    return Text(
                      'High: $highScore',
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                gameRef.overlays.remove(Hud.id);
                gameRef.overlays.add(PauseMenu.id);
                gameRef.pauseEngine();
                AudioManager.instance.pauseBgm();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
            // Selector<Settings, int>(
            //   selector: (_, settings) => settings.lives,
            //   builder: (_, lives, __) {
            //     return Row(
            //       children: List.generate(3, (index) {
            //         if (index < lives) {
            //           return const Icon(
            //             Icons.favorite,
            //             color: Colors.red,
            //           );
            //         } else {
            //           return const Icon(
            //             Icons.favorite_border,
            //             color: Colors.red,
            //           );
            //         }
            //       }),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
