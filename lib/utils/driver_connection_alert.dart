import 'package:flutter/services.dart';

import 'driver_connection_alert_stub.dart'
    if (dart.library.js_interop) 'driver_connection_alert_web.dart';

Future<void> playDriverConnectionAlert() async {
  await playDriverConnectionAlertImpl();
  await HapticFeedback.mediumImpact();
}
