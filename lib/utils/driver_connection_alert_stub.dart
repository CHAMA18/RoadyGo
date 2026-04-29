import 'package:flutter/services.dart';

Future<void> playDriverConnectionAlertImpl() async {
  await SystemSound.play(SystemSoundType.alert);
}
