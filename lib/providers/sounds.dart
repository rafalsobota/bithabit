import 'package:flutter/services.dart';

class Sounds {
  void click() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.selectionClick();
  }
}
