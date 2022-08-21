import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monochrome_jump/game/audio_manager.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/models/settings.dart';
import 'package:monochrome_jump/widgets/main_menu.dart';

class SettingsMenu extends StatelessWidget {
  static const id = 'SettingsMenu';

  final MonochromeJumpGame gameRef;

  const SettingsMenu(this.gameRef, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.settings,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.black.withAlpha(100),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.85, 0),
                          child: TextButton(
                            onPressed: () {
                              gameRef.overlays.remove(SettingsMenu.id);
                              gameRef.overlays.add(MainMenu.id);
                            },
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Selector<Settings, bool>(
                            selector: (_, settings) => settings.bgm,
                            builder: (context, bgm, __) {
                              return SwitchListTile(
                                title: const Text(
                                  'Music',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                value: bgm,
                                onChanged: (bool value) {
                                  Provider.of<Settings>(context, listen: false)
                                      .bgm = value;
                                  if (value) {
                                    AudioManager.instance
                                        .startBgm('HoliznaCC0-Red-Skies.mp3');
                                  } else {
                                    AudioManager.instance.stopBgm();
                                  }
                                },
                              );
                            },
                          ),
                          Selector<Settings, bool>(
                            selector: (_, settings) => settings.sfx,
                            builder: (context, sfx, __) {
                              return SwitchListTile(
                                title: const Text(
                                  'SFX',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                value: sfx,
                                onChanged: (bool value) {
                                  Provider.of<Settings>(context, listen: false)
                                      .sfx = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
