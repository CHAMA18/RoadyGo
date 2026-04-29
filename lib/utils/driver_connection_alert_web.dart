// ignore_for_file: deprecated_member_use

import 'dart:html' as html;

Future<void> playDriverConnectionAlertImpl() async {
  final audio = html.AudioElement('assets/audios/driver_connected_alert.wav')
    ..preload = 'auto'
    ..volume = 0.9;

  try {
    await audio.play();
  } catch (_) {
    // Browsers may block autoplay before the user has interacted with the app.
    // The ride UI still shows the visual "ride found" alert in that case.
  }
}
