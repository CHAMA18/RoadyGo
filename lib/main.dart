import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const RoadyGoApp());
}

class RoadyGoApp extends StatelessWidget {
  const RoadyGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FFAppState>.value(
      value: FFAppState(),
      child: const MyApp(),
    );
  }
}
