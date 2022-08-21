import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monochrome_jump/game/monochrome_jump.dart';
import 'package:monochrome_jump/widgets/main_menu.dart';
import 'package:monochrome_jump/widgets/settings_menu.dart';

class CreditsMenu extends StatelessWidget {
  static const id = 'CreditsMenu';

  final MonochromeJumpGame gameRef;

  const CreditsMenu(this.gameRef, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                            gameRef.overlays.remove(CreditsMenu.id);
                            gameRef.overlays.add(MainMenu.id);
                          },
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'Credits',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Graphics',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '1-bit graphics by Kenney',
                        ),
                        Text(
                          'Audio',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Music: Red Skies by HoliznaCC0',
                        ),
                        Text(
                          'SFX by phoenix1291',
                        ),
                        Text(
                          'Coding',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Nushio',
                        ),
                        Text(
                          'Special Thanks',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Flame Engine',
                        ),
                        Text(
                          "Dev Kage's Flutter tutorials",
                        ),
                        Text(
                          'Wife & Kid! <3',
                        ),
                        Text(
                          'And YOU for playing!',
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
    );
  }
}
