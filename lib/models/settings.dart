import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends ChangeNotifier with HiveObjectMixin {
  Settings({bool bgm = false, bool sfx = false}) {
    _bgm = bgm;
    _sfx = sfx;
  }

  @HiveField(0)
  bool _bgm = false;

  bool get bgm => _bgm;
  set bgm(bool value) {
    _bgm = value;
    notifyListeners();
    save();
  }

  @HiveField(1)
  bool _sfx = false;

  bool get sfx => _sfx;
  set sfx(bool value) {
    _sfx = value;
    notifyListeners();
    save();
  }

  @HiveField(2)
  int highScore = 0;

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    save();
  }

  int lives = 3;
}
