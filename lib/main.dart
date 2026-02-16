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
  static const Set<String> _supportedLanguageCodes = {
    'en',
    'sq',
    'mk',
    'tr',
    'sr',
    'hr',
    'fr',
    'de',
    'es',
    'it',
    'pt',
    'nl',
    'sv',
    'nb',
    'nn',
    'da',
    'fi',
    'pl',
    'cs',
    'sk',
    'hu',
    'ro',
    'bg',
    'el',
    'sl',
    'lt',
    'lv',
    'et',
    'is',
    'ga',
    'mt',
    'bs',
    'uk',
    'ru',
    'be',
    'ca',
    'eu',
    'gl',
    'lb',
    'cy',
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

  void setThemeMode(ThemeMode mode) {
    // FlutterFlow calls this. Persist via FFAppState so MaterialApp picks it up.
    FFAppState().themeMode = mode.name;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<FFAppState>();
    final persistedMode = appState.themeMode;
    final computedThemeMode = switch (persistedMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final selectedLanguageCode =
        _supportedLanguageCodes.contains(appState.languageCode)
            ? appState.languageCode
            : 'en';
    final materialLocale = GlobalMaterialLocalizations.delegate
            .isSupported(Locale(selectedLanguageCode))
        ? Locale(selectedLanguageCode)
        : const Locale('en');
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
        Locale('sq', ''),
        Locale('mk', ''),
        Locale('tr', ''),
        Locale('sr', ''),
        Locale('hr', ''),
        Locale('fr', ''),
        Locale('de', ''),
        Locale('es', ''),
        Locale('it', ''),
        Locale('pt', ''),
        Locale('nl', ''),
        Locale('sv', ''),
        Locale('nb', ''),
        Locale('nn', ''),
        Locale('da', ''),
        Locale('fi', ''),
        Locale('pl', ''),
        Locale('cs', ''),
        Locale('sk', ''),
        Locale('hu', ''),
        Locale('ro', ''),
        Locale('bg', ''),
        Locale('el', ''),
        Locale('sl', ''),
        Locale('lt', ''),
        Locale('lv', ''),
        Locale('et', ''),
        Locale('is', ''),
        Locale('ga', ''),
        Locale('mt', ''),
        Locale('bs', ''),
        Locale('uk', ''),
        Locale('ru', ''),
        Locale('be', ''),
        Locale('ca', ''),
        Locale('eu', ''),
        Locale('gl', ''),
        Locale('lb', ''),
        Locale('cy', ''),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        fontFamily: 'Satoshi',
        fontFamilyFallback: const [
          'Noto Sans',
          'Roboto',
          'Arial',
          'sans-serif',
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        fontFamily: 'Satoshi',
        fontFamilyFallback: const [
          'Noto Sans',
          'Roboto',
          'Arial',
          'sans-serif',
        ],
      ),
      themeMode: computedThemeMode,
      // Always keep Material widgets on a locale supported by
      // GlobalMaterialLocalizations to avoid TextField/DatePicker crashes.
      locale: materialLocale,
      routerConfig: _router,
    );
  }
}
