import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  static const Set<String> _supportedLanguageCodes = {
    'en',
    'es',
    'fr',
    'de',
    'pt',
    'it',
    'nl',
    'sv',
    'nb',
    'da',
    'fi',
    'pl',
    'cs',
    'sk',
    'hu',
    'ro',
    'bg',
    'el',
    'hr',
    'sr',
    'sl',
    'lt',
    'lv',
    'et',
    'ga',
    'mt',
    'ar',
  };

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = goTaxiRiderFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FFAppState().themeMode = mode.name;
      });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<FFAppState>();
    final persistedMode = appState.themeMode;
    final computedThemeMode = switch (persistedMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final appLocale = _supportedLanguageCodes.contains(appState.languageCode)
        ? Locale(appState.languageCode)
        : null;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RoadyGo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fr', ''),
        Locale('de', ''),
        Locale('pt', ''),
        Locale('it', ''),
        Locale('nl', ''),
        Locale('sv', ''),
        // Norwegian (Bokmal). 'no' is a legacy/ambiguous tag and can break
        // locale resolution on some platforms.
        Locale('nb', ''),
        Locale('da', ''),
        Locale('fi', ''),
        Locale('pl', ''),
        Locale('cs', ''),
        Locale('sk', ''),
        Locale('hu', ''),
        Locale('ro', ''),
        Locale('bg', ''),
        Locale('el', ''),
        Locale('hr', ''),
        Locale('sr', ''),
        Locale('sl', ''),
        Locale('lt', ''),
        Locale('lv', ''),
        Locale('et', ''),
        Locale('ga', ''),
        Locale('mt', ''),
        Locale('ar', ''),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        fontFamily: 'Satoshi',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        fontFamily: 'Satoshi',
      ),
      themeMode: computedThemeMode,
      // Guard against invalid/unknown persisted language codes (Web asserts are brutal).
      locale: appLocale,
      routerConfig: _router,
    );
  }
}
